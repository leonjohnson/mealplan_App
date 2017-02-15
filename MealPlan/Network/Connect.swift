import UIKit
import RealmSwift
import AFNetworking
class Connect: NSObject {
    
    //Method for Converting all Values to Double Format.
    static func getDoubleValueForKey(_ key:String, pdt:NSDictionary)-> Double?{
        
        if let value :NSString = (pdt.value(forKey: key) as? NSString){
            if let answer:Double = value.doubleValue{
                return answer;
            }
            if let answer:Int = value.integerValue{
                return Double(answer);
            }
        }
        if let value :Double = (pdt.value(forKey: key) as? Double){
            return value
        }
        if let value :Int = (pdt.value(forKey: key) as? Int){
            return Double(value)
        }
        
        return nil
    }
    static func checkVersion(key:String, onResponse:@escaping (_ version:String?,_ status:Bool) -> Void)->Void{

        let success = { (operation:AFHTTPRequestOperation?,response:AnyObject?, status:Bool) -> Void in
            if let versionAvailbale = response as? NSDictionary{

                if let value:String  = versionAvailbale.value(forKey: Constants.API_VERSION) as? String{
                    onResponse(value,true)
                }else{
                    onResponse(nil,false)
                }

            }else{
                onResponse(nil,false)
            }
        } ;


        let failure  = { (op:AFHTTPRequestOperation?, err:NSError?) -> Void in
            onResponse(nil,false)
        }

        Network.executeGETWithUrl(Constants.URL_VERSION_CHECK, andParameters: NSMutableDictionary(), andHeaders: nil , withSuccessHandler: success  , withFailureHandler: failure, withLoadingViewOn: nil)


    }

    
    static func fetchFoodItems(_ key:String , limit:Int , offset:Int,view:UIView, onResponse:@escaping (_ items:[Food]?,_ status:Bool) -> Void)->Void{
        
        let url = Constants.API_URL + key + Constants.API_SEPERATOR + limit.description +  Constants.API_SEPERATOR + offset.description + Constants.API_SEPERATOR
        
        
        Network.executeGETWithUrl( url, andParameters: NSMutableDictionary(), andHeaders: nil, withSuccessHandler: { (operation:AFHTTPRequestOperation?,response:AnyObject?, status:Bool) -> Void in
            var items = [Food]();
            if((response?.count)! > 0){
                
                if let itemsAvailable = response as? NSArray{
                    
                    items = createFoods(itemsAvailable);
                }
                onResponse(items,true)
                
            }else{
                onResponse(items,false)
            }
            
            }  , withFailureHandler: { (op:AFHTTPRequestOperation?, err:NSError?) -> Void in
                  onResponse(nil,false)
            }, withLoadingViewOn: nil);
    }
    
    
    
    
     //TO DO COMMENDTS
    /*
     Receives an NSArray from the json file, locally or remotely, and turns each node into an NSDictionary which is then read and turned into a food object for the database.
    */
    static func  createFoods(_ itemsAvailable: NSArray)->[Food]
    {
        var items = [Food]();
        for item in itemsAvailable {
            
            if let pdt = item as? NSDictionary{
                let  itemFood = createFood(pdt)
                items.append(itemFood);
            }
        }
        return items
        
    }
    
    
    /**
     This function takes a dictionary from the JSON, and creates a Food object from it.
     
     
     - parameter foods: A List of Foods in the database that don't have 'oftenEatenWith' or 'alwaysEatenWithOneOf' yet.
     - parameter json: NSArray of foods and their attributes including.
     
     
     */
     static func createFood(_ pdt: NSDictionary!)->Food{
        let itemFood = Food();
        
         //TO DO CHECK NULL STRING
        itemFood.name = (pdt!.value(forKey: "name") as! String?)!
        
        if let value : Int = (pdt!.value(forKey: "pk") as! Int?)!{
            itemFood.pk = value
        }
        
        if let value : Double = getDoubleValueForKey("carbohydrates", pdt: pdt!){
            itemFood.carbohydrates = value
        }
        
        if let value : Double = getDoubleValueForKey("calories", pdt: pdt!){
            itemFood.calories = value
        }
        
        
        if let value : String =  Util.checkNullString("servingSize", pdt: pdt) {
            itemFood.servingSize = ServingSize.get(value)
        }
        
        if let value : Double = getDoubleValueForKey("sugars", pdt: pdt!){
            itemFood.sugars =  RealmOptional<Double>(value);
        }
        
        if let value : Double = getDoubleValueForKey("proteins", pdt: pdt!){
            itemFood.proteins = value
        }
        
        
        if let value : Double = getDoubleValueForKey("fats", pdt: pdt!){
            itemFood.fats = value
        }
        
        
        if let value : Double = getDoubleValueForKey("sat_fats", pdt: pdt!){
            itemFood.sat_fats = RealmOptional<Double>(value)
        }
        
        
        if let value : Double = getDoubleValueForKey("salt", pdt: pdt!){
            itemFood.salt = value
        }
        
        
        if let value : Double = getDoubleValueForKey("fibre", pdt: pdt!){
            itemFood.fibre = RealmOptional<Double>(value)
        }
        
        if let value = (pdt!.value(forKey: Constants.dietSuitability) as! NSArray?){
            let realm = try! Realm()
            let ds = realm.objects(DietSuitability.self).filter("name IN %@", value)
            for each in ds {
                itemFood.dietSuitability.append(each)
            }
        }
        
        if let value = (pdt!.value(forKey: "foodType") as! NSArray?){
            let realm = try! Realm()
            let ft = realm.objects(FoodType.self).filter("name IN %@", value)
            for each in ft {
                itemFood.foodType.append(each)
            }
        }
        
        if (pdt!.value(forKey: "readyToEat") as! Bool?)! == true{
            itemFood.readyToEat = true
        } else if (pdt!.value(forKey: "readyToEat") as! Bool?)! == false {
            itemFood.readyToEat = false
        }
        
        if (pdt!.value(forKey: "producer") as! String) != "" {
            itemFood.producer = (pdt!.value(forKey: "producer") as! String?)!
        }
        
        if let maxAllowedValue : Double =  getDoubleValueForKey(Constants.max_number_of_servings, pdt: pdt!){
            itemFood.max_number_of_servings = RealmOptional<Double>(maxAllowedValue)
        }
        
        if let minAllowedValue : Double =  getDoubleValueForKey(Constants.min_number_of_servings, pdt: pdt!){
            itemFood.min_number_of_servings = RealmOptional<Double>(minAllowedValue)
        }
        
        
        return itemFood;
        
        /*

        "pk":1,"name":"Oomf! Protein Oats (banana flavour)","servingSize":"100g","calories":389,"carbohydrates":"56.60","sugars":"13.90","proteins":"27.70","fats":"4.40","sat_fats":"0.90","fibre":"6.20","salt":"0.40","dietSuitability":["Vegetarian"],"oftenEatenWith":[],"alwaysEatenWithOneOf":[],"foodType":["Breakfast only"]},
 
        */
    }
    
    
    static func fetchInitialFoods(_ view:UIView?, onResponse:@escaping (_ items:[Food]?, _ json:NSArray, _ status:Bool) -> Void)->Void{
        
        /**
         This method returns an array of of foods that have been created, called 'items'
         
         */
        
        let url = Constants.API_URL + Constants.API_KEY_ALL
        
        Network.executeGETWithUrl( url, andParameters: NSMutableDictionary(), andHeaders: nil, withSuccessHandler: { (operation:AFHTTPRequestOperation?,response:AnyObject?, status:Bool) -> Void in
            var foods = [Food]();
            var itemsAvailable : NSArray = NSArray()
            if((response?.count)! > 0){
                
                
                if let jsonDataAsArray = response as? NSArray{
                    
                    foods = createFoods(jsonDataAsArray);
                    itemsAvailable = jsonDataAsArray
                    
                }
                onResponse(foods, itemsAvailable, true)
                
            }else{
                onResponse(foods, [], false)
                
            }
        
        }, withFailureHandler: { (op:AFHTTPRequestOperation?, err:NSError?) -> Void in
                
                var items = [Food]();
                items = importDataFromJSON().foodArray as! [Food]
                let itemsAvail : NSArray = importDataFromJSON().JSON
                onResponse(items, itemsAvail, true)
                
            } , withLoadingViewOn: view);
        
        
    }
    /*
     * 06/06/2016
     * function : For fetch data from josn file and write to local storage
     * parmeters: nil
     * return   : [Food] array
     */
    static func importDataFromJSON() -> (foodArray:NSArray, JSON:NSArray)  {
        var items = [Food]();
        guard let path = Bundle.main.path(forResource: "initialLoad4", ofType: "json") else {
            print("Error retriving any local objects")
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
            return (NSArray(), NSArray())
        }
        print("We got the path to the json file.")
        do {
            let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
            print("Converted it to json data.")
            do {
                let jsonResult: AnyObject! = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                    if let rawJSON = jsonResult as? NSArray{
                    items = createFoods(rawJSON);
                    print("Serialised it into NSArrays")
                   return (items as NSArray, rawJSON)
                }
               
            } catch {print("Error 1")}
        } catch {print("Error 2")}
        return (items as NSArray, NSArray())
    }
}
