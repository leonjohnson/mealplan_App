import Foundation
import RealmSwift

class FoodItem: Object
{
    dynamic var food:Food?
    dynamic var numberServing:Double = 1
    dynamic var eaten = false
    let dateTimeAdded: Date = Date()
    
    func getTotalCal()->Double{
       return  (food!.calories * numberServing)
    }
}
