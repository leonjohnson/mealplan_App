import UIKit

class MPButton: UIButton {
    
    override func awakeFromNib() {
        self.backgroundColor = Constants.MP_GREEN
        self.layer.cornerRadius = 20
        self.isEnabled = true
    }
}
