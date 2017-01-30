import UIKit

class LikeOrDislike: UIViewController {
    
    enum outcome {
        case like
        case dislike
        case unstated
    }
    
    @IBOutlet var foodLabel : UILabel!
    @IBOutlet var likeButton : UIView!
    @IBOutlet var dislikeButton : UIView!
    var data : [Food] = DataHandler.foodsThatRequireRating()
    var index = 0
    var foodsLiked : [Food] = []
    var foodsDisliked : [Food] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextFood()
        
        let tap = UITapGestureRecognizer(target: self, action:  #selector(LikeOrDislike.likeThisFood))
        likeButton.addGestureRecognizer(tap)
        likeButton.layer.cornerRadius = dislikeButton.frame.width/2
        likeButton.clipsToBounds = true
        
        let tap2 = UITapGestureRecognizer(target: self, action:  #selector(LikeOrDislike.dislikeThisFood))
        dislikeButton.addGestureRecognizer(tap2)
        dislikeButton.layer.cornerRadius = dislikeButton.frame.width/2
        dislikeButton.clipsToBounds = true
    }
    
    
    @IBAction func likeThisFood() {
        foodsLiked.append(data[index])
        index = index + 1
        showNextFood()
    }
    
    @IBAction func dislikeThisFood() {
        foodsDisliked.append(data[index])
        index = index + 1
        showNextFood()
    }
    
    
    func showNextFood(){
        if index > data.count - 1 {
            hadEnough()
        } else {
            let name = data[index].name
            if let first_word = name.components(separatedBy: " ").first {
                foodLabel.text = first_word + "?"
            } else {
                foodLabel.text = data[index].name + "?"
            }
        }
    }
    

    
    func hadEnough(){
        DataHandler.updateLikeFoods(foodsLiked)
        DataHandler.updateDisLikeFoods(foodsDisliked)
        print("had enough called")
        self.dismiss(animated: true, completion: nil)
    }

}
