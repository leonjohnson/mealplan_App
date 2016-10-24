import UIKit
import RealmSwift

extension DataStructure {
    // new functionality to add to SomeType goes here
    
    
    static func getMeal()->[Meal]{
        return DataHandler.readMealData();
    }
    
    
    static func calculateTotalCalories( items :[Meal])->Double{
        var count = 0.0;
        for food in items{
            count +=  getcalory(food.foodItems)
        }
        return count;
    }
    static func getcalory(items :List<FoodItem>)->Double{
        var count = 0.0;
        for food in items{
            count +=  food.food!.calories * food.numberServing
        }
        return count;
    }
    
    static func loadDatabaseWithData(){
        
        if (Config.getBoolValue("isCreated")){
            return
        }
        
        DietSuitability.addRowData();
        FoodType.addFoodTypes()
        
        
        Connect.fetchInitialFoods(nil) { (foods, json, status) -> Void in
            
            if(status == false){
                
                // @todo show an alert that we need a alert here
                print("STATUS : \(status)")
                return;
            }
            
            //Load nutritional information for these foods.
            print("foods count : \(foods.count)")
            for  food in foods{
                DataHandler.createFood(food);
            }
            
            //Add the food pairings
            addFoodPairingsToDatabase(foods,json: json)
            
            //createMeal();
            Config.setBoolValue("isCreated", status: true);
            print("Got it created!")
            
        }
        
        
    }
    //TO DO COMMENDTS
    
    
    
    /**
     This function takes an array of foods and their attributes and inputs any foods labelled as 'oftenEatenWith'
     or 'alwaysEatenWithOneOf' into the database.
     
     
     - parameter foods: A List of Foods in the database that don't have 'oftenEatenWith' or 'alwaysEatenWithOneOf' yet.
     - parameter json: NSArray of foods and their attributes including.
     
     
     */
    static func addFoodPairingsToDatabase (foods:[Food], json:NSArray)
    {
        
        print("foods count: \(foods.count) json count: \(json.count)")
        let realm = try! Realm()
        for (index, food) in foods.enumerate() {
            
            let foodInJsonArray : NSDictionary = (json.objectAtIndex(index) as? NSDictionary)!
            let oftenEatenWith : NSArray = foodInJsonArray.objectForKey("oftenEatenWith") as! NSArray
            let alwaysEatenWithOneOf : NSArray = foodInJsonArray.objectForKey("alwaysEatenWithOneOf") as! NSArray
            
            let foodToEdit = realm.objects(Food).filter("name == %@", food.name)
            
            let realm = try! Realm()
            try! realm.write {
                
                if oftenEatenWith.count > 0 {
                    //for each in
                    let foodPredicate = NSPredicate(format: "name IN %@", oftenEatenWith)
                    let oew = realm.objects(Food).filter(foodPredicate)
                    foodToEdit.first!.setValue(List(oew), forKey: "oftenEatenWith")
                }
                
                if alwaysEatenWithOneOf.count > 0 {
                    let foodPredicate2 = NSPredicate(format: "name IN %@", alwaysEatenWithOneOf)
                    let aew = realm.objects(Food).filter(foodPredicate2)
                    foodToEdit.first!.setValue(List(aew), forKey: "alwaysEatenWithOneOf")
                }
                
            }
        }
        
    }

    
}