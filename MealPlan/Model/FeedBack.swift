import Foundation
import RealmSwift

class FeedBack: Object {
    
    dynamic var notes: String? = nil
    dynamic var tasty: String? = nil
    dynamic var hungerLevels = ""
    dynamic var bloating = Bool()
    dynamic var didItHelped = Bool()
    dynamic var weightMeasurement = 0.0
    dynamic var weightUnit = ""
    var easeOfFollowingDiet : String = Constants.dietEase.unstated.rawValue

}
