
import UIKit

class NumpadViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHide()
        textField.delegate = self
        textField.inputView = NumpadView(target: textField, view: view)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = .current
        formatter.roundingMode = .down
        
        let currencyText = textField.text ?? ""
        guard let range = Range(range, in: currencyText) else { return false }
        let updatedString = currencyText.replacingCharacters(in: range, with: string)
        let correctDecimalString = updatedString.replacingOccurrences(of: formatter.decimalSeparator, with: ".")
        let completeString = correctDecimalString.replacingOccurrences(of: formatter.groupingSeparator, with: "")
        
        guard let value = Double(completeString) else { return false }
        
        let formattedNumber = formatter.string(for: value)
        textField.text = formattedNumber
        
        return string == formatter.decimalSeparator
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

