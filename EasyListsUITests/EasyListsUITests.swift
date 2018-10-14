import XCTest

class EasyListsUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launch()
    }

    func testShowsLists() {
        let table = app.tables["Lists"]
        XCTAssertTrue(table.exists)
        XCTAssertEqual(2, table.cells.count)
        
        XCTAssertTrue(table.cells.element(boundBy: 0).descendants(matching: .staticText)["List A"].exists)
        XCTAssertTrue(table.cells.element(boundBy: 1).descendants(matching: .staticText)["List B"].exists)
    }
}
