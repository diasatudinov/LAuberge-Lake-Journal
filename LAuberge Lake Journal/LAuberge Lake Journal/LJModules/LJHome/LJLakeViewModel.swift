//
//  LJLakeViewModel.swift
//  LAuberge Lake Journal
//
//

import SwiftUI

final class LJLakeViewModel: ObservableObject {
    @Published var lakes: [Lake] = [] {
        didSet {
            saveLakes()
        }
    }
    
    
    // MARK: – UserDefaults keys
    private var outfitsFileURL: URL {
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return dir.appendingPathComponent("lakeTest.json")
    }

    
    // MARK: – Init
    init() {
        loadLakes()
    }
    
    // MARK: – Save / Load Outfits
    
    private func saveLakes() {
        let url = outfitsFileURL
        do {
            let data = try JSONEncoder().encode(lakes)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Failed to save myDives:", error)
        }
    }
    
    private func loadLakes() {
        let url = outfitsFileURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let outfitsData = try JSONDecoder().decode([Lake].self, from: data)
            lakes = outfitsData
        } catch {
            print("Failed to load myDives:", error)
        }
    }
    
    
    
    // MARK: – Example buy action
    func add(lake: Lake) {
        guard !lakes.contains(lake) else { return }
        lakes.append(lake)
        
    }
    
    func delete(lake: Lake) {
        guard let index = lakes.firstIndex(of: lake) else { return }
        lakes.remove(at: index)
    }
    
    func edit(lake: Lake, name: String, date: Date, waterClarity: WaterClarity, mood: Mood, story: String, gallery: [String]) {
        guard let index = lakes.firstIndex(of: lake) else { return }
        lakes[index].name = name
        lakes[index].date = date
        lakes[index].waterClarity = waterClarity
        lakes[index].mood = mood
        lakes[index].story = story
        lakes[index].gallery = gallery
    }
    
}
