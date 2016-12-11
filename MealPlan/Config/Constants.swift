import UIKit

struct Constants {
    
    static let BOT_NAME = "BOT"
    static let LOCALISATION_NEEDED = "LOCALISATION_NEEDED"
    
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
    static let BOOL_YES  = "Yes"
    static let BOOL_NO  = "No"
    static let LIKE_STRING  = "LIKE"
    static let DISLIKE_STRING  = "DISLIKE"
    static let THE_FOODS_STRING  = "TAP THE FOODS YOU "
    static let WEEK_STRING  =  "How many weeks would you like to do this for? "
    static let WEEK_RESULT_STRING  =   "*We recommend 8-20 for best results "
    static let NONE_OF_THE_ABOVE = "None of the above"
    
    //Fonts
    static let STANDARD_FONT = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
    static let SMALL_FONT = UIFont.systemFont(ofSize: 11, weight: UIFontWeightRegular)
    static let GENERAL_LABEL = UIFont.systemFont(ofSize: 14, weight: UIFontWeightBold)
    static let MEAL_PLAN_TITLE = UIFont.systemFont(ofSize: 16, weight: UIFontWeightBold)
    static let MEAL_PLAN_SUBTITLE = UIFont.systemFont(ofSize: 13, weight: UIFontWeightBold)
    static let MEAL_PLAN_DATE = UIFont.systemFont(ofSize: 13, weight: UIFontWeightLight)
    
    static let FOOD_LABEL_FONT = UIFont(name: "Helvetica",size: 17.0)!
    static let FOOD_LABEL_FONT_BOLD = UIFont(name: "Helvetica-Bold",size: 17.0)!
    static let DEFAULT_LABEL_FONT_BOLD = UIFont(name: "Helvetica-Bold",size: 15.0)!
    static let WEEKS_LABEL_FONT = UIFont(name: "Helvetica",size: 16.0)!
    static let BLACK_COLOR = UIColor.black
    static let WEEKS_LABEL_FONT_BOLD = UIFont(name: "Helvetica-Bold",size: 10.0)!
    
    static let INTRO_TEXT_LABEL = UIFont(name: "HelveticaNeue-Light", size: 14.0)!
    
    static let MEAL_PLAN_FOODITEM_LABEL = UIFont.systemFont(ofSize: 13, weight: UIFontWeightRegular)
    static let MEAL_PLAN_SERVINGSIZE_LABEL = UIFont.systemFont(ofSize: 9, weight: UIFontWeightRegular)
    static let DETAIL_PAGE_FOOD_NAME_LABEL = UIFont.systemFont(ofSize: 17, weight: UIFontWeightBold)
    
