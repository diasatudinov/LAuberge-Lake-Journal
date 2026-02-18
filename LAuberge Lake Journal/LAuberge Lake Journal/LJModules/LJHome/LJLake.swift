//
//  LJLake.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

struct Lake: Codable, Equatable, Hashable, Identifiable {
    var id: UUID
    var name: String
    var date: Date
    var waterClarity: WaterClarity
    var mood: Mood
    var story: String
    var gallery: [String]
    
    init(
        id: UUID = UUID(),
        name: String,
        date: Date,
        waterClarity: WaterClarity,
        mood: Mood,
        story: String,
        gallery: [String] = []
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.waterClarity = waterClarity
        self.mood = mood
        self.story = story
        self.gallery = gallery
    }
}


enum WaterClarity: String, CaseIterable, Codable {
    case crystal = "Crystal"
    case clear = "Clear"
    case murky = "Murky"
    case muddy = "Muddy"
    
    var text: String {
        switch self {
        case .crystal:
            "Crystal"
        case .clear:
            "Clear"
        case .murky:
            "Murky"
        case .muddy:
            "Muddy"
        }
    }
    
    var icon: String {
        switch self {
        case .crystal:
            "waterClarityIconLJ1"
        case .clear:
            "waterClarityIconLJ2"
        case .murky:
            "waterClarityIconLJ3"
        case .muddy:
            "waterClarityIconLJ4"
        }
    }
    
    var color: Color {
        switch self {
        case .crystal:
                .accentBlue
        case .clear:
                .clearPurple
        case .murky:
                .murkyOrange
        case .muddy:
                .muddyRed
        }
    }
}

enum Mood: String, CaseIterable, Codable {
    case calmness = "Calmness"
    case serenity = "Serenity"
    case freshness = "Freshness"
    case adventure = "Adventure"
    case peace = "Peace"
    case coolness = "Coolness"
    case playfulness = "Playfulness"
    case cosiness = "Cosiness"
    case magic = "Magic"
    case recharge = "Recharge"
    
    var text: String {
        switch self {
        case .calmness:
            "Calmness"
        case .serenity:
            "Serenity"
        case .freshness:
            "Freshness"
        case .adventure:
            "Adventure"
        case .peace:
            "Peace"
        case .coolness:
            "Coolness"
        case .playfulness:
            "Playfulness"
        case .cosiness:
            "Cosiness"
        case .magic:
            "Magic"
        case .recharge:
            "Recharge"
        }
    }
 
    var icon: String {
        switch self {
        case .calmness:
            "moodIconLJ1"
        case .serenity:
            "moodIconLJ2"
        case .freshness:
            "moodIconLJ3"
        case .adventure:
            "moodIconLJ4"
        case .peace:
            "moodIconLJ5"
        case .coolness:
            "moodIconLJ6"
        case .playfulness:
            "moodIconLJ7"
        case .cosiness:
            "moodIconLJ8"
        case .magic:
            "moodIconLJ9"
        case .recharge:
            "moodIconLJ10"
        }
    }
}
