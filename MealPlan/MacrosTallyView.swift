import UIKit

class MacrosTallyView: UIView {

    @IBOutlet var headline : UITextView!
    @IBOutlet var imageView : UIImageView!

    
    override func awakeFromNib() {
        self.backgroundColor = UIColor.clear
        headline.backgroundColor = UIColor.clear
        //headline.contentOffset = CGPoint(x: headline.contentOffset.x, y: 0)
        
        
        /*
         let imv = UIImageView.init(image: #imageLiteral(resourceName: "macroCheckMark"))
        print("frame of imageview: \(imageView.frame)")
        imv.frame = imageView.frame
        //imv.addConstraints(imageView.constraints)
        imv.backgroundColor = UIColor.clear
        self.addSubview(imv)
        imageView!.contentMode = .scaleAspectFit
 */
    }

    

}
