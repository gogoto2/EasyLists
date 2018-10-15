import XCTest
import CoreData

class ListsDataSourceTests: XCTestCase {
    
    var container: NSPersistentContainer! = nil
    var subject: ListsDataSource! = nil
    
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
        
        subject = ListsDataSource(persistentContainer: container)
    }
    
    func addList(name: String) -> TodoList {
        let entity = NSEntityDescription.entity(forEntityName: "TodoList",
                                                in: container.viewContext)!
        let list = TodoList(entity: entity, insertInto: container.viewContext)
        list.name = name
        return list
    }
    
    func namesInTable() -> [String] {
        let view = StubListsTableView()
        let n = subject.tableView(view, numberOfRowsInSection: 0)
        return (0..<n).map { (i: Int) -> String in
            let cell = subject.tableView(view, cellForRowAt: IndexPath(row: i, section: 0))
            return cell.textLabel!.text!
        }
    }
    
    func testProvidesListsInAlphaOrder() throws {
        _ = addList(name: "foo")
        _ = addList(name: "bar")
        try subject.fetch()
        XCTAssertEqual(namesInTable(), ["bar", "foo"])
    }
 
    func testAddsListsInAlphaOrder() throws {
        _ = addList(name: "b")
        try subject.fetch()
        try subject.add(name: "c")
        try subject.add(name: "a")
        XCTAssertEqual(namesInTable(), ["a", "b", "c"])
    }

    func testDeletesLists() throws {
        let listToRemove = addList(name: "a")
        let item = TodoListItem(context: container.viewContext)
        item.name = ""
        listToRemove.addToItems(item)
        _ = addList(name: "b")
        try container.viewContext.save()
        try subject.fetch()
        
        try subject.deleteItemAtIndex(0)
        
        XCTAssertEqual(namesInTable(), ["b"])
    }
}
