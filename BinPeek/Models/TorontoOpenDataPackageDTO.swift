struct TorontoOpenDataPackageResponseDTO: Decodable {
    let success: Bool?
    let result: TorontoOpenDataPackageResultDTO?

    func toResources() -> [TorontoOpenDataResource] {
        result?.resources?.compactMap { $0.toResource() } ?? []
    }
}

struct TorontoOpenDataPackageResultDTO: Decodable {
    let resources: [TorontoOpenDataResourceDTO]?
}

struct TorontoOpenDataResourceDTO: Decodable {
    let id: String?
    let name: String?
    let format: String?
    let url: String?

    func toResource() -> TorontoOpenDataResource? {
        guard
            let name = trimmedValue(name),
            let format = trimmedValue(format),
            let url = trimmedValue(url)
        else {
            return nil
        }

        return TorontoOpenDataResource(
            name: name,
            format: format,
            url: url
        )
    }

    private func trimmedValue(_ value: String?) -> String? {
        guard let value else {
            return nil
        }

        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else {
            return nil
        }

        return trimmedValue
    }
}
