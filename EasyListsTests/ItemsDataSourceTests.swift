import XCTest
import CoreData

class ItemsDataSourceTests: XCTestCase {
    
    var container: NSPersistentContainer! = nil
    
    override func setUp() {
        super.setUp()
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))] )!
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        container = NSPersistentContainer(name: "EasyLists", managedObjectModel: managedObjectModel)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            precondition(error == nil)
        }
    }

    func testSortsItemsByCompletedThenInsertionOrder() throws {
        let list = try makeList(items: ["Item 1", "Item 2", "Item 3", "Item 4"])
        (list.items![0] as! TodoListItem).isCompleted = true
        (list.items![2] as! TodoListItem).isCompleted = true
        let subject = ItemsDataSource(list: list, viewContext: container.viewContext)
        XCTAssertEqual(["Item 2", "Item 4", "Item 1", "Item 3"], namesInTable(subject: subject))
    }
    
    func testAddsItemsInOrder() throws {
        let list = try makeList(items: ["Item 2"])
        let subject = ItemsDataSource(list: list, viewContext: container.viewContext)
        try subject.add(name: "Item 1")
        XCTAssertEqual(["Item 2", "Item 1"], namesInTable(subject: subject))
    }
    
    func testDeletesInitiallyNotCompletedItem() throws {
        let list = try makeList(items: ["Item 1", "Item 2"])
        let subject = ItemsDataSource(list: list, viewContext: container.viewContext)
        try subject.deleteItemAtIndex(0)
        XCTAssertEqual(["Item 2"], namesInTable(subject: subject))
    }

    
    func testDeletesInitiallyCompletedItem() throws {
        let list = try makeList(items: ["Item 1", "Item 2", "Item 3"])
        (list.items![1] as! TodoListItem).isCompleted = true
        (list.items![2] as! TodoListItem).isCompleted = true
        let subject = ItemsDataSource(list: list, viewContext: container.viewContext)
        try subject.deleteItemAtIndex(1)
        XCTAssertEqual(["Item 1", "Item 3"], namesInTable(subject: subject))
    }
    
    func makeList(items: [String]) throws -> TodoList {
        let entity = NSEntityDescription.entity(forEntityName: "TodoList",
                                                in: container.viewContext)!
        let list = TodoList(entity: entity, insertInto: container.viewContext)
        list.name = ""
        
        for name in items {
            let item = TodoListItem(context: container.viewContext)
            item.name = name
            list.addToItems(item)
        }

        try container.viewContext.save()
        return list
    }
    
    func namesInTable(subject: ItemsDataSource) -> [String] {
        let view = StubItemsTableView()
        let n = subject.tableView(view, numberOfRowsInSection: 0)
        return (0..<n).map { (i: Int) -> String in
            let cell = subject.tableView(view, cellForRowAt: IndexPath(row: i, section: 0))
            return cell.textLabel!.text!
        }
    }
}
