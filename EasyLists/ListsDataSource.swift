import UIKit
import CoreData

class ListsDataSource: NSObject, UITableViewDataSource {
    
    private let viewContext: NSManagedObjectContext
    private var lists: [TodoList] = []
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
    }
    
    func fetch() throws {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.lists = try viewContext.fetch(req) as! [TodoList]
    }
    
    func add(name: String) throws {
        let entity = NSEntityDescription.entity(forEntityName: "TodoList",
                                                in: viewContext)!
        let list = TodoList(entity: entity, insertInto: viewContext)
        list.name = name
        
        try viewContext.save()
        lists.append(list)
        lists.sort(by: {$0.name! < $1.name!})
    }
    
    func deleteItemAtIndex(_ i: Int) throws {
        let list = lists.remove(at: i)
        viewContext.delete(list)
        try viewContext.save()
    }
    
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal cell") as! ListCell
        cell.list = lists[indexPath.row]
        cell.textLabel!.text = lists[indexPath.row].name
        return cell
    }
    
}
