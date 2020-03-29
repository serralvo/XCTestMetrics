import Foundation
import Files
import ShellOut

public class TractorGen {
    
    private let resultName: String

    public init(reportFileName: String) {
        resultName = reportFileName
    }
    
    public func log() {
        do {
            try generateOutputFile(reportFileName: resultName)
            parse()
        } catch {
            print(error)
        }
    }
    
    func generateOutputFile(reportFileName: String) throws {
        let processor = XCResultProcessor(resultName: reportFileName)
        try processor.persistOutputFile()
    }
    
    func parse() {
        
        do {
            let parser = XCResultOutputFileParser()
            let tractorOutput = try parser.getOutput()
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(dateFormatter)

            let fileToSave = try? encoder.encode(tractorOutput)

            let x = try Folder.current.createFile(at: "tractor-output/to-\(resultName).json", contents: fileToSave)
            
            // needs commit this file :point-up:
            
        } catch {
            print(error)
        }
        
        // generate a structure
        // save it on disc
    }
    
}
