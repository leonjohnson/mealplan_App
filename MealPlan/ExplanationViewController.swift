//
//  ViewController.swift
//  Story
//
//  Created by Safiyan Zulfiqar on 11/30/16.
//  Copyright © 2016 Safiyan Zulfiqar. All rights reserved.
//

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
        
        // Page 1 of scroll view
        let page1Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page1Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page1Content.textView.attributedText = NSMutableAttributedString(string: "Your meal plan has been created!", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_BLACK])
        page1Content.textView.textAlignment = .center
        
        page1Content.subText.attributedText = NSAttributedString(string: "You don’t need to count calories or macronutrients, it’s all been done for you.", attributes:[NSFontAttributeName:Constants.SMALL_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK])
        let page1 = UIView(frame: CGRect(x:0, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page1.addSubview(page1Content)
        
        
        
        
        // Page 2 of Scroll View
        let page2Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page2Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page2Content.textView.textAlignment = .center
        page2Content.textView.attributedText = NSMutableAttributedString(string: "We'll start you off slowly", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_BLACK])
        
        page2Content.subText.attributedText = NSAttributedString(string: "For the first week you need to eat all of the foods in the meal plan plus any extra foods that you want to eat, but you have to record it in the meal plan!", attributes:[NSFontAttributeName:Constants.SMALL_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK])
        
        
        
        let page2 = UIView(frame: CGRect(x:scrollViewWidth, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page2.addSubview(page2Content)
        
        
        
        
        
        // Page 3 of Scroll View
        let page3Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page3Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page3Content.textView.textAlignment = .center
        page3Content.textView.attributedText = NSMutableAttributedString(string: "You'll get a different meal plan for each day of the week", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_BLACK])
        
        page3Content.subText.attributedText = NSAttributedString(string: "Your meal plan has been made just for you based on your macronutrient needs and avoiding the things your dislike", attributes:[NSFontAttributeName:Constants.SMALL_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK])
        let page3 = UIView(frame: CGRect(x:scrollViewWidth*2, y:0,width:scrollViewWidth, height:scrollViewHeight))
        page3.addSubview(page3Content)
        
        
        // Page 4 of scroll view
        let page4Content = ExplanationScreens.loadFromNibNamed(nibNamed: "FirstView")!
        page4Content.frame = CGRect(x:40, y:30,width:scrollViewWidth - 80, height:scrollViewHeight - 60)
        page4Content.textView.textAlignment = .center
        page4Content.textView.attributedText = NSMutableAttributedString(string: "You need scales", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_TITLE, NSForegroundColorAttributeName:Constants.MP_BLACK])
        
        page4Content.subText.attributedText = NSAttributedString(string: "To know how much you’re eating, you’ll need to weigh your food. For this reason you’ll need some scales.", attributes:[NSFontAttributeName:Constants.SMALL_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK])
        let page4 = UIView(frame: CGRect(x:scrollViewWidth*3, y:0,width:scrollViewWidth*3, height:scrollViewHeight))
        
        
        let doneButton = page4Content.doneButton!
        doneButton.backgroundColor = Constants.MP_GREEN
        doneButton.layer.cornerRadius = 25
        doneButton.addTarget(self, action: #selector(ExplanationViewController.takeMeToMyMealPlan(_:)), for: .touchUpInside)
        let att = NSAttributedString(string: "Let's get started", attributes:[NSFontAttributeName:Constants.MEAL_PLAN_SUBTITLE, NSForegroundColorAttributeName:Constants.MP_WHITE])
        doneButton.setAttributedTitle(att, for: .normal)
        
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
    }
}



