import Foundation
import RealmSwift

class Biographical: Object {
    
    
    dynamic var numberOfDailyMeals: Int = 0
    dynamic var howLong: Int = 0
    
    dynamic var muscularity: String? = nil
    dynamic var dietaryRequirement: String? = nil
    dynamic var activityLevelAtWork: String? = nil
    
    var looseFat = RealmOptional<Bool>()
    var gainMuscle = RealmOptional<Bool>()
    var addMoreDefinition = RealmOptional<Bool>()
    
    dynamic var numberOfResistanceSessionsEachWeek = 0
    dynamic var numberOfCardioSessionsEachWeek = 0
    
    dynamic var heightMeasurement = 0.0
    dynamic var heightUnit = ""
    
    dynamic var weightMeasurement = 0.0
    dynamic var weightUnit = ""
    
    dynamic var waistMeasurement = 0.0
    dynamic var waistUnit = ""
    
}
