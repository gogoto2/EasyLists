import UIKit

class ListsViewController: UITableViewController {
    
    private var _dataSource: ListsDataSource? = nil
    
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
        _dataSource!.fetch()
    }
}
