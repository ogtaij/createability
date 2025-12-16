//
//  Untitled.swift
//  PracticingXcode
//
//  Created by Rhonda Davis on 12/3/25.
//

import Foundation
internal import Combine   // 👈 important for ObservableObject & @Published

final class JournalStore: ObservableObject {
    // This is what triggers view updates when entries change
    @Published var entries: [String: String] = [:]

    private let storageKey = "journalEntries"

    private let dateKeyFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"   // e.g. 2025-12-02
        df.timeZone = .current
        return df
    }()

    init() {
        load()
    }

    // Make a stable string key for a given date
    private func key(for date: Date) -> String {
        dateKeyFormatter.string(from: date)
    }

    // Read text for a given day
    func text(for date: Date) -> String {
        entries[key(for: date)] ?? ""
    }

    // Write/update text for a given day
    func setText(_ text: String, for date: Date) {
        entries[key(for: date)] = text
        save()
    }

    // For showing a dot under days that have entries
    func hasEntry(for date: Date) -> Bool {
        !text(for: date).isEmpty
    }

    // Load from UserDefaults when the app starts
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        if let decoded = try? JSONDecoder().decode([String: String].self, from: data) {
            entries = decoded
        }
    }

    // Save to UserDefaults whenever we change entries
    private func save() {
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}

