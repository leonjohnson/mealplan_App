import UIKit
import Fabric
import Crashlytics
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    // The functions called below are arranged in order of calls.
    var window: UIWindow?
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // This method is called to let your app know that it moved from the inactive to active state. This can occur because your app was launched by the user or the system. Apps can also return to the active state if the user chooses to ignore an interruption (such as an incoming phone call or SMS message) that sent the app temporarily to the inactive state.
        
        print("The realm file is here :\(Realm.Configuration.defaultConfiguration.fileURL)")
        SetUpMealPlan.loadDatabaseWithData();
        
        if(Config.getBoolValue(Constants.HAS_PROFILE)){
            
            let response = SetUpMealPlan.doesMealPlanExistForThisWeek()
            let mealPlanExistsForThisWeek = response.yayNay
            

            
            if mealPlanExistsForThisWeek == false{
                askForNewDetails()
                let calRequirements = SetUpMealPlan.calculateInitialCalorieAllowance() // generate new calorie requirements
                SetUpMealPlan.createWeek(daysUntilCommencement: 0, calorieAllowance: calRequirements)
                SetUpMealPlan.createWeek(daysUntilCommencement: 7, calorieAllowance: calRequirements)
                //Eat TDEE plus what you want // create meal plan from today for the next two weeks (we're starting over)
                sendToMealPlanViewController(shouldShowExplainerScreen: true)
                
            } else {
                switch response.weeksAhead.count {
                case 0:
                    askForNewDetails()
                    let currentWeek = Week().currentWeek()
                    let daysUntilExpiry = currentWeek.daysUntilWeekExpires()
                    SetUpMealPlan.createWeek(daysUntilCommencement: daysUntilExpiry, calorieAllowance: currentWeek.calorieAllowance)
                    SetUpMealPlan.createWeek(daysUntilCommencement: (daysUntilExpiry + 7), calorieAllowance: currentWeek.calorieAllowance)
                    sendToMealPlanViewController(shouldShowExplainerScreen: true)
                    // run a new meal plan for next week and the week after
                    break
                case 1:
                    askForNewDetails()
                    let calendar = Calendar.current
                    let currentWeek = Week().currentWeek()
                    let daysUntilExpiry = currentWeek.daysUntilWeekExpires()
                    let startOfThisWeek = response.weeksAhead.first?.start_date
                    let endOfThisWeek = (calendar as NSCalendar).date(byAdding: .day, value: 6, to: currentWeek.start_date, options: [.matchFirst])

                    
                    //TO-DO: Get next weeks plan and use the foods in those meal plans for generating the next mp
                    DataHandler.deleteFutureMealPlans() // delete next weeks plan,
                    var newCaloriesAllowance = 0
                    
                    if(Config.getBoolValue(Constants.STANDARD_CALORIE_CUT) == true){
                        newCaloriesAllowance = SetUpMealPlan.cutCalories(fromWeek: currentWeek, userfoundDiet: (currentWeek.feedback?.easeOfFollowingDiet)!)
                        
                    } else {
                        newCaloriesAllowance = SetUpMealPlan.initialCalorieCut(firstWeek: currentWeek) // run initialCalorieCut
                        Config.setBoolValue(Constants.STANDARD_CALORIE_CUT,status: true)
                    }

                    // run a new meal plan based on this for next week and the week after.
                    SetUpMealPlan.createWeek(daysUntilCommencement: daysUntilExpiry, calorieAllowance: newCaloriesAllowance)
                    sendToMealPlanViewController(shouldShowExplainerScreen: false)

                    break
                case 2:
                    return //we're good so return to your meal plan
                default:
                    // this could be because the user is between the 8th day and 12th day of a meal plan.
                    return
                }
            }
        }
        
        /*
         Does a meal plan exist for this week:
         No- ask for new details and run meal plan from today for the next two weeks(we're starting over)
         
         Yes-
         How many weeks in the future does a meal plan exist for:
         0-ask for new details, run a new meal plan for next week and the week after
         1- if we're one day away from the week end, then ask for new details, delete next weeks plan, run a new meal plan for the next two weeks
         2-exit
         */
        
    }
    
    
    func askForNewDetails()  {
        let storyBoard = Constants.MAIN_STORYBOARD
        let feedbackVC = storyBoard.instantiateViewController(withIdentifier: "feedback");
        self.window?.rootViewController = feedbackVC
        self.window?.makeKeyAndVisible()
    }
    

    func sendToMealPlanViewController(shouldShowExplainerScreen:Bool){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "loggedinTabBar") as! UITabBarController
        if shouldShowExplainerScreen == true{
            (initialViewController.selectedViewController as! MealPlanViewController).showExplainerScreen = true
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
    }
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            
        if(Config.getBoolValue(Constants.HAS_PROFILE)){
            sendToMealPlanViewController(shouldShowExplainerScreen: false)
        }
        //Fabric.with([Crashlytics.self])
        return true
    }
    
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        if(Config.getBoolValue(Constants.HAS_PROFILE)){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewController(withIdentifier: "feedback");
            self.window?.rootViewController?.present(pvc, animated: true, completion: { () -> Void in
                UIApplication.shared.cancelAllLocalNotifications();
            });
            
        }
    }
    
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Split view
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
    
}

