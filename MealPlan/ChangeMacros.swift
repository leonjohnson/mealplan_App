import UIKit

class ChangeMacros: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var introText: UITextView!
    
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var caloriesField: UITextField!
    @IBOutlet weak var macroPicker: UIPickerView!
    @IBOutlet weak var warningField: UITextView!
    @IBOutlet weak var doneButton: MPButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeScreen(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString()
    }

}
