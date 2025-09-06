//
//  AlertSound.swift
//  FirstMacOSApp
//
//  Created by macbook on 6/9/25.
//
import Foundation

struct AlertSound {
    let name: String
    let url: URL
    
    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
}
