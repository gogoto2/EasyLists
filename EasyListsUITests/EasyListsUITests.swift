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
    
    func testCreatesItems() {
        let app = launchApp()
        app.addList(name: "List A")
        app.tables["Lists"].cells.element(boundBy: 0).tap()
        
        let itemTable = app.tables["List A Items"]
        XCTAssertTrue(itemTable.exists)
        app.addItem(name: "Item 1", byPressingEnter: true)
        app.addItem(name: "Item 2", byPressingEnter: false)
        XCTAssertEqual(2, itemTable.cells.count)
        XCTAssertTrue(itemTable.cells.element(boundBy: 0).descendants(matching: .staticText)["Item 1"].exists)
        XCTAssertTrue(itemTable.cells.element(boundBy: 1).descendants(matching: .staticText)["Item 2"].exists)
    }
    
    func testPersistsListsAndItems() {
        var app = launchApp(resetData: true)
        app.addList(name: "List C")
        
        var listsTable = app.tables["Lists"]
        XCTAssertTrue(listsTable.exists)
        XCTAssertEqual(1, listsTable.cells.count)
        var listCell = listsTable.cells.element(boundBy: 0)
        XCTAssertTrue(listCell.descendants(matching: .staticText)["List C"].exists)
        listCell.tap()
        
        var itemsTable = app.tables["List C Items"]
        XCTAssertTrue(itemsTable.exists)
        app.addItem(name: "Item 1")
        var itemCell = itemsTable.cells.element(boundBy: 0)
        XCTAssertTrue(itemCell.descendants(matching: .staticText)["Item 1"].exists)
        
        // Verify that the additions were persisted
        app = launchApp(resetData: false)
        listsTable = app.tables["Lists"]
        XCTAssertTrue(listsTable.exists)
        XCTAssertEqual(1, listsTable.cells.count)
        listCell = listsTable.cells.element(boundBy: 0)
        XCTAssertTrue(listCell.descendants(matching: .staticText)["List C"].exists)
        listCell.tap()
        
        itemsTable = app.tables["List C Items"]
        XCTAssertTrue(itemsTable.exists)
        itemCell = itemsTable.cells.element(boundBy: 0)
        XCTAssertTrue(itemCell.descendants(matching: .staticText)["Item 1"].exists)
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
    
    func addItem(name: String, byPressingEnter: Bool = true) {
        XCTAssertFalse(self.buttons["Save"].exists)
        XCTAssertFalse(self.textFields["New Item Name"].exists)
        self.buttons["Add"].tap()
        XCTAssertFalse(self.buttons["Add"].exists)
        XCTAssertTrue(self.buttons["Save"].exists)
        XCTAssertTrue(self.textFields["New Item Name"].exists)

        let nameField = self.textFields["New Item Name"]
        nameField.tap()
        nameField.typeText(name)
        
        if byPressingEnter {
            nameField.typeText("\n")
        } else {
            self.buttons["Save"].tap()
        }
        
        XCTAssertTrue(self.buttons["Add"].exists)
        XCTAssertFalse(self.buttons["Save"].exists)
        XCTAssertFalse(self.textFields["New Item Name"].exists)
    }
}
