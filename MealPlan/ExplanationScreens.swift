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
    
    var screen5Text : NSAttributedString?
    var screen5SubText : NSAttributedString?
    let screen5Image : UIImage = UIImage()
    
    var screen6Text : NSAttributedString?
    var screen6SubText : NSAttributedString?
    let screen6Image : UIImage = UIImage()
    
    var congratulationsText : NSAttributedString?
    var congratulationsSubText : NSAttributedString?
    var congratulationsImage : UIImage = UIImage()
    
    var startOverText : NSAttributedString?
    var startOverSubText : NSAttributedString?
    var startOverImage : UIImage = UIImage()
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        
        
        
        
        let congratulationsTitle = "Your meal plan has been created!"
        let congratulationsSubText = "You don’t need to count calories or macronutrients, it’s all been done for you! You simply follow your meal plan."
        
        let differentTitle = "Your meals will be different for each day of the week."
        let differentSubTitle = "This is so you don't get bored! Feel free to repeat any day's plan if you prefer it over another - the calories and macros will be the same."
        
        let gentlyTitle = "We'll start you off gently."
        let gentlySubTitle = "For the first week you need to eat all of the foods in the meal plan plus any extra foods you want to eat. Just make sure you record your extra foods and drinks in the app."
        
        let preparationTitle = "Preparation will help you to succeed."
        let preparationSubTitle = "You can see the following week's meals in advance so that you can buy and prepare the food you'll need."
        
        let stayactiveTitle = "You have got to stay active!"
        let stayactiveSubTitle = "Ensure you stick with all of the gym sessions / physical activities that you told us about during the sign up process. Your meal plan gives you the food you need to fuel these activities."
        
        let notificationTitle = "Lastly, we'd like to occasionally send you notifications."
        let notificationSubTitle = "You're more likely to stick with a plan if you have reminders."
        
        
        screen1Text = NSAttributedString(string: congratulationsTitle, attributes:title_attributes )
        screen1SubText = NSAttributedString(string: congratulationsSubText, attributes:sub_text_attributes)
        
        screen2Text = NSAttributedString(string: differentTitle, attributes:title_attributes)
        screen2SubText = NSAttributedString(string: differentSubTitle, attributes:sub_text_attributes)
        
        screen3Text = NSMutableAttributedString(string: gentlyTitle, attributes:title_attributes)
        screen3SubText = NSAttributedString(string: gentlySubTitle, attributes:sub_text_attributes)
        
        screen4Text = NSAttributedString(string: preparationTitle, attributes:title_attributes)
        screen4SubText = NSAttributedString(string: preparationSubTitle, attributes:sub_text_attributes)
        
        screen5Text = NSMutableAttributedString(string: stayactiveTitle, attributes: title_attributes)
        screen5SubText = NSAttributedString(string: stayactiveSubTitle, attributes:sub_text_attributes)
        
        screen6Text = NSMutableAttributedString(string: notificationTitle, attributes: title_attributes)
        screen6SubText = NSAttributedString(string: notificationSubTitle, attributes:sub_text_attributes)
        
        
        
        
    }
}
