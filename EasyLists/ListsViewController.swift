import UIKit

class ListsViewController: UITableViewController {
    
    private var _dataSource: ListsDataSource? = nil
    var makeItemsDataSource: ((TodoList) -> ItemsDataSource)? = nil
    
    var dataSource: ListsDataSource? {
        get {
            return _dataSource
        }
        
        set {
            _dataSource = newValue
            tableView.dataSource = newValue
        }
    }
    
    override func viewDidLoad() {
        do {
            try _dataSource!.fetch()
        } catch {
            // TODO: How to handle this?
            print("Error fetching data: \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ItemsViewController {
            let list = (sender as! ListCell).list!
            destination.dataSource = makeItemsDataSource!(list)
        }
    }
    
    @IBAction func showAddDialog(_ sender: Any) {
        let alert = UIAlertController(title: "New List",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField()
        let nameField = alert.textFields!.first!
        nameField.autocapitalizationType = .sentences
        nameField.autocorrectionType = .yes
        nameField.placeholder = "List Name"
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            do {
                try self.dataSource!.add(name: nameField.text!)
            } catch {
                // TODO: How to handle this?
                print("Error saving list: \(error)")

            }
            self.tableView.reloadData()
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

}
