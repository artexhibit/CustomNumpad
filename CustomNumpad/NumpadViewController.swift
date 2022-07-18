
import UIKit

class NumpadViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHide()
        textField.delegate = self
        textField.inputView = NumpadView(target: textField, view: view)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //number formatter
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.locale = .current
        formatter.roundingMode = .down
        
        //all possible math operation symbols user can add
        let symbolsSet = Set(["+","-","x","/"])
        var amountOfSymbols = 0
        
        let numberString = textField.text ?? ""
        guard let range = Range(range, in: numberString) else { return false }
        let updatedString = numberString.replacingCharacters(in: range, with: string)
        let correctDecimalString = updatedString.replacingOccurrences(of: formatter.groupingSeparator, with: "")
        let completeString = correctDecimalString.replacingOccurrences(of: formatter.decimalSeparator, with: ".")
        
        //current math symbol user add
        let symbol = symbolsSet.filter(completeString.contains).last ?? ""
        //if user add math symbol to an empty string - do not insert
        if string == symbol, numberString.count == 0 { return false }
        
        //count how much math symbols string has. If more that one - do not insert, string can have only one
        completeString.forEach { character in
            if symbolsSet.contains(String(character)) {
                amountOfSymbols += 1
            }
        }
        if amountOfSymbols > 1 { return false }
        
        //count how much decimals string has. If more that one - do not insert because it can have only one per number
        let numbersArray = completeString.components(separatedBy: symbol)
        for number in numbersArray {
            let amountOfDecimalSigns = number.filter({$0 == "."}).count
            if amountOfDecimalSigns > 1 { return false }
        }
        
        //create numbers from a string
        guard let firstNumber = Double(String(numbersArray.first ?? "0")) else { return true }
        guard let secondNumber = Double(String(numbersArray.last ?? "0")) else { return true }
        
        //format numbers and turn them back to string
        let firstFormattedNumber = formatter.string(for: firstNumber) ?? ""
        let secondFormattedNumber = formatter.string(for: secondNumber) ?? ""
        
        //assign formatted numbers to a textField
        textField.text = completeString.contains(symbol) ? "\(firstFormattedNumber)\(symbol)\(secondFormattedNumber)" : "\(firstFormattedNumber)"
        
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

