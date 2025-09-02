//
//  GeneratePassword.swift
//  FirstMacOSApp
//
//  Created by macbook on 1/9/25.
//

import Foundation

private let characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".split(separator: "")

func generateRandomString(length: Int) -> String {
    var string = ""
    for _ in 0..<length {
        string.append(generateRandomCharacter())
    }
    return string
}
func generateRandomCharacter() -> String {
    let index = Int.random(in: 0..<characters.count)
    let character = characters[index]
    return String(character)
}
