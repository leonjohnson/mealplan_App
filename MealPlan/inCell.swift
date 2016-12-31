import UIKit
import JSQMessagesViewController

class inCell: JSQMessagesCollectionViewCellIncoming, UITableViewDelegate, UITableViewDataSource, IncomingCellDelegate {
    
    @IBOutlet var questionTextView : JSQMessagesCellTextView?
    @IBOutlet var table : UITableView!
    var question : String = String()
    var data : (question:String, options:[String]) = ("",[])
    var beenTappedBefore:Bool = false
    
    var botDelegate: BotDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        table.register(UINib(nibName: "miniTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.table.dataSource = self
        self.table.delegate = self
        self.table.allowsSelection = true
        self.table.isUserInteractionEnabled = true
        self.table.allowsMultipleSelection = false
        self.questionTextView?.attributedText = NSAttributedString(string: "", attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_WHITE])
        self.messageBubbleTopLabel.textAlignment = .center
        self.tapGestureRecognizer.cancelsTouchesInView = false
        self.cellBottomLabel.textAlignment = .right
        
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("/n PREPARING INCELL FOR REUSE!")
        
        /*
            self.messageBubbleContainerView.frame = CGRect(x: self.messageBubbleContainerView.frame.origin.x,
                                                       y: self.messageBubbleContainerView.frame.origin.y,
                                                       width: self.messageBubbleContainerView.frame.width,
                                                       height: CGFloat((data.options.count * Int(Constants.TABLE_ROW_HEIGHT_SMALL))))
        */
        //var rowsSelected : [Int] = []
        if beenTappedBefore == false {
            for row in 0...data.options.count {
                /*
                 if self.table.cellForRow(at: [0, row])?.accessoryType == .checkmark{
                 rowsSelected.append(row)
                 }*/
                self.table.cellForRow(at: [0, row])?.accessoryType = UITableViewCellAccessoryType.none
                
                
            }
        }
        
        
        //table.contentInset = Constants.TABLE_INSETS
    }
    
    
    
    override class func nib() -> UINib {
        return UINib(nibName: "inCell", bundle: nil)
    }
    
    override class func mediaCellReuseIdentifier() -> String {
        return "CustomMessagesCollectionViewCellIncoming"
    }
    
    override class func cellReuseIdentifier() -> String {
        return "cell"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func rowSelected(labelValue: String, withQuestion: String, index:IndexPath, addOrDelete:UITableViewCellAccessoryType) {
        print("row selected in INCELL: \(labelValue)")
        botDelegate?.originalrowSelected!(labelValue: labelValue, withQuestion: withQuestion, index:index, addOrDelete:addOrDelete)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.options.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! miniTableViewCell
        cell.textLabel?.attributedText = NSAttributedString(string: data.options[indexPath.row], attributes:[NSFontAttributeName:Constants.STANDARD_FONT, NSForegroundColorAttributeName:Constants.MP_BLACK])
        //cell.textLabel?.text = data.options[indexPath.row]
        cell.textLabel?.textColor = UIColor.black
        cell.incomingCellDelegate = self
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        beenTappedBefore = true
        
        let currentCell = tableView.cellForRow(at: indexPath)
        let currentRowAccessory = table.cellForRow(at: indexPath)?.accessoryType
        
        let newRowAccessory = (currentRowAccessory == UITableViewCellAccessoryType.checkmark) ? UITableViewCellAccessoryType.none : UITableViewCellAccessoryType.checkmark
        
        
        for row in 0...data.options.count {
            tableView.cellForRow(at: [indexPath.section, row])?.accessoryType = UITableViewCellAccessoryType.none
        }
        
        tableView.cellForRow(at: indexPath)?.accessoryType = newRowAccessory
        (tableView.cellForRow(at: indexPath) as! miniTableViewCell).incomingCellDelegate?.rowSelected(labelValue: (currentCell?.textLabel?.text)!, withQuestion: question, index: indexPath, addOrDelete: newRowAccessory)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TABLE_ROW_HEIGHT_SMALL
    }
    
}








