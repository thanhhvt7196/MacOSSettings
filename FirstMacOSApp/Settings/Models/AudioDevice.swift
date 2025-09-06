//
//  AudioDevice.swift
//  FirstMacOSApp
//
//  Created by macbook on 7/9/25.
//

import CoreAudio

struct AudioDevice {
    let id: AudioObjectID
    let uid: String
    let name: String
    let isDefault: Bool
}
