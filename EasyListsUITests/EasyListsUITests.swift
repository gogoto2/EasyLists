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
    
    func testCreatesLists() {
        let app = launchApp()
        let table = app.tables["Lists"]
        XCTAssertTrue(table.exists)
        XCTAssertEqual(0, table.cells.count)
        
        app.addList(name: "List A")
        app.addList(name: "List B")
        
        XCTAssertEqual(2, table.cells.count)
        XCTAssertTrue(table.cells.element(boundBy: 0).descendants(matching: .staticText)["List A"].exists)
        XCTAssertTrue(table.cells.element(boundBy: 1).descendants(matching: .staticText)["List B"].exists)
    }
    
    func testPersistsAddedLists() {
        var app = launchApp(resetData: true)
        app.addList(name: "List C")
        
        var table = app.tables["Lists"]
        XCTAssertTrue(table.exists)
        XCTAssertEqual(1, table.cells.count)
        XCTAssertTrue(table.cells.element(boundBy: 0).descendants(matching: .staticText)["List C"].exists)
        
        // Verify that the addition was persisted
        app = launchApp(resetData: false)
        table = app.tables["Lists"]
        XCTAssertTrue(table.exists)
        XCTAssertEqual(1, table.cells.count)
        XCTAssertTrue(table.cells.element(boundBy: 0).descendants(matching: .staticText)["List C"].exists)
    }
}

extension XCUIApplication {
    func addList(name: String) {
        self.buttons["Add"].tap()
        let alert = self.alerts["Add List"]
        XCTAssertTrue(alert.exists)
        let nameField = alert.textFields["List Name"]
        nameField.tap()
        nameField.typeText(name)
        alert.buttons["Add"].tap()
    }
}
