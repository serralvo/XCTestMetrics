import Foundation
import Files
import Entity

enum OutputFileParserError: Error {
    case outputFolderNotFound
    case cannotGenerateReportWrapper
}

final class OutputFileParser: ReportDataSource {
    
    func getReportWrapper() throws -> ReportWrapper {
        
        do {
            let folder = try getOutputFolder()
            let content = getRawContent(for: folder)
            let outputs = getTractorOutput(with: content)
            
            // TODO: Move this logic to a expecific one
            let success = outputs.map { $0.testMetrics }.reduce(0, { count, testMetrics in
                count + testMetrics.count
            })
            
            let failureTests = outputs.map { $0.failures }.flatMap { $0 }
            
            var failureTestsReportAsDict: [FailureTest : Int] = [:]
            
            for test in failureTests {
                if let count = failureTestsReportAsDict[test] {
                    failureTestsReportAsDict[test] = count + 1
                } else {
                    failureTestsReportAsDict[test] = 1
                }
            }
            
            let failureTestsReport = failureTestsReportAsDict.map { (key: FailureTest, value: Int) -> FailureTestReport in
                return FailureTestReport(failureTest: key, numberOfOccurrences: value)
            }.sorted { $0.numberOfOccurrences > $1.numberOfOccurrences }
            
            return ReportWrapper(
                numberOfSuccess: success,
                failureTests: failureTestsReport
            )
        } catch {
            throw OutputFileParserError.cannotGenerateReportWrapper
        }
        
    }
    
    func getOutput() throws -> [TractorOutput] {
        do {
            let folder = try getOutputFolder()
            let content = getRawContent(for: folder)
            return getTractorOutput(with: content)
        } catch {
            throw error
        }
    }
    
    private func getOutputFolder() throws -> Folder {
        do {
            let folder = try Folder.current.subfolder(named: "tractor-output")
            return folder
        } catch {
            throw OutputFileParserError.outputFolderNotFound
        }
    }
    
    private func getRawContent(for folder: Folder) -> [String] {
        let files = folder.files
        // maybe throw if file is empty
        let fileNamePrefix = "to-"
        
        var rawContent: [String] = []
        for file in files where file.name.contains(fileNamePrefix) {
            if let stringContent = try? file.readAsString() {
                rawContent.append(stringContent)
            }
        }
        
        // maybe throw if array is empty
        return rawContent
    }
    
    private func getTractorOutput(with rawContent: [String]) -> [TractorOutput] {
        var output: [TractorOutput] = []
        
        for raw in rawContent {
            guard let data = raw.data(using: .utf8) else { break }
            
            if let tractorOutput = try? TractorOutput.decoder.decode(TractorOutput.self, from: data) {
                output.append(tractorOutput)
            }
        }
        
        return output
    }
    
}
