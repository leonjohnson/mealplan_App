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
    
    fileprivate let introMessages = ["We create customised meal plans to help you lose weight and gain muscle.",
                                 "This works because what you eat is the biggest contributor to what your body looks like.",
                                 "This is what a meal plan looks like",
                                 "Tell us a little bit about yourself so we can create your personalised meal plan"]
  
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        introText.backgroundColor = UIColor.clear
        
        contentImageView!.image = UIImage(named: "mp_Logo")
        contentImageView.contentMode = .scaleAspectFit
        switch itemIndex
        {
        case 0:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            ButtonHolder.isHidden = true;
        case 1:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            contentImageView.isHidden = true
            ButtonHolder.isHidden = true;
        case 2:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            contentImageView.isHidden = true
            ButtonHolder.isHidden = true;
        case 3:
            let atString = NSAttributedString.init(string: introMessages[itemIndex], attributes: [NSFontAttributeName:Constants.INTRO_TEXT_LABEL, NSForegroundColorAttributeName:Constants.MP_WHITE])
            introText.attributedText = atString
            let userInfo = UserDefaults.standard
            userInfo.set(true, forKey: "introShown")
            userInfo.synchronize()
            ButtonHolder.isHidden = false;
            skipButton.isHidden = true;
        default:
            ButtonHolder.isHidden = true;
            introText.text = "yo"
            contentImageView.isHidden = true
        }
    }
    
    
    
    @IBAction func skipping(_ sender: AnyObject) {
        print("skipped button pressed.")
    }
    

    
    @IBAction func lestStartAction()
    {
        print("button pressed")
        [performSegue(withIdentifier: "identifier", sender: nil)]
    }
    
    
    
}
