//
//  AppDelegate.swift
//  DailyMeals
//
//  Created by Mzalih on 18/11/15.
//  Copyright © 2015 Meals. All rights reserved.
//

import UIKit

//import Reachability

//var reach: Reachability?

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //enableLocalNotification();
        
        DataHandler.calculateCalorieAllowance()
    
        if(Config.getBoolValue(Config.HAS_PROFILE)){
            
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            //let initialViewController = storyboard.instantiateViewControllerWithIdentifier("LogedInView")
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("loggedinTabBar") as! UITabBarController
            
            
            
//            let tabBarItem1:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Pie Chart-50")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "Pie Chart Filled-50"))
//
//            let tabBarItem2:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "Meal-50")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "Meal Filled-50"))
//            
//            let tabBarItem3:UITabBarItem = UITabBarItem(title: nil, image: UIImage(named: "settings filled")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal), selectedImage: UIImage(named: "settings unfilled"))
//            
//            initialViewController.setViewControllers(<#T##viewControllers: [UIViewController]?##[UIViewController]?#>, animated: <#T##Bool#>)
//            initialViewController.tabBar.setItems([tabBarItem1, tabBarItem2, tabBarItem3], animated: true)
            
            
            
            
            
            

            
            self.window?.rootViewController = initialViewController
            self.window?.makeKeyAndVisible()
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        }
        
        return true
    }
    
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        
        if(Config.getBoolValue(Config.HAS_PROFILE)){
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pvc = storyboard.instantiateViewControllerWithIdentifier("feedback");
            self.window?.rootViewController?.presentViewController(pvc, animated: true, completion: { () -> Void in
                UIApplication.sharedApplication().cancelAllLocalNotifications();
            });
            
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        DataStructure.createFood();
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Split view
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController:UIViewController, ontoPrimaryViewController primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
    
    
}

