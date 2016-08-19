import Foundation
import UIKit


class PageItemController: UIViewController {
    
    // MARK: - Variables
    var itemIndex: Int = 0 // ***
    var imageName: String = ""  // ***
    @IBOutlet var ButtonHolder: UIView!
    @IBOutlet var letsStartButton : mpButton!
    @IBOutlet var contentImageView: UIImageView!
    @IBOutlet var introText: UITextView!
    @IBOutlet var skipButton: UIButton!
    
    private let introMessages = ["We create customised meal plans to help you lose weight and gain muscle.",
                                 "This works because what you eat is the biggest contributor to what your body looks like.",
                                 "This is what a meal plan looks like",
                                 "Tell us a little bit about yourself so we can create your personalised meal plan"]
  
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        introText.backgroundColor = UIColor.clearColor()
        
        contentImageView!.image = UIImage(named: "mp_Logo")
        contentImageView.contentMode = .ScaleAspectFit
        switch itemIndex
        {
        case 0:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            ButtonHolder.hidden = true;
        case 1:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            contentImageView.hidden = true
            ButtonHolder.hidden = true;
        case 2:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            contentImageView.hidden = true
            ButtonHolder.hidden = true;
        case 3:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            let userInfo = NSUserDefaults.standardUserDefaults()
            userInfo.setBool(true, forKey: "introShown")
            userInfo.synchronize()
            ButtonHolder.hidden = false;
            skipButton.hidden = true;
        default:
            ButtonHolder.hidden = true;
            introText.text = "yo"
            contentImageView.hidden = true
        }
    }
    
    
    
    @IBAction func skipping(sender: AnyObject) {
        print("skipped button pressed.")
    }
    

    
    @IBAction func lestStartAction()
    {
        print("button pressed")
        [performSegueWithIdentifier("identifier", sender: nil)]
    }
    
    
    
}