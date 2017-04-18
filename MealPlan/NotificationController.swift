//
//  NotificationController.swift
//  MealPlan
//
//  Created by toobler on 27/02/17.
//  Copyright © 2017 Meals. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationController:UIViewController  {

    static let intervel = 6.5 * 24 * 60 * 60 ;

    @IBOutlet weak var btnswitch: UISwitch!


    override func viewDidLoad() {
        super.viewDidLoad()
        btnswitch.setOn(NotificationController.isNotificationallowed(), animated: false);

        // Do any additional setup after loading the view.
    }
    @IBAction func onChange(_ sender: Any) {
        NotificationController.allowLocalNotification(status: btnswitch.isOn);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Method for Navigating back to previous ViewController.
    @IBAction func closeAction(_ sender: AnyObject) {
        //  self.navigationController?.popViewController(animated: true);

    }
    














    static func fireLocalNotification(){

        let content = UNMutableNotificationContent()
        content.title = "We are reaching the End of this Week"
        content.subtitle = "Please check the last "
        content.body = "Fill the form and continue"
        content.categoryIdentifier = "Messages"

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: intervel,
            repeats: false)

        let request = UNNotificationRequest(
            identifier: "feedback",
            content: content,
            trigger: trigger
        )
        UNUserNotificationCenter.current().add(
            request, withCompletionHandler: nil)


    }
    static func createdNewMeal(){
        clearAll();
        fireLocalNotification();
    }
    static func clearAll(){
        //   UIApplication.shared.cancelAllLocalNotifications();
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests() // To remove all pending notifications which are not delivered yet but scheduled.
    }

    public static  func allowLocalNotification(status : Bool){
        if(!status){
            clearAll();
        }
        Config.setBoolValue(Constants.NOTIFICATION_ALLOWED, status: status);
    }
    public static func isNotificationallowed()->Bool{
       return  Config.getBoolValue(Constants.NOTIFICATION_ALLOWED);
    }
}
