import UIKit

class ExplanationScreens: UIView {
    @IBOutlet var mainObject : UIView!
    @IBOutlet var textView : UITextView!
    @IBOutlet var imageView : UIImageView!
    @IBOutlet var subText : UILabel!
    @IBOutlet var doneButton : UIButton!
    
    var screen1Text : NSAttributedString?
    var screen1SubText : NSAttributedString?
    let screen1Image : UIImage = UIImage()
    
    var screen2Text : NSAttributedString?
    var screen2SubText : NSAttributedString?
    let screen2Image : UIImage = UIImage()
    
    var screen3Text : NSAttributedString?
    var screen3SubText : NSAttributedString?
    let screen3Image : UIImage = UIImage()
    
    var screen4Text : NSAttributedString?
    var screen4SubText : NSAttributedString?
    let screen4Image : UIImage = UIImage()
    

    override func awakeFromNib() {
        
        textView.textAlignment = .center
        mainObject.layer.cornerRadius = 10
        mainObject.layer.borderWidth = 0.5
        mainObject.layer.borderColor =  Constants.MP_DARK_GREY.cgColor
        mainObject.backgroundColor = Constants.MP_LIGHT_GREY
        
        
        doneButton.frame = CGRect(origin: doneButton.frame.origin, size: CGSize(width:mainObject.frame.width, height:64))
        doneButton.backgroundColor = Constants.MP_WHITE
        doneButton.isEnabled = false
        doneButton.setTitleColor(Constants.MP_WHITE, for: .disabled)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [
            NSFontAttributeName:Constants.SMALL_FONT,
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle]

        
        screen1Text = NSAttributedString(string: "Your meal plan has been created!", attributes:[
            NSFontAttributeName:Constants.MEAL_PLAN_TITLE,
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle])
        screen1SubText = NSAttributedString(string: "You don’t need to count calories or macronutrients, it’s all been done for you. You simply follow the meal plan", attributes:attributes)
        
        
        screen2Text = NSMutableAttributedString(string: "We'll start you off slowly", attributes:[
            NSFontAttributeName:Constants.MEAL_PLAN_TITLE, 
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle])
        screen2SubText = NSAttributedString(string: "For the first week you need to eat all of the foods in the meal plan plus any extra foods you want to eat, but you have to record it in the meal plan!", attributes:attributes)
        
        screen3Text = NSAttributedString(string: "You'll get a different meal plan for each day of the week", attributes:attributes)
        screen3SubText = NSAttributedString(string: "Each one is slightly different. Feel free to follow the same plan if you prefer one over others.", attributes:attributes)
        
        screen4Text = NSAttributedString(string: "You'll need to prepare your meals in advance", attributes:[
            NSFontAttributeName:Constants.MEAL_PLAN_TITLE,
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle])
        screen4SubText = NSAttributedString(string: "Each one is slightly different. Feel free to follow the same plan if you prefer one over others.", attributes:attributes)
        
    }
}
