import UIKit

class StubItemsTableView: UITableView {
    
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        let cell = ItemCell()
        cell.awakeFromNib()
        return cell
    }
    
}
