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
        foodLabel.text = data.first?.name
        let tap = UITapGestureRecognizer(target: self, action:  #selector(LikeOrDislike.likeThisFood))
        likeButton.addGestureRecognizer(tap)
        
        let tap2 = UITapGestureRecognizer(target: self, action:  #selector(LikeOrDislike.dislikeThisFood))
        dislikeButton.addGestureRecognizer(tap2)
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
            foodLabel.text = data[index].name
        }
    }
    

    
    func hadEnough(){
        DataHandler.updateLikeFoods(foodsLiked)
        DataHandler.updateDisLikeFoods(foodsDisliked)
        self.dismiss(animated: true, completion: nil)
    }

}
