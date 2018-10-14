import UIKit
import CoreData

class ListsDataSource: NSObject, UITableViewDataSource {
    
    private let persistentContainer: NSPersistentContainer
    private var lists: [TodoList] = []
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func fetch() throws {
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        self.lists = try persistentContainer.viewContext.fetch(req) as! [TodoList]
    }
    
    func add(name: String) throws {
        let entity = NSEntityDescription.entity(forEntityName: "TodoList",
                                                in: persistentContainer.viewContext)!
        let list = TodoList(entity: entity, insertInto: persistentContainer.viewContext)
        list.name = name
        
        try persistentContainer.viewContext.save()
        lists.append(list)
        lists.sort(by: {$0.name! < $1.name!})
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
