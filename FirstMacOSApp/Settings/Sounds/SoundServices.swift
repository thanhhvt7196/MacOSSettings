//
//  SoundServices.swift
//  FirstMacOSApp
//
//  Created by macbook on 6/9/25.
//

import Foundation
import AVFoundation
import AppKit

actor SoundServices {
    static let defaultOutputName = "Selected Sound Output Device"
    static let unknownOutputName = "Unknown Device"
    static let shared = SoundServices()
    
    private let kBeepKey = "com.apple.sound.beep.sound"
    
    private init() {
        
    }
    
    var alertSounds: [AlertSound] = []
    var outputDevices: [AudioDevice] = []
    private var soundNameMaps: [String: String] = [:]
    private var currentSound: NSSound?
    
    func loadData() {
        alertSounds = getSystemAlertSounds()
        outputDevices = getOutputDevices()
    }
    
    private let alertSoundExts: Set<String> = ["aiff","aif","caf","wav","m4a","mp3"]
    
    private func getSystemAlertSounds() -> [AlertSound] {
        soundNameMaps = loadAlertSoundDisplayMap()
        let directory = URL(filePath: "/System/Library/Sounds", directoryHint: .isDirectory, relativeTo: nil)
        
        let urls = (try? FileManager.default.contentsOfDirectory(
                at: directory,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )) ?? []
        
        var items: [AlertSound] = []
        
        for url in urls where alertSoundExts.contains(url.pathExtension.lowercased()) {
            let fileName = url.deletingPathExtension().lastPathComponent
            let name = soundNameMaps[fileName] ?? fileName
            items.append(AlertSound(name: name, url: url))
        }
        return items.sorted(by: { $0.name < $1.name })
    }
    
    private func loadAlertSoundDisplayMap(preferredLang: String? = nil) -> [String:String] {
        let extURL = URL(filePath: "/System/Library/ExtensionKit/Extensions/Sound.appex")
        guard let bundle = Bundle(url: extURL),
              let loctableURL = bundle.url(forResource: "AlertSounds", withExtension: "loctable"),
              let data = try? Data(contentsOf: loctableURL),
              let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
              let root = plist as? [String: Any]
        else { return [:] }

        let langs = preferredLang.map { [$0] } ?? Locale.preferredLanguages.map {
            $0.split(separator: "-").first.map(String.init) ?? $0
        } + ["en"]

        for lang in langs {
            if let dict = root[lang] as? [String:String] { return dict }
        }
        return [:]
    }
    
    func getCurrentAlertSound() -> AlertSound? {
        guard let url = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain)?[kBeepKey] as? String else {
            return nil
        }
        
        print("url 1 = \(url)")

        guard let name = URL(string: url)?.deletingPathExtension().lastPathComponent, let fileName = soundNameMaps[name] else {
            return nil
        }
        
        return alertSounds.first(where: { $0.name == fileName })
    }
    
    @discardableResult
    func setCurrentAlert(sound: AlertSound) -> Bool {
        playSound(url: sound.url)
        CFPreferencesSetValue(
            kBeepKey as CFString,
            sound.url.path() as CFString,
            kCFPreferencesAnyApplication,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
        
        return CFPreferencesSynchronize(
            kCFPreferencesAnyApplication,
            kCFPreferencesCurrentUser,
            kCFPreferencesAnyHost
        )
    }
    
    func playSound(url: URL) {
        if let currentSound = currentSound {
            currentSound.stop()
        }
        let sound = NSSound(contentsOf: url, byReference: true)
        sound?.volume = 1
        sound?.play()
        currentSound = sound
    }
    
    func defaultOutputId() -> AudioObjectID {
        var id = kAudioObjectUnknown
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var size = UInt32(MemoryLayout<AudioObjectID>.size)
        AudioObjectGetPropertyData(
            .init(kAudioObjectSystemObject),
            &address,
            0,
            nil,
            &size,
            &id
        )
        
        return id
    }
    
    func getOutputDevices() -> [AudioDevice] {
        let systemObject = AudioObjectID(kAudioObjectSystemObject)
        
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        var dataSize: UInt32 = 0
        guard AudioObjectGetPropertyDataSize(systemObject, &address, 0, nil, &dataSize) == noErr else { return [] }
        var ids = Array(repeating: AudioObjectID(), count: Int(dataSize) / MemoryLayout<AudioObjectID>.size)
        AudioObjectGetPropertyData(systemObject, &address, 0, nil, &dataSize, &ids)
        
        let defaultOutput = defaultOutputId()
        var results = [AudioDevice]()
        
        for id in ids {
            var streamConfigAddress = AudioObjectPropertyAddress(
                mSelector: kAudioDevicePropertyStreamConfiguration,
                mScope: kAudioDevicePropertyScopeOutput,
                mElement: kAudioObjectPropertyElementMain
            )
            
            var streamConfigSize: UInt32 = 0
            guard AudioObjectGetPropertyDataSize(id, &streamConfigAddress, 0, nil, &streamConfigSize) == noErr, streamConfigSize > 0 else {
                continue
            }
            let buffer = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: 1)
            defer {
                buffer.deallocate()
            }
            guard AudioObjectGetPropertyData(id, &streamConfigAddress, 0, nil, &streamConfigSize, buffer) == noErr, buffer.pointee.mNumberBuffers > 0 else {
                continue
            }
            
            let name = stringProperty(id, selector: kAudioObjectPropertyName) ?? ""
            let uid  = stringProperty(id, selector: kAudioDevicePropertyDeviceUID) ?? ""
            
            results.append(.init(id: id, uid: uid, name: name, isDefault: id == defaultOutput))
        }
        return results.sorted {
            ($0.isDefault ? 0 : 1, $0.name.lowercased()) <
                ($1.isDefault ? 0 : 1, $1.name.lowercased())
        }
    }
    
    @inline(__always)
    private func stringProperty(_ id: AudioObjectID,
                                selector: AudioObjectPropertySelector,
                                scope: AudioObjectPropertyScope = kAudioObjectPropertyScopeGlobal)
    -> String? {
        var addr = AudioObjectPropertyAddress(
            mSelector: selector,
            mScope: scope,
            mElement: kAudioObjectPropertyElementMain
        )

        var ref: Unmanaged<CFString>?
        var size = UInt32(MemoryLayout<Unmanaged<CFString>?>.size)

        let status = withUnsafeMutablePointer(to: &ref) { ptr in
            AudioObjectGetPropertyData(id, &addr, 0, nil, &size, ptr)
        }
        guard status == noErr, let cf = ref?.takeUnretainedValue() else { return nil }
        return cf as String
    }
    
    private func audioID(for selector: AudioObjectPropertySelector) -> AudioObjectID {
        var id = kAudioObjectUnknown
        var addr = AudioObjectPropertyAddress(
            mSelector: selector,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        var size = UInt32(MemoryLayout<AudioObjectID>.size)
        _ = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &addr, 0, nil, &size, &id)
        return id
    }

    private func getDefaultOutputId() -> AudioObjectID {
        audioID(for: kAudioHardwarePropertyDefaultOutputDevice)
    }
    
    private func getSystemOutputId() -> AudioObjectID {
        audioID(for: kAudioHardwarePropertyDefaultSystemOutputDevice)
    }
    
    func getCurrentOutputId() -> String {
        let defaultOutput = defaultOutputId()
        let systemOutput = getSystemOutputId()
        
        if defaultOutput == systemOutput {
            return SoundServices.defaultOutputName
        } else {
            return stringProperty(systemOutput, selector: kAudioObjectPropertyName) ?? SoundServices.unknownOutputName
        }
    }
}
