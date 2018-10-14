import UIKit
import CoreData

class ItemsDataSource: NSObject, UITableViewDataSource {
    private let viewContext: NSManagedObjectContext
    let list: TodoList
    
    init(list: TodoList, persistentContainer: NSPersistentContainer) {
        self.list = list
        self.viewContext = persistentContainer.viewContext
    }
    
    func add(name: String) throws {
        let item = TodoListItem(context: viewContext)
        item.name = name
        list.addToItems(item)
        try viewContext.save()
    }
        
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.items!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item cell")!
        cell.textLabel!.text = (self.list.items![indexPath.row] as! TodoListItem).name
        return cell
    }

}
