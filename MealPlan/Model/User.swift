import Foundation
import RealmSwift

class User: Object {
    
    dynamic var name = ""
    dynamic var email = ""
    dynamic var birthdate = NSDate(timeIntervalSince1970: 1)
    dynamic var gender = ""
    
}
