import UIKit

class MacrosTallyView: UIView {

    @IBOutlet var headline : UITextView!
    @IBOutlet var imageView : UIImageView!

    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        headline.backgroundColor = UIColor.clear
        //headline.contentOffset = CGPoint(x: headline.contentOffset.x, y: 0)
    }

    

}
