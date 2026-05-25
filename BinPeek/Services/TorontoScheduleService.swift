import Foundation

enum TorontoScheduleServiceError: Error {
    case scheduleResourceNotFound
    case invalidScheduleResourceURL
}

struct TorontoScheduleService {
    private let client: TorontoOpenDataClient
    private let packageDecoder: TorontoOpenDataPackageDecoder
    private let resourceResolver: TorontoOpenDataResourceResolver
    private let recordsDecoder: TorontoScheduleRecordsDecoder

    init(
        client: TorontoOpenDataClient = TorontoOpenDataClient(),
        packageDecoder: TorontoOpenDataPackageDecoder = TorontoOpenDataPackageDecoder(),
        resourceResolver: TorontoOpenDataResourceResolver = TorontoOpenDataResourceResolver(),
        recordsDecoder: TorontoScheduleRecordsDecoder = TorontoScheduleRecordsDecoder()
    ) {
        self.client = client
        self.packageDecoder = packageDecoder
        self.resourceResolver = resourceResolver
        self.recordsDecoder = recordsDecoder
    }

    func fetchLatestScheduleRecords() async throws -> [TorontoCollectionScheduleRecord] {
        let packageData = try await client.fetchSolidWastePickupSchedulePackageMetadata()
        let resources = try packageDecoder.decodeResources(from: packageData)

        guard let scheduleResource = resourceResolver.resolveLatestJSONScheduleResource(from: resources) else {
            throw TorontoScheduleServiceError.scheduleResourceNotFound
        }

        guard let scheduleURL = URL(string: scheduleResource.url) else {
            throw TorontoScheduleServiceError.invalidScheduleResourceURL
        }

        let recordsData = try await client.fetchData(from: scheduleURL)
        return try recordsDecoder.decodeRecords(from: recordsData)
    }
}
