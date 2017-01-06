import UIKit

class UpdateController: UIViewController {

    /*
     * THIS METHOD ALLOWS US TO CHECK IF A NEW VERSION AVAILABLE
     * INVOKED FROM THE APP DELEGATE
     */
    static func checkUpdate(){
        
        let currentVersion = getVersion() // GET ACTIVE VERSION
        Connect.checkVersion(key: "",onResponse: { (version, status) in
            if(status){
                //  VERSION NUMBER RETUNED SO
                if version!.compare(currentVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
                {
                    // ("We havE a new version available")
                    // invoke the update VIEW
                    openViewController()
                }
                //else{
                // ("We are on the latest version")
                //  DO NOTHING
                //}
            }

        });
    }
    
    // GET ACTIVE VERSION
    static func getVersion()->String{
        //First get the nsObject by defining as an optional anyObject
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        return version;
    }

    // INVOKE THE UPDATE CONFIRMATION BOX
    static func openViewController(){

        // GET THE NIB FROM STORY BOARD
        let storyboard = UIStoryboard(name: "UpdateController", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "UpdateController")

        // OPEN ON  ROOT VIEW CONTROLLER
        UIApplication.shared.keyWindow?.rootViewController?.present(initialViewController, animated: true, completion: {

        });

    }
    func invokeUpdate(){
        // INVOKE THE URL FROM CONSTANTS
        let url = NSURL(string:Constants.URL_UPDATE_URL)
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open((url! as URL), options: [:], completionHandler: nil)
        }
    }

    @IBAction func onClickLater(sender: AnyObject) {
        self.dismiss(animated: true,completion: nil) // DISMISS CLICKED CLOSE
    }
    @IBAction func onClickUpdate(sender: AnyObject) {
        invokeUpdate()// INVOKE UPDATE CLICKED
    }
}
