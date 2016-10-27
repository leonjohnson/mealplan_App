import UIKit


class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Variables
    fileprivate var pageViewController: UIPageViewController!
    
    // Initialize it right away here
    fileprivate let contentImages = ["Intro1.png",
        "Intro2.png",
        "Intro3.png",
        "Intro4.png"];
    
    //DELETE THIS...
    fileprivate let introMessages = ["We create customised meal plans to help you lose weight and gain muscle.",
                                 "This works because what you eat is the biggest contributor to what your body looks like.",
                                 "This is what a meal plan looks like",
                                 "Tell us a little bit about yourself so we can create your personalised meal plan"]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.MP_PURPLE
        createPageViewController()
        setupPageControl()
    }
    
    fileprivate func createPageViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pvController = storyboard.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        pvController.dataSource = self
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers: NSArray = [firstController]
            pvController.setViewControllers(startingViewControllers as? [UIViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        pageViewController = pvController
        addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
        pageViewController!.didMove(toParentViewController: self)
        
    }
    
    fileprivate func setupPageControl() {
        
        let pageControlDots = UIPageControl(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width,height: 44))
        self.view.addSubview(pageControlDots)
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.clear
        
    }
    
    
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! PageItemController
        
        if itemController.itemIndex+1 < contentImages.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    fileprivate func getItemController(_ itemIndex: Int) -> PageItemController? {
        
        if itemIndex < contentImages.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let insertedPage = storyboard.instantiateViewController(withIdentifier: "insertedPage") as! PageItemController
            insertedPage.itemIndex = itemIndex
            //insertedPage.imageName = contentImages[itemIndex]
            return insertedPage
        }
        
        return nil
    }
    

    
    
    // MARK: - Page Indicator
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

