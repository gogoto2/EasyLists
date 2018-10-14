import UIKit

class StubTableView: UITableView {
    
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        return UITableViewCell(style: .default, reuseIdentifier: identifier)
    }
    
}
