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
            let outputs = getOutput(with: content)
            
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
    
    func getOutput() throws -> [XCTestMetricsOutput] {
        do {
            let folder = try getOutputFolder()
            let content = getRawContent(for: folder)
            return getOutput(with: content)
        } catch {
            throw error
        }
    }
    
    private func getOutputFolder() throws -> Folder {
        do {
            let folder = try Folder.current.subfolder(named: "xctestmetrics-output")
            return folder
        } catch {
            throw OutputFileParserError.outputFolderNotFound
        }
    }
    
    private func getRawContent(for folder: Folder) -> [String] {
        let files = folder.files
        // maybe throw if file is empty
        let fileNamePrefix = "xctm-"
        
        var rawContent: [String] = []
        for file in files where file.name.contains(fileNamePrefix) {
            if let stringContent = try? file.readAsString() {
                rawContent.append(stringContent)
            }
        }
        
        // maybe throw if array is empty
        return rawContent
    }
    
    private func getOutput(with rawContent: [String]) -> [XCTestMetricsOutput] {
        var output: [XCTestMetricsOutput] = []
        
        for raw in rawContent {
            guard let data = raw.data(using: .utf8) else { break }
            
            if let decodedOutput = try? XCTestMetricsOutput.decoder.decode(XCTestMetricsOutput.self, from: data) {
                output.append(decodedOutput)
            }
        }
        
        return output
    }
    
}
