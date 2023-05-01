//
//  EmojiRepository.swift
//  Tracker
//
//  Created by Суворов Дмитрий Владимирович on 30.04.2023.
//

final class EmojiRepository {
    static let shared = EmojiRepository()
    
    let currentEmojies = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private init() { }
}
