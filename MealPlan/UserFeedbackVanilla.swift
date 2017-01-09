import UIKit

class UserFeedbackVanilla: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    var explainType : Constants.explainerScreenType = Constants.explainerScreenType.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let sub_text_paragraphStyle = paragraphStyle
        sub_text_paragraphStyle.lineHeightMultiple = 1.15
        
        let sub_text_attributes = [
            NSFontAttributeName:Constants.SMALL_FONT,
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:sub_text_paragraphStyle]
        let title_attributes = [
            NSFontAttributeName:Constants.MEAL_PLAN_TITLE,
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle]

        
        let congratulationsText = NSMutableAttributedString(string: "You're doing great!", attributes:title_attributes)
        
        let congratulationsSubText = NSAttributedString(string: "We've made a small cut to the amount of food in your meal plan this week. Keep up the good work.", attributes:sub_text_attributes)
        
        let strictDietText = NSMutableAttributedString(string: "Stay strict", attributes:title_attributes)
        let strictDietSubText = NSAttributedString(string: "From now on, follow your meal plan to the letter. Try not to add any extra foods.", attributes:sub_text_attributes)
        
        let startOverText = NSMutableAttributedString(string: "You're doing well.", attributes: title_attributes)
        let startOverSubText = NSAttributedString(string: "Stick with this weeks plan. I know you can do this. You're a week closer to achieving your goals.", attributes:sub_text_attributes)
        
        let page2Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        
        if explainType == .congratulations {
            let page1Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
            page1Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
            page1Content.imageView.image = UIImage(named:"winner")
            page1Content.textView.attributedText = congratulationsText
            page1Content.subText.attributedText = congratulationsSubText
            let page1 = UIView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
            page1.addSubview(page1Content)
            
            page2Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
            page2Content.imageView.image = UIImage(named:"winner")
            page2Content.textView.textAlignment = .center
            page2Content.textView.attributedText = strictDietText
            page2Content.subText.attributedText = strictDietSubText
            let page2 = UIView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
            page2.addSubview(page2Content)
        } else {
            page2Content.frame = CGRect(x:0, y:0,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
            page2Content.imageView.image = UIImage(named:"winner")
            page2Content.textView.textAlignment = .center
            page2Content.textView.attributedText = startOverText
            page2Content.subText.attributedText = startOverSubText
            let page2 = UIView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
            page2.addSubview(page2Content)
            
            
            
        }
        // Do any additional setup after loading the view.
        page2Content.doneButton.isEnabled = true
        page2Content.doneButton.isEnabled = true
        page2Content.doneButton.layer.cornerRadius = 25
        page2Content.doneButton.backgroundColor = Constants.MP_GREEN
        page2Content.doneButton.addTarget(self, action: #selector(UserFeedbackVanilla.showMealPlan(_:)), for: .touchUpInside)
        
        
        
        let att = NSAttributedString(string: "LET'S GO!", attributes:[
            NSFontAttributeName:Constants.STANDARD_FONT_BOLD,
            NSForegroundColorAttributeName:Constants.MP_WHITE,
            NSParagraphStyleAttributeName:paragraphStyle])
        page2Content.doneButton.setAttributedTitle(att, for: .normal)
        
    }

    @IBAction func showMealPlan(_ sender: UIButton) {
        //performSegue(withIdentifier: "thanksImDone", sender: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.takeUserToMealPlan(shouldShowExplainerScreen: false)
    }

}
