import Foundation
import Combine
import SwiftUI

final class PetViewModel: ObservableObject {
    
    // Published property to track pet's hunger level (0 to 100)
    @Published var hunger: Int = 50
    
    // Timer to decrease hunger every 60 seconds
    private var timer: Timer?
    
    init() {
        // Schedule timer on main run loop to decrease hunger by 1 every 60 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.hunger > 0 {
                DispatchQueue.main.async { self.hunger -= 1 }
            }
        }
    }
    
    // Function to feed the pet and increase hunger level by 10, capped at 100
    func feedPet() {
        hunger = min(hunger + 10, 100)
    }
    
    // Computed property to determine the pet's image name based on hunger level
    var petImageName: String {
        switch hunger {
        case 0...29:
            return "pet_hungry"
        case 30...69:
            return "pet_neutral"
        case 70...100:
            return "pet_happy"
        default:
            return "pet_neutral"
        }
    }
    
    // Computed property to get hunger level as a progress value between 0.0 and 1.0
    var hungerProgress: Double {
        return Double(hunger) / 100.0
    }
    
    deinit {
        // Invalidate the timer when the ViewModel is deallocated
        timer?.invalidate()
    }
}
