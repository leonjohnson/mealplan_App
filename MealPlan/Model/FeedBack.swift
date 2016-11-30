import Foundation
import RealmSwift

class FeedBack: Object {
    
    dynamic var notes: String? = nil
    dynamic var tasty: String? = nil
    dynamic var hungerLevels = ""
    dynamic var bloating = Bool()
    dynamic var didItHelped = Bool()
    dynamic var weekWeightMeasurement = 0.0
    dynamic var WeekWeightUnit = ""
    var easeOfFollowingDiet : Constants.dietEase = .unstated

}
