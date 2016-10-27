import Foundation
import MBProgressHUD
import AFNetworking
import Reachability


class Network {
    
    static var showNetWorkError = true
    
    
    
    static let KEY_CONTENT_TYPE     = "Content-Type"
    static let KEY_APPJSON          = "application/json"
    static let KEY_TEXTHTML         = "text/html"
    static let KEY_FORM             = "application/x-www-form-urlencoded"
    static let KEY_TEXTPLAIN        = "text/plain"
    static let KEY_TEXTJSON         = "text/json"
    static let KEY_TEXTJS           = "text/javascript"
    static let KEY_AUDIOWAV         = "audio/wav"
    static let KEY_IMAGEMIME         = "image/jpeg"
    static let KEY_IMAGETYPE         = ".jpg"
    
    static let METHOD_GET         = "GET"
    static let METHOD_POST         = "POST"
    static let METHOD_PUT         = "PUT"
    static let METHOD_DELETE         = "DELETE"
     //TO DO COMMENDTS
    static func addApiKey(_ parameters:NSMutableDictionary){
        let apiKey = Config.getApiKey()
        if(apiKey != Constants.KEY_EMPTY){
            parameters.setValue(apiKey, forKey: Constants.REQ_API_KEY)
        }
    }
     //TO DO COMMENDTS
    static func isDataConnectionAvailable() -> Bool {
        return Reachability.forInternetConnection().currentReachabilityStatus() != NetworkStatus.NotReachable
    }
    
    
     //TO DO COMMENDTS
    static func executeGETWithUrl( _ url: String, andParameters parameters: NSMutableDictionary , andHeaders headers: [AnyHashable: Any]?, withSuccessHandler success: @escaping (AFHTTPRequestOperation?,AnyObject?,Bool) -> Void, withFailureHandler failure: @escaping (AFHTTPRequestOperation?,NSError?) -> Void, withLoadingViewOn parentView: UIView?) {
        addApiKey(parameters)
        if (!Network.isDataConnectionAvailable()) {
            
            //MBProgressHUD.hideAllHUDsForView(parentView!, animated: true)
            if((parentView) != nil && showNetWorkError){
                showNetWorkError = false
                Config.showAlert(nil, message:   Constants.ERROR_NETWORK)
            }
            failure(AFHTTPRequestOperation(), NSError(domain:  Constants.ERROR_NETWORK, code: 0, userInfo: [ Constants.KEY_EMPTY: Constants.KEY_EMPTY]))
            
// COMMENDTED ALERT FOR CHECKING
//            let alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
//            alert.show()
//

        }
        showNetWorkError = true
        let manager: AFHTTPRequestOperationManager = AFHTTPRequestOperationManager()
        manager.requestSerializer.setValue(KEY_FORM, forHTTPHeaderField: KEY_CONTENT_TYPE)
        
        manager.responseSerializer = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions.allowFragments) as AFJSONResponseSerializer
        manager.responseSerializer.acceptableContentTypes = NSSet(objects:KEY_APPJSON, KEY_TEXTHTML, KEY_TEXTPLAIN, KEY_TEXTJSON, KEY_TEXTJS, KEY_AUDIOWAV) as Set<NSObject>
        // manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
        
        if (parentView != nil) {
            MBProgressHUD.showAdded(to: parentView!, animated: true)
        }
        print(METHOD_GET+url)
        manager.get(url, parameters: parameters, success: { (operation:AFHTTPRequestOperation, responseObject:Any) -> Void in
            if (parentView != nil) {
                //MBProgressHUD.hideAllHUDsForView(parentView!, animated: true)
            }
            if (operation.isCancelled) {
                return
            }
            let apiSuccess: Bool = true
            success(operation, responseObject as AnyObject?, apiSuccess)
            
            
            }) { (operation: AFHTTPRequestOperation?, error:Error) -> Void in
                
                if (parentView != nil) {
                    //MBProgressHUD.hideAllHUDsForView(parentView!, animated: true)
                }
                failure(AFHTTPRequestOperation(), NSError(domain:  Constants.ERROR_NETWORK, code: 0, userInfo: [ Constants.KEY_EMPTY: Constants.KEY_EMPTY]))
        }
        
    }
    
    
}
