import UIKit
import CoreData

class ItemsDataSource: NSObject, UITableViewDataSource, ItemCellDelegate {
    
    private let viewContext: NSManagedObjectContext
    let list: TodoList
    var itemsInitiallyNotCompleted: [TodoListItem] = []
    var itemsInitiallyCompleted: [TodoListItem] = []

    init(list: TodoList, viewContext: NSManagedObjectContext) {
        self.list = list
        self.viewContext = viewContext
        
        // Show completed items first, but otherwise preserve order.
        // Items won't be reordered once initially shown.
        for x in self.list.items! {
            let item = x as! TodoListItem
            if item.isCompleted {
                itemsInitiallyCompleted.append(item)
            } else {
                itemsInitiallyNotCompleted.append(item)
            }
        }
    }
    
    func add(name: String) throws {
        let item = TodoListItem(context: viewContext)
        item.name = name
        list.addToItems(item)
        itemsInitiallyNotCompleted.append(item)
        try viewContext.save()
    }
    
    func itemAtIndex(_ i: Int) -> TodoListItem {
        if i < itemsInitiallyNotCompleted.count {
            return itemsInitiallyNotCompleted[i]
        } else {
            return itemsInitiallyCompleted[i - itemsInitiallyNotCompleted.count]
        }
    }
    
    func deleteItemAtIndex(_ i: Int) throws {
        let item: TodoListItem
        if i < itemsInitiallyNotCompleted.count {
            item = itemsInitiallyNotCompleted.remove(at: i)
        } else {
            item = itemsInitiallyCompleted.remove(at: i - itemsInitiallyNotCompleted.count)
        }
        
        viewContext.delete(item)
        try viewContext.save()
    }
        
    // MARK: - UITableViewDataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsInitiallyNotCompleted.count + itemsInitiallyCompleted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item cell") as! ItemCell
        cell.item = itemAtIndex(indexPath.row)
        cell.delegate = self
        return cell
    }

    // MARK: - ItemCellDelegate methods
    
    func itemCell(_ sender: ItemCell, didSetCompleted completed: Bool) {
        sender.item?.isCompleted = completed
        
        do {
            try viewContext.save()
        } catch {
            // TODO how to handle this?
            print("Error saving item: \(error)")
        }
    }

}
