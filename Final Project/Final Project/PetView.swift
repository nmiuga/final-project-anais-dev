import SwiftUI

struct PetView: View {
    @ObservedObject var petViewModel: PetViewModel

    var body: some View {
        VStack(spacing: 16) {
            // Pet image with styling
            Image(petViewModel.petImageName)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

            // Hunger progress bar with label
            ProgressView("Hunger", value: petViewModel.hungerProgress)
                .padding(.horizontal)

            // Feed button triggering feedPet action
            Button("Feed") {
                petViewModel.feedPet()
            }
            .buttonStyle(.bordered)
            .tint(.green)
            .controlSize(.small)
        }
        .padding()
    }
}

#Preview {
    // Example PetViewModel instance for preview
    let exampleViewModel = PetViewModel()
    PetView(petViewModel: exampleViewModel)
}
