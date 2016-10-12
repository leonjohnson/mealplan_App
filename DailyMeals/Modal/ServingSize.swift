
import Foundation
import RealmSwift

class ServingSize: Object {
    
    dynamic var name = ""
    //dynamic var quantity = 100.0
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    static func get(name:String)->ServingSize{
        
        let realm = try! Realm()
        let obj = realm.objects(ServingSize).filter("name = '" + name + "' ").first
        if((obj) != nil){
            return obj!
        }else{
            let obj  = ServingSize()
            obj.name = name;
            try! realm.write {
                realm.add(obj)
            }
            return  obj;
        }
    }
    //func minMax(array: [Int]) -> (min: Int, max: Int) {
    static func getQuantity(serving:ServingSize) -> Double {
        if serving.name == "grams" || serving.name == "ml" {
            
            return 100
        } else{
            return 1
        }
        
    }
}
