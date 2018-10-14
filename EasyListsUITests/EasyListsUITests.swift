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
    
    func testPersistsListsAndItems() {
        var app = launchApp(resetData: true)
        app.addList(name: "List A")
        app.addList(name: "List B")

        var listsTable = app.tables["Lists"]
        XCTAssertTrue(listsTable.exists)
        XCTAssertEqual(2, listsTable.cells.count)
        XCTAssertTrue(listsTable.cells.element(boundBy: 0).descendants(matching: .staticText)["List A"].exists)
        XCTAssertTrue(listsTable.cells.element(boundBy: 1).descendants(matching: .staticText)["List B"].exists)
        listsTable.cells.element(boundBy: 0).tap()
        
        var itemsTable = app.tables["List A Items"]
        XCTAssertTrue(itemsTable.exists)
        app.addItem(name: "Item 1")
        app.addItem(name: "Item 2")
        app.addItem(name: "Item 3")
        var item1Cell = itemsTable.cells.element(boundBy: 0)
        XCTAssertTrue(item1Cell.descendants(matching: .staticText)["Item 1"].exists)
        item1Cell.switches["completed"].tap()
        XCTAssertTrue(itemsTable.cells.element(boundBy: 1).descendants(matching: .staticText)["Item 2"].exists)
        let item3Cell = itemsTable.cells.element(boundBy: 2)
        XCTAssertTrue(item3Cell.descendants(matching: .staticText)["Item 3"].exists)
        item3Cell.swipeLeft()
        item3Cell.buttons["Delete"].tap()
        XCTAssertEqual(2, itemsTable.cells.count)

        // Verify that the additions were persisted
        app = launchApp(resetData: false)
        listsTable = app.tables["Lists"]
        XCTAssertTrue(listsTable.exists)
        XCTAssertEqual(2, listsTable.cells.count)
        XCTAssertTrue(listsTable.cells.element(boundBy: 0).descendants(matching: .staticText)["List A"].exists)
        XCTAssertTrue(listsTable.cells.element(boundBy: 1).descendants(matching: .staticText)["List B"].exists)
        listsTable.cells.element(boundBy: 0).tap()

        itemsTable = app.tables["List A Items"]
        XCTAssertTrue(itemsTable.exists)
        XCTAssertEqual(2, itemsTable.cells.count)
        XCTAssertTrue(itemsTable.cells.element(boundBy: 0).descendants(matching: .staticText)["Item 2"].exists)
        item1Cell = itemsTable.cells.element(boundBy: 1)
        XCTAssertTrue(item1Cell.descendants(matching: .staticText)["Item 1"].exists)
        XCTAssertEqual("1", item1Cell.switches["completed"].value as? String)
    }
}

extension XCUIApplication {
    func addList(name: String) {
        self.buttons["Add"].tap()
        let alert = self.alerts["New List"]
        XCTAssertTrue(alert.exists)
        let nameField = alert.textFields["List Name"]
        nameField.tap()
        nameField.typeText(name)
        alert.buttons["Add"].tap()
    }
    
    func addItem(name: String) {
        let nameField = self.textFields["New Item Name"]
        nameField.tap()
        nameField.typeText(name)
        nameField.typeText("\n")
    }
}
