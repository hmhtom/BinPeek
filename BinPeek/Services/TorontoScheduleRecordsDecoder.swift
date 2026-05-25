import Foundation

struct TorontoScheduleRecordsDecoder {
    func decodeRecords(from data: Data) throws -> [TorontoCollectionScheduleRecord] {
        let dtos = try JSONDecoder().decode(
            [TorontoCollectionScheduleDTO].self,
            from: data
        )

        return dtos.map { $0.toRecord() }
    }
}
