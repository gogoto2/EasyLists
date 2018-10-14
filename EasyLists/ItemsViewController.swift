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
    
    @IBOutlet var addButton: UIBarButtonItem!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var newItemWrapper: UIView!
    @IBOutlet weak var newItemWrapperHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var newItemNameField: UITextField!
    private var newItemWrapperSavedHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        hideNewItemWrapper()
    }
    
    func setupTableView() {
        guard let tableView = tableView else {return}
        guard let dataSource = dataSource else {return}
        tableView.dataSource = dataSource
        tableView.accessibilityLabel = "\(dataSource.list.name!) Items"
    }
    
    func hideNewItemWrapper() {
        newItemWrapperSavedHeight = newItemWrapperHeightConstraint.constant
        newItemWrapperHeightConstraint.constant = 0
        navigationItem.leftBarButtonItems = []
        navigationItem.rightBarButtonItems = [addButton]
    }

    @IBAction func showAddDialog(_ sender: Any) {
        navigationItem.leftBarButtonItems = [cancelButton]
        navigationItem.rightBarButtonItems = [saveButton]
        newItemWrapperHeightConstraint.constant = newItemWrapperSavedHeight
        newItemNameField.becomeFirstResponder()
    }
    
    @IBAction func addItem(_ sender: Any) {
        guard let name = newItemNameField.text else {
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

        newItemNameField.text = ""
        hideNewItemWrapper()
        tableView!.reloadData()
    }
    
    @IBAction func cancelAddItem(_ sender: Any) {
        newItemNameField.text = ""
        hideNewItemWrapper()
    }
}
