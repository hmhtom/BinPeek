import Foundation

enum TorontoOpenDataClientError: Error {
    case invalidPackageMetadataURL
    case invalidResponse
    case invalidStatusCode(Int)
}

struct TorontoOpenDataClient {
    private enum Constants {
        static let baseURL = "https://ckan0.cf.opendata.inter.prod-toronto.ca/api/3/action"
        static let packageShowAction = "package_show"
        static let packageIDQueryItem = "id"
        static let solidWastePickupSchedulePackageID = "solid-waste-pickup-schedule"
    }

    func fetchSolidWastePickupSchedulePackageMetadata() async throws -> Data {
        guard
            let baseURL = URL(string: Constants.baseURL),
            var components = URLComponents(
                url: baseURL.appendingPathComponent(Constants.packageShowAction),
                resolvingAgainstBaseURL: false
            )
        else {
            throw TorontoOpenDataClientError.invalidPackageMetadataURL
        }

        components.queryItems = [
            URLQueryItem(
                name: Constants.packageIDQueryItem,
                value: Constants.solidWastePickupSchedulePackageID
            )
        ]

        guard let url = components.url else {
            throw TorontoOpenDataClientError.invalidPackageMetadataURL
        }

        return try await fetchData(from: url)
    }

    func fetchData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw TorontoOpenDataClientError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw TorontoOpenDataClientError.invalidStatusCode(httpResponse.statusCode)
        }

        return data
    }
}
