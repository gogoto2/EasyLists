import XCTest

// Note: print(app.debugDescription) is often useful.
// See also http://masilotti.com/ui-testing-cheat-sheet/


class EasyListsUITests: XCTestCase {
    
    override func setUp() {
        continueAfterFailure = false
    }
    
    func launchApp(resetData: Bool = true) -> XCUIApplication {
        let app = XCUIApplication()
        
        if resetData {
            app.launchArguments.append("--uitesting")
        }
        
        app.launch()
        return app
    }

    func testShowsLists() {
        let app = launchApp()
        let table = app.tables["Lists"]
        XCTAssertTrue(table.exists)
        XCTAssertEqual(2, table.cells.count)
        
        XCTAssertTrue(table.cells.element(boundBy: 0).descendants(matching: .staticText)["List A"].exists)
        XCTAssertTrue(table.cells.element(boundBy: 1).descendants(matching: .staticText)["List B"].exists)
    }
    
    func testAddsList() {
        var app = launchApp(resetData: true)
        app.buttons["Add"].tap()

        let alert = app.alerts["Add List"]
        XCTAssertTrue(alert.exists)
        let nameField = alert.textFields["List Name"]
        nameField.tap()
        nameField.typeText("List C")
        alert.buttons["Add"].tap()
        
        var table = app.tables["Lists"]
        XCTAssertTrue(table.exists)
        XCTAssertEqual(3, table.cells.count)
        XCTAssertTrue(table.cells.element(boundBy: 2).descendants(matching: .staticText)["List C"].exists)
        
        // Verify that the addition was persisted
        app = launchApp(resetData: false)
        table = app.tables["Lists"]
        XCTAssertTrue(table.exists)
        XCTAssertEqual(3, table.cells.count)
        XCTAssertTrue(table.cells.element(boundBy: 2).descendants(matching: .staticText)["List C"].exists)
    }
}
