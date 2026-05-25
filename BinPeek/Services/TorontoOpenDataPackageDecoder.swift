import Foundation

struct TorontoOpenDataPackageDecoder {
    func decodeResources(from data: Data) throws -> [TorontoOpenDataResource] {
        let response = try JSONDecoder().decode(
            TorontoOpenDataPackageResponseDTO.self,
            from: data
        )

        return response.toResources()
    }
}
