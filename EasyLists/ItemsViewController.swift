import UIKit

class ItemsViewController: UITableViewController {
    
    private var _dataSource: ItemsDataSource? = nil
    
    var dataSource: ItemsDataSource? {
        get {
            return _dataSource
        }
        
        set {
            _dataSource = newValue
            tableView.dataSource = newValue
            
            if let newValue = newValue {
                navigationItem.title = "\(newValue.list.name!)"
                tableView.accessibilityLabel = "\(newValue.list.name!) Items"
            }
        }
    }
        
    @IBAction func showAddDialog(_ sender: Any) {
        let alert = UIAlertController(title: "New Item",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField()
        let nameField = alert.textFields!.first!
        nameField.autocapitalizationType = .sentences
        nameField.autocorrectionType = .yes
        nameField.placeholder = "Item Name"
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            do {
                try self.dataSource!.add(name: nameField.text!)
            } catch let error as NSError {
                // TODO: How to handle this?
                print("Error fetching data: \(error)")
            }

            self.tableView.reloadData()
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

}
