import UIKit
import JSQMessagesViewController

class BotCellWithButton: JSQMessagesCollectionViewCellIncoming, BotDelegate {
    
    @IBOutlet var questionTextView : JSQMessagesCellTextView?
    @IBOutlet var button:MPButton!
    var question : String = String()
    var data : (question:String, options:[String]) = ("",[])
    
    var botDelegate: BotDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.questionTextView?.attributedText = NSAttributedString(string: "", attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
        self.messageBubbleTopLabel.textAlignment = .center
        self.tapGestureRecognizer.cancelsTouchesInView = false
        self.cellBottomLabel.textAlignment = .right
        
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        /*
        self.messageBubbleContainerView.frame = CGRect(x: self.messageBubbleContainerView.frame.origin.x,
                                                       y: self.messageBubbleContainerView.frame.origin.y,
                                                       width: self.messageBubbleContainerView.frame.width,
                                                       height: CGFloat(300))
 */
    }
    
    
    
    override class func nib() -> UINib {
        return UINib(nibName: "BotCellWithButton", bundle: nil)
    }
    
    override class func mediaCellReuseIdentifier() -> String {
        return "CustomMessagesCollectionViewCellIncoming"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @IBAction func noValueSelected(sender: UIButton) {
        print("noValueSelected")
        botDelegate?.buttonTapped!(forQuestion: question)
    }
    

}







