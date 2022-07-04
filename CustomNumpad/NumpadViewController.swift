
import UIKit

class NumpadViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHide()
        textField.delegate = self
        
        let numpadView = Numpad(frame: CGRect(x: 0, y: 0, width: 0, height: 300))
        textField.inputView = numpadView
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
}


// Hide Numpad by tap on the screen
extension NumpadViewController {
    func setupKeyboardHide() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

