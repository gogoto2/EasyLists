import UIKit

class ItemsViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView? = nil
    private var _dataSource: ItemsDataSource? = nil
    
    var dataSource: ItemsDataSource? {
        get {
            return _dataSource
        }
        
        set {
            _dataSource = newValue
            setupTableView()
            
            if let newValue = newValue {
                navigationItem.title = "\(newValue.list.name!)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        guard let tableView = tableView else {return}
        guard let dataSource = dataSource else {return}
        tableView.dataSource = dataSource
        tableView.accessibilityLabel = "\(dataSource.list.name!) Items"
    }
    
    @IBAction func addItem(_ sender: UITextField) {
        guard let name = sender.text else {
            return
        }
        
        if name.count == 0 {
            return
        }
        
        do {
            try dataSource!.add(name: name)
        } catch let error as NSError {
            // TODO: How to handle this?
            print("Error saving item: \(error)")
            return
        }

        sender.text = ""
        tableView!.reloadData()
    }
    
    func deleteItemAtIndex(_ i: Int) {
        do {
            try dataSource!.deleteItemAtIndex(i)
            tableView?.reloadData()
        } catch {
            print("Error deleting item: \(error)")
        }
    }
    
    // MARK: - UITableViewDelegate methods

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
         let title = NSLocalizedString("Delete", comment: "Delete action")
         let action = UITableViewRowAction(style: .destructive,
                                           title: title) { (action, indexPath) in
                                            self.deleteItemAtIndex(indexPath.row)
         }
        
         return [action]
     }
}
