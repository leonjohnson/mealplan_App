import UIKit
import JSQMessagesViewController

class outCells: JSQMessagesCollectionViewCellOutgoing, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var timeLabel : UILabel!
    @IBOutlet var table : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        table.register(UINib(nibName: "miniTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        self.table.dataSource = self
        self.table.delegate = self
        self.messageBubbleTopLabel.textAlignment = .center
        //self.cellBottomLabel.textAlignment = .right
        self.timeLabel.backgroundColor = UIColor.brown
        self.timeLabel.textColor = UIColor.black
        
        table.backgroundColor = UIColor.yellow
        //table.isHidden = true
        
        self.messageBubbleContainerView.frame = CGRect(x: self.messageBubbleContainerView.frame.origin.x, y: self.messageBubbleContainerView.frame.origin.y, width: self.messageBubbleContainerView.frame.width, height: 300)
        
        print("yooo")
        
        
        
        
        
        }
    
    override class func nib() -> UINib {
        return UINib(nibName: "outCell", bundle: nil)
    }
    
    override class func mediaCellReuseIdentifier() -> String {
        return "CustomMessagesCollectionViewCellIncoming"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.messageBubbleContainerView.frame = CGRect(x: self.messageBubbleContainerView.frame.origin.x, y: self.messageBubbleContainerView.frame.origin.y, width: self.messageBubbleContainerView.frame.width, height: 300)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "test"
        print("returning cell")
        return cell
    }
    
    
    }
    
    
    


