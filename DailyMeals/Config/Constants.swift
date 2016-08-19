import UIKit

struct Constants {
    
    static let API_URL  = BASE_URL + API_SEPERATOR + API_KEY + API_SEPERATOR
    static let BASE_URL = "http://mp0.herokuapp.com"
    static let API_SEARCH_LIMIT = 20
    static let API_SEARCH_OFSET = 0
    static let API_SEPERATOR = "/"
    static let API_KEY  = "api"
    static let KEY_EMPTY = ""
    static let REQ_API_KEY = "API_KEY"
    static let ERROR_NETWORK = "Network error Foud please try later"
    static let API_KEY_ALL  = "all"
    static let BOOL_YES  = "yes"
    static let BOOL_NO  = "no"
    static let LIKE_STRING  = "LIKE"
    static let DISLIKE_STRING  = "DISLIKE"
    static let THE_FOODS_STRING  = "TAP THE FOODS YOU "
    static let WEEK_STRING  =  "How many weeks would you like to do this for? "
    static let WEEK_RESULT_STRING  =   "*We recommend 8-20 for best results "
    
    //Fonts
    static let STANDARD_FONT = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
    static let GENERAL_LABEL = UIFont.systemFontOfSize(14, weight: UIFontWeightBold)
    static let MEAL_PLAN_TITLE = UIFont.systemFontOfSize(16, weight: UIFontWeightBold)
    static let MEAL_PLAN_SUBTITLE = UIFont.systemFontOfSize(13, weight: UIFontWeightBold)
    
    static let FOOD_LABEL_FONT = UIFont(name: "Helvetica",size: 17.0)!
    static let FOOD_LABEL_FONT_BOLD = UIFont(name: "Helvetica-Bold",size: 17.0)!
    static let DEFAULT_LABEL_FONT_BOLD = UIFont(name: "Helvetica-Bold",size: 15.0)!
    static let WEEKS_LABEL_FONT = UIFont(name: "Helvetica",size: 16.0)!
    static let BLACK_COLOR = UIColor.blackColor()
    static let WEEKS_LABEL_FONT_BOLD = UIFont(name: "Helvetica-Bold",size: 10.0)!
    
    static let INTRO_TEXT_LABEL = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
    
    static let MEAL_PLAN_FOODITEM_LABEL = UIFont.systemFontOfSize(13, weight: UIFontWeightRegular)
    static let MEAL_PLAN_SERVINGSIZE_LABEL = UIFont.systemFontOfSize(9, weight: UIFontWeightRegular)
    static let DETAIL_PAGE_FOOD_NAME_LABEL = UIFont.systemFontOfSize(17, weight: UIFontWeightBold)
    
    
    
    static let MACRO_LABEL = UIFont(name: "HelveticaNeue", size: 12)!
    
    //Colours:
    static let FOOD_LABEL_COLOR =  UIColor (red: 0/225, green: 141/225, blue: 198/225, alpha: 1)
    static let MP_PURPLE = UIColor(red: 0.447, green: 0.176, blue: 0.792, alpha: 0.83)
    static let MP_BLUE = UIColor(red: 0.176, green: 0.376, blue: 0.796, alpha: 0.88)
    static let MP_GREEN = UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1.000)
    static let MP_BEIGE = UIColor(red: 0.776, green: 0.796, blue: 0.176, alpha: 0.05)
    static let MP_WHITE = UIColor.whiteColor()
    static let MP_GREY = UIColor.lightGrayColor()
    static let MP_BLACK = UIColor.blackColor()
    
    //REE formula constants
    static let femaleConstant = 655.0
    static let femaaleHeightCoefficient = 1.85
    static let femaleWeightCoefficient = 9.56
    static let femaleAgeCoefficient = -4.68
    
    static let maleConstant = 66.5
    static let maleHeightCoefficient = 5.0
    static let maleWeightCoefficient = 13.75
    static let maleAgeCoefficient = -6.78
    
    //Gender constants
    static let male = "male"
    static let female = "female"
    
    //Conversion constants
    static let POUND_TO_KG_CONSTANT = 0.453592
    static let KG_TO_POUND_CONSTANT = 2.20462
    static let INCH_CONSTANT = 0.393701
    static let FEET_TO_CM_CONSTANT = 30.48
    static let INCH_TO_CM_CONSTANT = 2.54
    static let MAX_KWEIGHT = 200
    static let MAX_HEIGHT  = 300

    //Macronutriet names
    static let CARBOHYDRATES = "Carbohydrates"
    static let PROTEINS = "Proteins"
    static let FATS = "Fats"
    static let CALORIES = "kCals"
    static let NUMBER_OF_NUTRIENTS_TO_DISPLAY = 8
    
    
    //NSPredicate constants
    static let onlyBreakfastFoodType = "Breakfast only"
    static let eatenAtBreakfastFoodType = "Eaten At Breakfast"
    static let vegetableFoodType = "Vegetable"
    
    
    //NSPredicates
    static let isFat = NSPredicate(format: "fats > 30 AND carbohydrates < 2")
    let vegetablePredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.vegetableFoodType)
    
    //ServingSizes
    static let pot = "pot"
    static let cup = "cup"
    static let ml = "ml"
    static let grams = "g"
    static let slice = "slice"
    static let item = "item"
    static var SERVING_SIZE_ORDER = ["item", "pot", "slice", "100g", "100ml", "cup"]
    
    //Calender
    struct Calendar {
        static let usersCalendar = NSCalendar(calendarIdentifier: NSLocale.currentLocale().localeIdentifier)!
    }
    static var START_OF_WEEK: NSDate {
        let tommorrow = NSDate(timeInterval: 60 * 60 * 24, sinceDate: NSDate())
        return Calendar.usersCalendar.dateFromComponents(Calendar.usersCalendar.components([.YearForWeekOfYear, .WeekOfYear ], fromDate: tommorrow))!
    }
    
    static var DAYS_SINCE_START_OF_THIS_WEEK: Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        // Replace the hour (time) of both dates with 00:00
        let startOfTheWeek = START_OF_WEEK
        let tommorrow = NSDate(timeInterval: 60 * 60 * 24, sinceDate: NSDate())
        
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: startOfTheWeek, toDate: tommorrow, options: [])
        
        return components.day
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
