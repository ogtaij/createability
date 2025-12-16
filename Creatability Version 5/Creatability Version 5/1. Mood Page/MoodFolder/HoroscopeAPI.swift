//
//  HoroscopeAPI.swift
//  PracticingXcode
//
//  Created by Rhonda Davis on 12/4/25.
//

import Foundation

struct RemoteHoroscopeResponse: Codable {
    let text: String
}

enum HoroscopeAPIError: Error {
    case badURL
    case invalidResponse
}

final class HoroscopeAPI {
    static let shared = HoroscopeAPI()

    func fetchHoroscope(sign: String, mood: Mood) async throws -> String {
        // TODO: replace this with your real backend URL
        let signParam = sign.lowercased()
        let moodParam = mood.rawValue.lowercased()

        guard let url = URL(string: "https://your-backend.com/horoscope?sign=\(signParam)&mood=\(moodParam)") else {
            throw HoroscopeAPIError.badURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw HoroscopeAPIError.invalidResponse
        }

        let decoded = try JSONDecoder().decode(RemoteHoroscopeResponse.self, from: data)
        return decoded.text
    }
}
 
