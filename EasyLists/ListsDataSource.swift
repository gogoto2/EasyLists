import UIKit
import CoreData

class ListsDataSource: NSObject, UITableViewDataSource {
    
    private let persistentContainer: NSPersistentContainer
    private var lists: [TodoList] = []
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func fetch() {
        do {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
            req.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            self.lists = try persistentContainer.viewContext.fetch(req) as! [TodoList]
        } catch let error as NSError {
            // TODO: How to handle this?
            print("Error fetching data: \(error)")
        }
    }
    
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal cell")!
        cell.textLabel!.text = lists[indexPath.row].name
        return cell
    }
    
}
