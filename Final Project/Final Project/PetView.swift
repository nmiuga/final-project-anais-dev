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
                .clipped()

            // Hunger progress bar with label
            ProgressView("Hunger", value: petViewModel.hungerProgress)
                .padding(.horizontal)

            Button {
                petViewModel.resetHunger()
            } label: {
                Label("Reset Hunger", systemImage: "arrow.counterclockwise")
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
        }
        .padding()
    }
}

#Preview {
    // Example PetViewModel instance for preview
    let exampleViewModel = PetViewModel()
    PetView(petViewModel: exampleViewModel)
}
