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
        
        
        let congratulationsText = NSMutableAttributedString(string: "Keep up the good work!", attributes:title_attributes)
        
        let congratulationsSubText = NSAttributedString(string: "You're doing great. You're a week closer to achieving your goals.", attributes:sub_text_attributes)
        
        let startOverText = NSMutableAttributedString(string: "Keep up the good work!", attributes: title_attributes)
        
        let startOverSubText = NSAttributedString(string: "You're doing great. You're a week closer to achieving your goals.", attributes:sub_text_attributes)
        
        
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
    }

    @IBAction func showMealPlan() {
        performSegue(withIdentifier: "thanksImDone", sender: nil)
    }

}
