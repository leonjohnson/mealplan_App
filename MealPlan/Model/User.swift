import Foundation
import RealmSwift

class User: Object {
    
    dynamic var name = ""
    dynamic var first_name = ""
    dynamic var last_name = ""
    dynamic var email = ""
    dynamic var birthdate = Date(timeIntervalSince1970: 1)
    dynamic var gender = ""
    
}
