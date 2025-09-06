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
    static let shared = SoundServices()
    
    private let kBeepKey = "com.apple.sound.beep.sound"
    
    private init() {
        
    }
    
    var alertSounds: [AlertSound] = []
    private var soundNameMaps: [String: String] = [:]
    private var currentSound: NSSound?
    
    func loadData() {
        alertSounds = getSystemAlertSounds()
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
}
