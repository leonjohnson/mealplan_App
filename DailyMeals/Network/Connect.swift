import UIKit
import RealmSwift
import AFNetworking
class Connect: NSObject {
    
    //Method for Converting all Values to Double Format.
    static func getDoubleValueForKey(key:String, pdt:NSDictionary)-> Double{
        
        if let value :NSString = (pdt.valueForKey(key) as? NSString){
            if let answer:Double = value.doubleValue{
                return answer;
            }
            if let answer:Int = value.integerValue{
                return Double(answer);
            }
        }
        if let value :Double = (pdt.valueForKey(key) as? Double){
            return value
        }
        if let value :Int = (pdt.valueForKey(key) as? Int){
            return Double(value)
        }
        
        return 0.0
    }
    
    
    static func fetchFoodItems(key:String , limit:Int , offset:Int,view:UIView, onResponse:(items:[Food]!,status:Bool) -> Void)->Void{
        
        let url = Constants.API_URL + key + Constants.API_SEPERATOR + limit.description +  Constants.API_SEPERATOR + offset.description
        
        
        Network.executeGETWithUrl( url, andParameters: NSMutableDictionary(), andHeaders: nil, withSuccessHandler: { (operation:AFHTTPRequestOperation!,response:AnyObject!, status:Bool) -> Void in
            var items = [Food]();
            if(response.count > 0){
                
                if let itemsAvailable = response as? NSArray{
                    
                    items = createFoods(itemsAvailable);
                }
                onResponse(items: items,status: true)
                
            }else{
                onResponse(items: items,status: false)
            }
            
            }, withFailureHandler: { (op:AFHTTPRequestOperation!, err:NSError!) -> Void in
                  onResponse(items: nil,status: false)
            }, withLoadingViewOn: view);
    }
    
    
    
    
     //TO DO COMMENDTS
    /*
     Receives an NSArray from the json file, locally or remotely, and turns each node into an NSDictionary which is then read and turned into a food object for the database.
    */
    static func  createFoods(itemsAvailable: NSArray)->[Food]
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
    
    
     //TO DO COMMENDTS
     static func createFood(pdt: NSDictionary!)->Food{
        let itemFood = Food();
        
         //TO DO CHECK NULL STRING
        itemFood.name = (pdt!.valueForKey("name") as! String?)!
        
        if let value : Int = (pdt!.valueForKey("pk") as! Int?)!{
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
        
        if let value = (pdt!.valueForKey("dietSuitablity") as! NSArray?){
            let realm = try! Realm()
            let ds = realm.objects(DietSuitability).filter("name IN %@", value)
            for each in ds {
                itemFood.dietSuitablity.append(each)
            }
        }
        
        if let value = (pdt!.valueForKey("foodType") as! NSArray?){
            let realm = try! Realm()
            let ft = realm.objects(FoodType).filter("name IN %@", value)
            for each in ft {
                itemFood.foodType.append(each)
            }
        }
        
        
        
        return itemFood;
        
        /*

        "pk":1,"name":"Oomf! Protein Oats (banana flavour)","servingSize":"100g","calories":389,"carbohydrates":"56.60","sugars":"13.90","proteins":"27.70","fats":"4.40","sat_fats":"0.90","fibre":"6.20","salt":"0.40","dietSuitablity":["Vegetarian"],"oftenEatenWith":[],"alwaysEatenWithOneOf":[],"foodType":["Breakfast only"]},
 
        */
    }
    
    
    static func fetchInitialFoods(view:UIView?, onResponse:(items:[Food]!, json:NSArray, status:Bool) -> Void)->Void{
        
        /**
         This method returns an array of of foods that have been created, called 'items'
         
         */
        
        let url = Constants.API_URL + Constants.API_KEY_ALL
        
        Network.executeGETWithUrl( url, andParameters: NSMutableDictionary(), andHeaders: nil, withSuccessHandler: { (operation:AFHTTPRequestOperation!,response:AnyObject!, status:Bool) -> Void in
            var foods = [Food]();
            var itemsAvailable : NSArray = NSArray()
            if(response.count > 0){
                
                
                if let jsonDataAsArray = response as? NSArray{
                    
                    foods = createFoods(jsonDataAsArray);
                    itemsAvailable = jsonDataAsArray
                    
                }
                onResponse(items: foods, json: itemsAvailable, status: true)
                
            }else{
                onResponse(items: foods, json: [], status: false)
                
            }
        
            }, withFailureHandler: { (op:AFHTTPRequestOperation!, err:NSError!) -> Void in
                
                var items = [Food]();
                items = importDataFromJSON() as! [Food]
                let itemsAvail : NSArray = NSArray()
                onResponse(items: items, json: itemsAvail, status: true)
                
            }, withLoadingViewOn: view);
        
        
    }
    /*
     * 06/06/2016
     * function : For fetch data from josn file and write to local storage
     * parmeters: nil
     * return   : [Food] array
     */
    static func importDataFromJSON() -> NSArray  {
         var items = [Food]();
        if let path = NSBundle.mainBundle().pathForResource("initalLoad3", ofType: "json") {
            do {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                do {
                    let jsonResult: AnyObject! = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) 
                        if let itemsAvailable = jsonResult as? NSArray{
                        items = createFoods(itemsAvailable);
                       return items
                    }
                   
                } catch {}
            } catch {}
        }
        return items
    }
}
