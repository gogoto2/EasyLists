import UIKit

protocol ItemCellDelegate: class {
    func itemCell(_ sender: ItemCell, didSetCompleted completed: Bool)
}

class ItemCell: UITableViewCell {
    weak var delegate: ItemCellDelegate? = nil
    
    private var _item: TodoListItem? = nil
    
    var item: TodoListItem? {
        get {
            return _item
        }
        
        set {
            _item = newValue
            textLabel!.text = _item?.name
            completedSwitch!.isOn = _item?.isCompleted ?? false
        }
    }
    
    private var completedSwitch: UISwitch? {
        get {
            return accessoryView as? UISwitch
        }

        set {
            accessoryView = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completedSwitch = UISwitch(frame: CGRect.zero)
        completedSwitch!.accessibilityLabel = "completed"
        completedSwitch!.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }

    @objc func switchChanged(_ sender: UISwitch) {
        delegate?.itemCell(self, didSetCompleted: sender.isOn)
    }
}
