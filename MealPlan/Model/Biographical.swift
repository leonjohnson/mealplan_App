import Foundation
import RealmSwift

class Biographical: Object {
    
    dynamic var date = Date()
    dynamic var numberOfDailyMeals: Int = 0
    dynamic var mealplanDuration: Int = 0
    dynamic var activityLevelAtWork: String? = nil
    
    let dietaryRequirement = List<DietSuitability>()
    var loseFat = RealmOptional<Bool>()
    var gainMuscle = RealmOptional<Bool>()
    
    dynamic var numberOfResistanceSessionsEachWeek = 0
    dynamic var numberOfCardioSessionsEachWeek = 0
    dynamic var hoursOfActivity : Double = 0
    
    dynamic var heightUnit = ""
    dynamic var weightUnit = ""
    dynamic var weightMeasurement = 0.0
    dynamic var heightMeasurement = 0.0
}
