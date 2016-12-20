import UIKit


extension ExplanationScreens {
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> ExplanationScreens? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? ExplanationScreens
    }
}




class ExplanationViewController: UIViewController,UIScrollViewDelegate{

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
        
        
        // Page 1 of scroll view
        let page1Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page1Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page1Content.textView.attributedText = page1Content.screen1Text
        page1Content.subText.attributedText = NSAttributedString(string: "You don’t need to count calories or macronutrients, it’s all been done for you. You simply follow the meal plan", attributes:[NSFontAttributeName:Constants.SMALL_FONT,
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle])
        let page1 = UIView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page1.addSubview(page1Content)
        
        
        // Page 2 of Scroll View
        let page2Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page2Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page2Content.textView.textAlignment = .center
        page2Content.textView.attributedText = page2Content.screen2Text
        page2Content.subText.attributedText = NSAttributedString(string: "For the first week you need to eat all of the foods in the meal plan plus any extra foods you want to eat, but you have to record it in the meal plan!", attributes:[
            NSFontAttributeName:Constants.SMALL_FONT,
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle])
        let page2 = UIView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page2.addSubview(page2Content)
        
        
        // Page 3 of Scroll View
        let page3Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page3Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page3Content.textView.attributedText = page3Content.screen3Text
        page3Content.subText.attributedText = NSAttributedString(string: "Each one is slightly different. Feel free to follow the same plan if you prefer one over others.", attributes:[
            NSFontAttributeName:Constants.SMALL_FONT, 
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle])
        let page3 = UIView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page3.addSubview(page3Content)
        
        
        // Page 4 of scroll view
        let page4Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page4Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page4Content.textView.attributedText = page4Content.screen4Text
        page4Content.subText.attributedText = NSAttributedString(string: "To know how much you’re eating, you’ll need to weigh your food. For this reason you’ll need some scales.", attributes:[
            NSFontAttributeName:Constants.SMALL_FONT, 
            NSForegroundColorAttributeName:Constants.MP_BLACK,
            NSParagraphStyleAttributeName:paragraphStyle])
        let page4 = UIView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth*3, height:scrollViewHeight))
        
        
        let doneButton = page4Content.doneButton!
        doneButton.backgroundColor = Constants.MP_GREEN
        doneButton.layer.cornerRadius = 25
        doneButton.addTarget(self, action: #selector(ExplanationViewController.takeMeToMyMealPlan(_:)), for: .allTouchEvents)
        let att = NSAttributedString(string: "Let's get started", attributes:[
            NSFontAttributeName:Constants.MEAL_PLAN_SUBTITLE, 
            NSForegroundColorAttributeName:Constants.MP_WHITE,
            NSParagraphStyleAttributeName:paragraphStyle])
        doneButton.setAttributedTitle(att, for: .normal)
        doneButton.isUserInteractionEnabled = true
        doneButton.isEnabled = true
        
        page4.addSubview(page4Content)
        
        
        
        self.scrollView.addSubview(page1)
        self.scrollView.addSubview(page2)
        self.scrollView.addSubview(page3)
        self.scrollView.addSubview(page4)
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.width * 4, height:self.scrollView.frame.height)
        
        
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
        if Int(page) == pageControl.numberOfPages{
        }
        
    
    }
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        // Test the offset and calculate the current page after scrolling ends
        let pageWidth:CGFloat = scrollView.frame.width
        let currentPage:CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        // Change the indicator
        self.pageControl.currentPage = Int(currentPage);
        
    
        }
    
    @IBAction func takeMeToMyMealPlan(_ sender: UIButton){
        print("pressed")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.takeUserToMealPlan(shouldShowExplainerScreen: false)
    }
}



