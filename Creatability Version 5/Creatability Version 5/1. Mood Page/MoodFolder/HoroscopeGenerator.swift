//
//  HoroscopeGenerator.swift
//  PracticingXcode
//
//  Created by Rhonda Davis on 12/4/25.
//

import Foundation

struct HoroscopeGenerator {
    static func cancerHoroscope(for date: Date, mood: Mood) -> String {
        let base = baseCancerHoroscope(for: date)
        let moodNote: String
        
        switch mood {
        case .depressed:
            moodNote = "Because your mood is low, be extra gentle with yourself today. Focus on rest, grounding, and tiny wins."
        case .sad:
            moodNote = "Your sadness is valid. Let your emotions flow, but remember this wave will pass. Small comforts can help."
        case .angry:
            moodNote = "Since you’re feeling tense, try to move that fire into something productive—journaling, a walk, or creative expression."
        case .neutral:
            moodNote = "Your neutral mood gives you room to observe without pressure. Notice what would make today just 1% better."
        case .happy:
            moodNote = "Your lighter mood makes this a great time to connect with someone you care about or celebrate small victories."
        case .overjoyed:
            moodNote = "Your joy is contagious. Share it, but also protect your energy by honoring your needs and boundaries."
        }
        
        return base + "\n\n" + moodNote
    }
    
    private static func baseCancerHoroscope(for date: Date) -> String {
        let weekday = Calendar.current.component(.weekday, from: date)
        
        switch weekday {
        case 1:
            return "Today is a good day for rest and emotional reset. Let yourself slow down and recharge your spirit."
        case 2:
            return "You may feel extra sensitive starting the week, but that’s your superpower. Use your intuition to guide small decisions."
        case 3:
            return "Communication is highlighted today. Reach out to someone you’ve been thinking about—you might brighten their day."
        case 4:
            return "Midweek brings a chance to organize your thoughts and priorities. A small step toward your goals will feel big."
        case 5:
            return "Your nurturing side is strong today. Check in with yourself the way you check in with others—your needs matter too."
        case 6:
            return "Energy around joy and connection is high. Make space for something fun, even if it’s a small treat just for you."
        case 7:
            return "Today is perfect for reflection and self-care. Journaling or quiet time could reveal something important about how you’re growing."
        default:
            return "Trust your inner voice today. Your intuition is giving you gentle hints—pay attention to what feels peaceful and what doesn’t."
        }
    }
}
