import UIKit

class StubListsTableView: UITableView {
    
    override func dequeueReusableCell(withIdentifier identifier: String) -> UITableViewCell? {
        return ListCell()
    }
    
}
