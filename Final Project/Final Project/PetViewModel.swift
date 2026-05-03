import Foundation
import Combine
import SwiftUI

final class PetViewModel: ObservableObject {
    
    // Published property to track pet's hunger level (0 to 100)
    @Published var hunger: Int = 0
    
    // Published property to track if the pet is currently eating
    @Published var isEating: Bool = false
    
    // UserDefaults keys for persistence
    private let hungerKey = "pet_hunger_key"
    private let lastResetKey = "pet_last_reset_key"
    
    // Timer to schedule daily reset at midnight
    private var dailyResetTimer: Timer?
    
    init() {
        // Load saved hunger and last reset date from UserDefaults
        let defaults = UserDefaults.standard
        hunger = defaults.integer(forKey: hungerKey)
        
        if let lastResetDate = defaults.object(forKey: lastResetKey) as? Date {
            let today = Calendar.current.startOfDay(for: Date())
            // If last reset date is not today, reset hunger and save state
            if lastResetDate < today {
                hunger = 0
                saveState()
                defaults.set(today, forKey: lastResetKey)
            }
        } else {
            // No last reset date stored, set to today and hunger to 0
            let today = Calendar.current.startOfDay(for: Date())
            hunger = 0
            defaults.set(today, forKey: lastResetKey)
            saveState()
        }
        
        scheduleDailyResetTimer()
    }
    
    // Schedule a timer to fire at next local midnight, then reschedule every 24 hours
    private func scheduleDailyResetTimer() {
        dailyResetTimer?.invalidate()
        
        let calendar = Calendar.current
        let now = Date()
        guard let nextMidnight = calendar.nextDate(after: now, matching: DateComponents(hour:0, minute:0, second:0), matchingPolicy: .strict, direction: .forward) else {
            return
        }
        let interval = nextMidnight.timeIntervalSince(now)
        
        dailyResetTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            self?.handleDailyReset()
        }
    }
    
    // Handle daily reset by setting hunger to 0, saving state, and rescheduling timer
    private func handleDailyReset() {
        hunger = 0
        saveState()
        
        let today = Calendar.current.startOfDay(for: Date())
        UserDefaults.standard.set(today, forKey: lastResetKey)
        
        // Schedule next reset in 24 hours
        dailyResetTimer = Timer.scheduledTimer(withTimeInterval: 24 * 60 * 60, repeats: true) { [weak self] _ in
            self?.hunger = 0
            self?.saveState()
            let today = Calendar.current.startOfDay(for: Date())
            UserDefaults.standard.set(today, forKey: self?.lastResetKey ?? "")
        }
    }
    
    // Save hunger and last reset date to UserDefaults
    private func saveState() {
        let defaults = UserDefaults.standard
        defaults.set(hunger, forKey: hungerKey)
        let today = Calendar.current.startOfDay(for: Date())
        defaults.set(today, forKey: lastResetKey)
    }
    
    // Feed pet by 10 (backward compatibility), updated to call feed(by:)
    func feedPet() {
        feed(by: 10)
    }
    
    // Feed pet with different amounts based on TaskPriority, capped at 100, calls feed(by:)
    func feed(for priority: TaskPriority) {
        var increase: Int
        switch priority {
        case .high:
            increase = 15
        case .medium:
            increase = 10
        case .low:
            increase = 5
        @unknown default:
            increase = 10
        }
        
        feed(by: increase)
    }
    
    // Core feeding method that updates hunger, saves state and manages isEating state
    private func feed(by amount: Int) {
        hunger = min(100, hunger + max(0, amount))
        saveState()
        isEating = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isEating = false
        }
    }
    
    // New resetHunger method as per instructions
    func resetHunger() {
        hunger = 0
        isEating = false
        saveState()
    }
    
    // Computed property to determine the pet's image name based on hunger level and eating state
    var petImageName: String {
        if isEating {
            return "pet_eating"
        } else if hunger >= 50 {
            return "pet_full"
        } else {
            return "pet_hungry"
        }
    }
    
    // Computed property to get hunger level as a progress value between 0.0 and 1.0
    var hungerProgress: Double {
        return Double(hunger) / 100.0
    }
    
    deinit {
        // Invalidate any scheduled timers when the ViewModel is deallocated
        dailyResetTimer?.invalidate()
    }
}
