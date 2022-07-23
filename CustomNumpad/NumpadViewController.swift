
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
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 1
        formatter.locale = .current
        formatter.roundingMode = .down
        
        let numberString = "\(textField.text ?? "")".replacingOccurrences(of: formatter.groupingSeparator, with: "")
        let lastCharacter = numberString.last ?? "."
        var symbol: String {
            var tempArray = [String]()
            let mathSymbols = "+-/*"
            for character in numberString {
                if mathSymbols.contains(character) {
                    tempArray.append(String(character))
                }
            }
            return tempArray.last ?? ""
        }
        var numbersArray: [String] {
            if numberString.first == "-" {
                let positiveString = numberString.dropFirst()
                var tempArray = positiveString.components(separatedBy: symbol)
                tempArray[0] = "-\(tempArray[0])"
                return tempArray
            } else {
                return numberString.components(separatedBy: symbol)
            }
        }
        var floatNumberString: String {
            let floatMidArray = lastCharacter == Character(formatter.decimalSeparator) ? numberString.replacingOccurrences(of: formatter.decimalSeparator, with: ".").dropLast().components(separatedBy: symbol).compactMap { Float($0) } : numberString.replacingOccurrences(of: formatter.decimalSeparator, with: ".").components(separatedBy: symbol).compactMap { Float($0) }
            return "\(floatMidArray.first ?? 0)\(symbol)\(floatMidArray.last ?? 0)"
        }
        
        let amountOfDecimals = "\(numbersArray.last ?? "")\(string)".filter({ $0 == Character(formatter.decimalSeparator) }).count
        
        //allow to insert 0 after the decimal symbol to avoid formatting i.e. 2.04
        formatter.minimumFractionDigits = numberString.last == Character(formatter.decimalSeparator) && string == "0" ? 1 : 0
        
        //allow string to be modified by backspace button
        if string == "" { return false }
        
        //allow numbers as a first character, except math symbols
        if numberString == "" {
            if Character(string).isNumber {
                textField.text = string
            } else {
                return false
            }
        }
        //allow only one decimal symbol per number
        else if amountOfDecimals > 1 { return false }
         
        if numbersArray.count > 1 {
        //if number is entered
            if Character(string).isNumber {
                print(numbersArray)
                textField.text = "\(formatter.string(for: Double("\(numbersArray.first?.replacingOccurrences(of: formatter.decimalSeparator, with: ".") ?? "")") ?? 0 as NSNumber) ?? "")\(symbol)\(formatter.string(for: Double("\(numbersArray.last?.replacingOccurrences(of: formatter.decimalSeparator, with: ".") ?? "")\(string)") ?? 0 as NSNumber) ?? "")"
        //if symbol is entered
            } else if string == formatter.decimalSeparator {
                textField.text = "\(textField.text ?? "")\(string)"
            } else {
        //perform calculation if last entered character is a number
                if lastCharacter.isNumber {
                    let expression = NSExpression(format: floatNumberString)
                    let answer = expression.expressionValue(with: nil, context: nil)
                    textField.text = "\(formatter.string(from: answer as! NSNumber) ?? "")\(string)"
        //perform calculation if last entered character is a decimal symbol
                } else if lastCharacter == Character(formatter.decimalSeparator) {
                    let expression = NSExpression(format: floatNumberString)
                    let answer = expression.expressionValue(with: nil, context: nil)
                    textField.text = "\(formatter.string(from: answer as! NSNumber) ?? "")\(string)"
        //change math symbol before enter a second number
                } else {
                    textField.text = "\(textField.text?.dropLast() ?? "")\(string)"
                }
            }
        } else {
        //if number is entered
            if Character(string).isNumber {
                textField.text = "\(formatter.string(for: Double("\(numbersArray.first?.replacingOccurrences(of: formatter.decimalSeparator, with: ".") ?? "")\(string)") ?? 0 as NSNumber) ?? "")"
            } else {
        //if math symbol is entered
                if lastCharacter.isNumber {
                    textField.text = "\(textField.text ?? "")\(string)"
                }
            }
        }
        return false
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
