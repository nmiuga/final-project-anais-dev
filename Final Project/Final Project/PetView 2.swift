import SwiftUI

struct PetView: View {
    @StateObject private var viewModel = PetViewModel()

    var body: some View {
        VStack(spacing: 16) {
            Image(viewModel.petImageName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 220, maxHeight: 220)
                .accessibilityLabel("Pet appearance")

            VStack(alignment: .leading, spacing: 8) {
                Text("Hunger")
                    .font(.headline)
                ProgressView(value: viewModel.hungerProgress)
                    .tint(.green)
                Text("\(viewModel.hunger)%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            HStack(spacing: 12) {
                Button {
                    viewModel.feedPet()
                } label: {
                    Label("Feed", systemImage: "fork.knife")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .navigationTitle("AI Pet")
    }
}

#Preview {
    NavigationStack { PetView() }
}
