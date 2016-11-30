import UIKit
import RealmSwift

extension MealPlanAlgorithm {
    // new functionality to add to SomeType goes here
    
    
    static func getMeal()->[Meal]{
        return DataHandler.readMealData();
    }
    
    
    static func calculateTotalCalories( _ items :[Meal])->Double{
        var count = 0.0;
        for food in items{
            count +=  getcalory(food.foodItems)
        }
        return count;
    }
    static func getcalory(_ items :List<FoodItem>)->Double{
        var count = 0.0;
        for food in items{
            count +=  food.food!.calories * food.numberServing
        }
        return count;
    }
    
}
