import UIKit
import UserNotifications
import FacebookCore


extension ExplanationScreens {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> ExplanationScreens? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? ExplanationScreens
    }
}




class ExplanationViewController: UIViewController,UIScrollViewDelegate,UIPageViewControllerDelegate{

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.scrollView.frame = CGRect(x:0, y:0, width:self.view.frame.width, height:self.view.frame.height)
        let scrollViewWidth:CGFloat = self.scrollView.frame.width
        let scrollViewHeight:CGFloat = self.scrollView.frame.height
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes = [NSFontAttributeName:Constants.SMALL_FONT,
                          NSForegroundColorAttributeName:Constants.MP_BLACK,
                          NSParagraphStyleAttributeName:paragraphStyle]
        
        //TOD0 - This could all be a loop instead of repeating the same code
        
        // Page 1 of scroll view
        let page1Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page1Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page1Content.imageView.image = UIImage(named:"winner")

        page1Content.textView.attributedText = page1Content.screen1Text
        page1Content.subText.attributedText = NSAttributedString(string: "You don’t need to count calories or macronutrients, it’s all been done for you, simply follow the meal plan", attributes:attributes)
        let page1 = UIView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page1.addSubview(page1Content)
        
        
        // Page 2 of Scroll View
        let page2Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page2Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page2Content.imageView.image = UIImage(named:"calendar")
        page2Content.textView.textAlignment = .center
        page2Content.textView.attributedText = page2Content.screen2Text
        page2Content.subText.attributedText = page2Content.screen2SubText
        let page2 = UIView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page2.addSubview(page2Content)
        
        
        // Page 3 of Scroll View
        let page3Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page3Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page3Content.imageView.image = UIImage(named:"mealplan")
        page3Content.textView.attributedText = page3Content.screen3Text
        page3Content.subText.attributedText = page3Content.screen3SubText
        let page3 = UIView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page3.addSubview(page3Content)
        
        
        // Page 4 of scroll view
        let page4Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page4Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page4Content.imageView.image = UIImage(named:"scales")
        page4Content.textView.attributedText = page4Content.screen4Text
        page4Content.subText.attributedText = page4Content.screen4SubText
        let page4 = UIView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth*3, height:scrollViewHeight))
        page4.addSubview(page4Content)
        
        
        // Page 5 of scroll view
        let page5Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page5Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page5Content.imageView.image = UIImage(named:"running")
        page5Content.textView.attributedText = page5Content.screen5Text
        page5Content.subText.attributedText = page5Content.screen5SubText
        let page5 = UIView(frame: CGRect(x:scrollViewWidth*4, y:0,width:scrollViewWidth*3, height:scrollViewHeight))
        page5.addSubview(page5Content)
        
        
        // Page 6 of scroll view
        let page6Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page6Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page6Content.imageView.image = UIImage(named:"notification")
        page6Content.textView.attributedText = page6Content.screen6Text
        page6Content.subText.attributedText = page6Content.screen6SubText
        let page6 = UIView(frame: CGRect(x:scrollViewWidth*5, y:0,width:scrollViewWidth*3, height:scrollViewHeight))
        page6.addSubview(page6Content)
        
        
        // Page 7 of scroll view
        let page7Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page7Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page7Content.imageView.image = UIImage(named:"running")
        page7Content.textView.attributedText = page7Content.screen7Text
        page7Content.subText.attributedText = page7Content.screen7SubText
        let page7 = UIView(frame: CGRect(x:scrollViewWidth*6, y:0,width:scrollViewWidth*3, height:scrollViewHeight))
        page7.addSubview(page7Content)
        
        
        let doneButton = page7Content.doneButton!
        doneButton.backgroundColor = Constants.MP_GREEN
        doneButton.layer.cornerRadius = 25
        doneButton.addTarget(self, action: #selector(ExplanationViewController.showmp(_:)), for: .touchUpInside)
        let att = NSAttributedString(string: "OK, let's get started", attributes:[
            NSFontAttributeName:Constants.STANDARD_FONT_BOLD, 
            NSForegroundColorAttributeName:Constants.MP_WHITE,
            NSParagraphStyleAttributeName:paragraphStyle])
        doneButton.setAttributedTitle(att, for: .normal)
        doneButton.isUserInteractionEnabled = true
        doneButton.isEnabled = true
        
        
        
        self.scrollView.addSubview(page1)
        self.scrollView.addSubview(page2)
        self.scrollView.addSubview(page3)
        self.scrollView.addSubview(page4)
        self.scrollView.addSubview(page5)
        self.scrollView.addSubview(page6)
        self.scrollView.addSubview(page7)
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 7, height:self.scrollView.frame.height)
        
        
        self.scrollView.delegate = self
        self.pageControl.currentPage = 0
        self.pageControl.currentPageIndicatorTintColor = Constants.MP_GREEN
        self.pageControl.pageIndicatorTintColor = Constants.MP_DARK_GREY
        
        
    }
    
    
    
 
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let page : CGFloat = CGFloat(sender.currentPage);
        var frame = self.scrollView.frame;
        frame.origin.x = (frame.size.width * (page * 1.0))
        frame.origin.y = 0
        self.scrollView.scrollRectToVisible(frame, animated: true)
        //if Int(page) == pageControl.numberOfPages{}
        
    }
    
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage)
        
        if pageControl.currentPage == pageControl.numberOfPages - 1{
            #if debug
                print("on the notification screen")
            #endif
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            if UIApplication.shared.responds(to:#selector(getter: UIApplication.isRegisteredForRemoteNotifications)) {
                UIApplication.shared.registerUserNotificationSettings(settings)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func showmp(_ sender: UIButton){
        
        let calRequirements = SetUpMealPlan.calculateInitialCalorieAllowance() // generate new calorie requirements
        SetUpMealPlan.createWeek(daysUntilCommencement: 0, calorieAllowance: calRequirements)
        SetUpMealPlan.createWeek(daysUntilCommencement: 7, calorieAllowance: calRequirements)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.takeUserToMealPlan(shouldShowExplainerScreen: false)
        
        let gender = DataHandler.getActiveUser().gender
        AppEventsLogger.log("\(gender) completed walkthrough")
    }
    
    
    

 
    
}



