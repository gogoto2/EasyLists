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
    
    func addList(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "TodoList",
                                                in: container.viewContext)!
        let list = TodoList(entity: entity, insertInto: container.viewContext)
        list.name = name
    }
    
    func namesInTable() -> [String] {
        let view = StubTableView()
        let n = subject.tableView(view, numberOfRowsInSection: 0)
        return (0..<n).map { (i: Int) -> String in
            let cell = subject.tableView(view, cellForRowAt: IndexPath(row: i, section: 0))
            return cell.textLabel!.text!
        }
    }
    
    func testProvidesListsInAlphaOrder() {
        addList(name: "foo")
        addList(name: "bar")
        subject.fetch()
        XCTAssertEqual(namesInTable(), ["bar", "foo"])
    }
 
    func testAddsListsInAlphaOrder() {
        addList(name: "b")
        subject.fetch()
        subject.add(name: "c")
        subject.add(name: "a")
        XCTAssertEqual(namesInTable(), ["a", "b", "c"])
    }

}
