import XCTest
@testable import Core

final class ExporterTests: XCTestCase {
    func testBasic() {
        let exporter = Exporter(size: .init(rotated: false, width: 400, height: 200))
        XCTAssertEqual(1, exporter.scale)
        XCTAssertEqual(400, exporter.width)
        XCTAssertEqual(200, exporter.height)
    }
    
    func testScale() {
        var exporter = Exporter(size: .init(rotated: false, width: 400, height: 200))
        exporter.scale(with: 0.5)
        
        XCTAssertEqual(200, exporter.width)
        XCTAssertEqual(100, exporter.height)
        
        exporter.scale(with: "0.25")
        
        XCTAssertEqual(100, exporter.width)
        XCTAssertEqual(50, exporter.height)
    }
    
    func testWidth() {
        var exporter = Exporter(size: .init(rotated: false, width: 400, height: 200))
        exporter.width(with: "200")
        
        XCTAssertEqual(0.5, exporter.scale)
        XCTAssertEqual(100, exporter.height)
    }
    
    func testHeight() {
        var exporter = Exporter(size: .init(rotated: false, width: 400, height: 200))
        exporter.height(with: "100")
        
        XCTAssertEqual(0.5, exporter.scale)
        XCTAssertEqual(200, exporter.width)
    }
    
    func testSanitize() {
        var exporter = Exporter(size: .init(rotated: false, width: 400, height: 200))
        exporter.width(with: "")
        exporter.width(with: ".")
        exporter.width(with: "@")
        exporter.width(with: "\n")
        
        XCTAssertEqual(1, exporter.scale)
        XCTAssertEqual(400, exporter.width)
        XCTAssertEqual(200, exporter.height)
        
        exporter.width(with: "0")
        
        XCTAssertEqual(0.01, exporter.scale)
        XCTAssertEqual(4, exporter.width)
        XCTAssertEqual(2, exporter.height)
        
        exporter.width(with: "3")
        
        XCTAssertEqual(0.01, exporter.scale)
        XCTAssertEqual(4, exporter.width)
        XCTAssertEqual(2, exporter.height)
        
        exporter.width(with: "4")
        
        XCTAssertEqual(0.01, exporter.scale)
        XCTAssertEqual(4, exporter.width)
        XCTAssertEqual(2, exporter.height)
        
        exporter.width(with: "4.5")
        
        XCTAssertEqual(0.01, exporter.scale)
        XCTAssertEqual(4, exporter.width)
        XCTAssertEqual(2, exporter.height)
        
        exporter.width(with: "4.9")
        
        XCTAssertEqual(0.01, exporter.scale)
        XCTAssertEqual(4, exporter.width)
        XCTAssertEqual(2, exporter.height)
        
        exporter.width(with: "4000")
        
        XCTAssertEqual(1, exporter.scale)
        XCTAssertEqual(400, exporter.width)
        XCTAssertEqual(200, exporter.height)
    }
    
    func testSmall() {
        var exporter = Exporter(size: .init(rotated: false, width: 20, height: 20))
        exporter.scale(with: 0.01)
        
        XCTAssertEqual(0.1, exporter.scale)
        XCTAssertEqual(2, exporter.width)
        XCTAssertEqual(2, exporter.height)
    }
}
