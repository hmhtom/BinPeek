import SwiftUI

struct AddressView: View {
    @State private var streetNumber: String
    @State private var streetName: String
    @State private var postalCode: String

    private let storageManager: StorageManager?

    init(
        streetNumber: String = "",
        streetName: String = "",
        postalCode: String = "",
        storageManager: StorageManager? = StorageManager.shared
    ) {
        _streetNumber = State(initialValue: streetNumber)
        _streetName = State(initialValue: streetName)
        _postalCode = State(initialValue: postalCode)
        self.storageManager = storageManager
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    TextField("Street Number", text: $streetNumber)
                        .textFieldStyle(.roundedBorder)

                    TextField("Street Name", text: $streetName)
                        .textFieldStyle(.roundedBorder)

                    TextField("Postal Code", text: $postalCode)
                        .textFieldStyle(.roundedBorder)
                }

                Spacer()

                Button("Save Address") {
                    saveAddress()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .navigationTitle("Address")
            .onAppear {
                loadAddress()
            }
        }
    }

    private func loadAddress() {
        guard let address = storageManager?.loadAddress() else { return }

        streetNumber = address.streetNumber
        streetName = address.streetName
        postalCode = address.postalCode
    }

    private func saveAddress() {
        storageManager?.saveAddress(
            streetNumber: streetNumber,
            streetName: streetName,
            postalCode: postalCode
        )
    }
}

#Preview("Default") {
    AddressView(
        streetNumber: "12",
        streetName: "Maple Street",
        postalCode: "A1A 1A1",
        storageManager: nil
    )
}

#Preview("Light") {
    AddressView(
        streetNumber: "12",
        streetName: "Maple Street",
        postalCode: "A1A 1A1",
        storageManager: nil
    )
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    AddressView(
        streetNumber: "12",
        streetName: "Maple Street",
        postalCode: "A1A 1A1",
        storageManager: nil
    )
        .preferredColorScheme(.dark)
}

#Preview("iPhone SE") {
    AddressView(
        streetNumber: "12",
        streetName: "Maple Street",
        postalCode: "A1A 1A1",
        storageManager: nil
    )
        .previewDevice("iPhone SE (3rd generation)")
}

#Preview("iPhone 15 Pro") {
    AddressView(
        streetNumber: "12",
        streetName: "Maple Street",
        postalCode: "A1A 1A1",
        storageManager: nil
    )
        .previewDevice("iPhone 15 Pro")
}
