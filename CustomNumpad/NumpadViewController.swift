
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
        
        let numberString = textField.text ?? ""
        guard let range = Range(range, in: numberString) else { return false }
        let updatedString = numberString.replacingCharacters(in: range, with: string)
        let correctDecimalString = updatedString.replacingOccurrences(of: formatter.decimalSeparator, with: ".")
        let completeString = correctDecimalString.replacingOccurrences(of: formatter.groupingSeparator, with: "")
        
        guard let value = Double(completeString) else { return false }
        
        let formattedNumber = formatter.string(for: value)
        textField.text = formattedNumber
        
//        if let firstString = completeString.split(separator: "+").first, let secondString = completeString.split(separator: "+").last {
//            guard let firstValue = Double(firstString) else { return false }
//            guard let secondValue = Double(secondString) else { return false }
//
//            let firstFormattedNumber = formatter.string(for: firstValue)
//            let secondFormattedNumber = formatter.string(for: secondValue)
//
//            textField.text = "\(firstFormattedNumber ?? "") + \(secondFormattedNumber ?? "")"
//
//        if completeString.contains("+") {
//            let stringArray = completeString.components(separatedBy: "+")
//            for character in stringArray {
//                print(character)
//                guard let value = Double(character) else { return false }
//                guard let formattedNumber = formatter.string(for: value) else { return false }
//                textField.text = "\(formattedNumber) + "
//            }
//        }
        
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

