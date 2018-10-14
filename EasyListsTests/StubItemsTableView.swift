import UIKit

class StubItemsTableView: UITableView {
    
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        return UITableViewCell(style: .default, reuseIdentifier: identifier)
    }
    
}
