//
//  String+Common.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 17.04.2023.
//
import UIKit

func randomColor() -> String {
    let r = CGFloat(arc4random_uniform(256)) / 255.0
    let g = CGFloat(arc4random_uniform(256)) / 255.0
    let b = CGFloat(arc4random_uniform(256)) / 255.0
    return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
}

func randomEmoji() -> String {
    let emojis = ["😀", "👍", "🎉", "🌟", "🐶", "🍕", "🚀", "🎸"]
    let randomIndex = Int(arc4random_uniform(UInt32(emojis.count)))
    return emojis[randomIndex]
}
