import UIKit

class UserFeedbackVanilla: UIViewController {
    
    var explainType : Constants.explainerScreenType = Constants.explainerScreenType.none
    @IBOutlet var feedbackView : ExplanationScreens!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let startOverText = NSMutableAttributedString(string: "You're doing well.", attributes: title_attributes)
        
        let startOverSubText = NSAttributedString(string: "Stick with this weeks plan. I know you can do this. You're a week closer to achieving your goals.", attributes:sub_text_attributes)
        
        
        switch explainType {
        case .congratulations:
            feedbackView.textView.attributedText = congratulationsText
            feedbackView.subText.attributedText = congratulationsSubText
            feedbackView.imageView.image = UIImage(named:"winner")
            
        case .startingOver:
            feedbackView.textView.attributedText = startOverText
            feedbackView.subText.attributedText = startOverSubText
            feedbackView.imageView.image = UIImage(named:"winner")
        case .none:
            return
        }

        // Do any additional setup after loading the view.
        feedbackView.doneButton.isEnabled = true
        feedbackView.doneButton.layer.cornerRadius = 25
        feedbackView.doneButton.backgroundColor = Constants.MP_GREEN
        
        feedbackView.frame = CGRect(x:40, y:30,width:feedbackView.frame.width - 80, height:feedbackView.frame.height - 60)
        let att = NSAttributedString(string: "LET'S GO!", attributes:[
            NSFontAttributeName:Constants.STANDARD_FONT_BOLD,
            NSForegroundColorAttributeName:Constants.MP_WHITE,
            NSParagraphStyleAttributeName:paragraphStyle])
        feedbackView.doneButton.setAttributedTitle(att, for: .normal)
        
    }

    @IBAction func showMealPlan() {
        performSegue(withIdentifier: "thanksImDone", sender: nil)
    }

}
