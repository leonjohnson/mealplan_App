import UIKit

class MPButton: UIButton {
    
    override func awakeFromNib() {
        self.backgroundColor = Constants.MP_GREEN
        self.layer.cornerRadius = 11
        self.isEnabled = true
    }
}
