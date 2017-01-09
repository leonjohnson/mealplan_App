import Foundation
import RealmSwift

class Biographical: Object {
    
    dynamic var numberOfDailyMeals: Int = 0
    dynamic var howLong: Int = 0
    dynamic var activityLevelAtWork: String? = nil
    
    let dietaryRequirement = List<DietSuitability>()
    
    var looseFat = RealmOptional<Bool>()
    var gainMuscle = RealmOptional<Bool>()
    
    dynamic var numberOfResistanceSessionsEachWeek = 0
    dynamic var numberOfCardioSessionsEachWeek = 0
    
    dynamic var heightMeasurement = 0.0
    dynamic var heightUnit = ""
    
    dynamic var weightMeasurement = 0.0
    dynamic var weightUnit = ""
    
    dynamic var waistMeasurement = 0.0
    dynamic var waistUnit = ""
    
}
