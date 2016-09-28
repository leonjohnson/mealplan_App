import UIKit


class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Variables
    private var pageViewController: UIPageViewController!
    
    // Initialize it right away here
    private let contentImages = ["Intro1.png",
        "Intro2.png",
        "Intro3.png",
        "Intro4.png"];
    
    //DELETE THIS...
    private let introMessages = ["We create customised meal plans to help you lose weight and gain muscle.",
                                 "This works because what you eat is the biggest contributor to what your body looks like.",
                                 "This is what a meal plan looks like",
                                 "Tell us a little bit about yourself so we can create your personalised meal plan"]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("here12")
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "pattern")!)
        self.view.backgroundColor = Constants.MP_PURPLE
        createPageViewController()
        setupPageControl()
    }
    
    private func createPageViewController() {
        
        let pvController = self.storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pvController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pvController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        pageViewController = pvController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        
    }
    
    private func setupPageControl() {
        
        let pageControlDots = UIPageControl(frame: CGRectMake(0, 0, self.view.frame.size.width,44))
        self.view.addSubview(pageControlDots)
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.clearColor()
        
    }
    
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let insertedPage = self.storyboard!.instantiateViewControllerWithIdentifier("insertedPage") as! PageItemController
            insertedPage.itemIndex = itemIndex
            //insertedPage.imageName = contentImages[itemIndex]
            return insertedPage
        }
        
        return nil
    }
    

    
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