    //TableView constants
    static let TABLE_ROW_HEIGHT = CGFloat(55)
    static let TABLE_ROW_HEIGHT_SMALL = CGFloat(40)
    static let TABLE_ROW_HEIGHT_TINY = CGFloat(34) // Only for Nutritional information page
    static let TABLE_INSETS = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: 0)
    static let MACRO_LABEL = UIFont(name: "HelveticaNeue", size: 12)!
    static let DELETE = "Delete"
    static let EDIT = "Edit"
    
    //Colours:
    static let FOOD_LABEL_COLOR =  UIColor (red: 0/225, green: 141/225, blue: 198/225, alpha: 1)
    static let MP_PURPLE = UIColor(red: 0.447, green: 0.176, blue: 0.792, alpha: 0.83)
    static let MP_BLUE = UIColor(red: 0.176, green: 0.376, blue: 0.796, alpha: 0.88)
    static let MP_GREEN = UIColor(red: 0.494, green: 0.827, blue: 0.129, alpha: 1.000)
    static let MP_BEIGE = UIColor(red: 0.776, green: 0.796, blue: 0.176, alpha: 0.05)
    static let MP_WHITE = UIColor.white
    static let MP_GREY = UIColor.lightGray
    static let MP_BLACK = UIColor.black
    
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
    static let KILOGRAMS = "kg"
    static let POUNDS = "lbs"

    //Macronutriet names
    static let CARBOHYDRATES = "Carbohydrates"
    static let PROTEINS = "Proteins"
    static let FATS = "Fats"
    static let CALORIES = "kCals"
    static let NUMBER_OF_NUTRIENTS_TO_DISPLAY = 8
    static let MACRONUTRIENTS = [Constants.PROTEINS, Constants.CARBOHYDRATES, Constants.FATS, Constants.vegetableFoodType]
    
    
    //NSPredicate constants
    static let onlyBreakfastFoodType = "Breakfast only"
    static let eatenAtBreakfastFoodType = "Eaten At Breakfast"
    static let vegetableFoodType = "Vegetable"
    static let fruitFoodType = "Fruit"
    static let drinkFoodType = "Drink"
    static let condimentFoodType = "Condiment"
    static let meatFoodType = "Meat"
    static let glutenFree = "Gluten free"
    static let Vegan = "Vegan"
    static let vegetarian = "Vegetarian"
    static let pescatarian = "Pescatarian"
    static let lactoseFree = "Lactose free"
    static let fish = "Fish"
    static let fizzy = "Fizzy"
    static let dietTypes = [Constants.vegetarian, Constants.Vegan, /*Constants.pescatarian, Constants.lactoseFree,*/ Constants.glutenFree, Constants.NONE_OF_THE_ABOVE]

    
    
    //NSPredicates
    static let isFat = NSPredicate(format: "fats > 30 AND carbohydrates < 5")
    let vegetablePredicate = NSPredicate(format: "ANY SELF.foodType.name == [c] %@", Constants.vegetableFoodType)
    
    //ServingSizes
    static let pot = "pot"
    static let cup = "cup"
    static let ml = "100ml"
    static let grams = "100g"
    static let slice = "slice"
    static let item = "item"
    static let tablet = "tablet"
    static let heaped_teaspoon = "heaped teaspoon"
    static let pinch = "pinch"
    static var SERVING_SIZE_ORDER = ["item", "pot", "slice", "cup", "tablet", "heaped teaspoon", "pinch", "100ml", "100g"] //portion up everything before 100ml and 100g. Ml comes before g because liquids like drinks are more likely to have rules around them.
    
    
    //Food attributes
    static let dietSuitability = "dietSuitability"
    
    //FoodTypes
    static var FOOD_TYPES = [Constants.drinkFoodType, Constants.fizzy, Constants.fruitFoodType, Constants.vegetableFoodType, Constants.eatenAtBreakfastFoodType, Constants.onlyBreakfastFoodType, Constants.fish, Constants.condimentFoodType]
    
    
    //Calender
    struct Calendar {
        static let usersCalendar = Foundation.Calendar.current
    }
    static var START_OF_WEEK: Date {
        let tommorrow = Date(timeInterval: 60 * 60 * 24, since: Date())
        return Calendar.usersCalendar.date(from: (Calendar.usersCalendar as NSCalendar).components([.yearForWeekOfYear, .weekOfYear ], from: tommorrow))!
    }
    
    static var DAYS_SINCE_START_OF_THIS_WEEK: Int {
        let calendar: Foundation.Calendar = Foundation.Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let startOfTheWeek = START_OF_WEEK
        let tommorrow = Date(timeInterval: 60 * 60 * 24, since: Date())
        
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: startOfTheWeek, to: tommorrow, options: [])
        
        return components.day!
    }
    
    static func roundToPlaces(_ value: Double, decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
    //Activity levels
    static let activityLevelsAtWork = ["Sedentary", "Lightly active", "Moderately active", "Very active"] // This array is used for display purposes
    
    //MINIMUM NUMBER OF GRAMS TO IGNORE IF DEFICIT
    static let maximumNumberOfGramsToIgnore = 2.0
    
    static let vegetablesAsPercentageOfCarbs = 0.15
    
    //BOT QUESTIONS
    
        
    
    
    /*
    static let BOT_QUESTION_NAME = "Hi! What is the full name of the food?" //name
    static let BOT_QUESTION_PRODUCER = "Who makes this product?" // manufacter, don't know, blank, some other unuseful answer
    static let BOT_QUESTION_SERVING_TYPE = "For the nutritional information you're going to enter is it per:\n1.100g \n2.100ml\n3.Slice\n4.Item (such as per banana or per apple)? \nPlease enter the relevant number" //1,2,3 or 4
    static let BOT_QUESTION_CALORIES = "Thanks. How many calories are in it?"
    static let BOT_QUESTION_FAT = "grams of fat?" //per 100g or 100ml
    static let BOT_QUESTION_SATURATED_FAT = "grams of saturated fat?"
    static let BOT_QUESTION_CARBOHYDRATES = "and carbohydrates?"
    static let BOT_QUESTION_SUGAR = "of which are sugar? (type n/a if it's not labelled)"
    static let BOT_QUESTION_FIBRE = "and fibre? (type n/a if it's not labelled)"
    static let BOT_QUESTION_PROTEIN = "how much protein does this item have?"
    static let BOT_QUESTION_FOOD_TYPE = "Please help me categorise this item. \n\nWhich of the following numbers apply to this item? \n\n1.It's a drink 2. It's a fizzy drink\n3.It's a fruit \n4.It's a vegetable \n5.I would eat this at breakfast \n6.I would only eat this at breakfast \n7.This is a type of fish \n8.This is a condiment \n9.None of the above "
    static let BOT_QUESTION_DONE = "Thanks! You're all done now."
    */
    static let questionsThatRequireTableViews = [BotData.NEW_FOOD.serving_type.question, BotData.NEW_FOOD.food_type.question]
    
    struct CellIdentifiers {
        static let Blue = "BlueCellIdentifier"
        static let Large = "LargeCellIdentifier"
        
        struct hair {
            static let Espa = "BlueCellIdentifier"
            static let Desta = "LargeCellIdentifier"
        }
    }
    
    enum appendDeleteEnum {
        case append
        case delete
    }
    
    enum botValidationEntryType {
        case text
        case decimal
        case none
    }
    
    enum dietEase: String {
        case unstated = "unstated"
        case easy = "easy"
        case ok = "ok"
        case hard = "hard"
    }
    
    enum hungerLevels: String {
        case unstated = "unstated"
        case veryHungry = "very hungry"
        case littleHungry = "a little hungry"
        case aboutRight = "about right"
        case full = "full"
    }
    
    static let HAS_PROFILE = "hasProfile"
    static let FIRST_CALORIE_CUT = "firstCalorieCut"
    static let STANDARD_CALORIE_CUT = "standardCalorieCut"
    static let standard_calorie_increase_for_muscle = 1.075
    static let standard_calorie_reduction_for_weightloss = 0.96
    static let small_calorie_reduction_for_weightloss = 0.98
    
    /// STORY BOARDS
    static let MAIN_STORYBOARD = UIStoryboard(name: "Main", bundle: nil)
    static let FEEDBACK_STORYBOARD = UIStoryboard(name: "Feedback", bundle: nil)
    static let BOT_STORYBOARD = UIStoryboard(name: "Bot", bundle: nil)
    
    }
