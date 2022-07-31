
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
        let rangeString = (((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)).replacingOccurrences(of: formatter.groupingSeparator, with: "")
        
        let lastCharacter = numberString.last ?? "."
        var symbol: String {
            var tempArray = [String]()
            let mathSymbols = "+-÷x"
            for character in numberString {
                if mathSymbols.contains(character) {
                    tempArray.append(String(character))
                }
            }
            return tempArray.last ?? ""
        }
        var numbersArray: [String] {
            if rangeString.first == "-" {
                let positiveString = rangeString.dropFirst()
                var tempArray = positiveString.components(separatedBy: symbol)
                tempArray[0] = "-\(tempArray[0])"
                return tempArray
            } else {
                return rangeString.components(separatedBy: symbol)
            }
        }
        //turn numbers into Float and create a String from them to be able to receive a correct result from NSExpression
        var floatNumberArray: [Float] {
            if numberString.first == "-" {
                let tempString = lastCharacter == Character(formatter.decimalSeparator) ? numberString.dropFirst().dropLast() : numberString.dropFirst()
                var tempArray = tempString.components(separatedBy: symbol)
                tempArray[0] = "-\(tempArray[0])"
                return tempArray.compactMap { Float($0.replacingOccurrences(of: formatter.decimalSeparator, with: ".")) }
            } else {
                return numberString.components(separatedBy: symbol).compactMap { Float($0.replacingOccurrences(of: formatter.decimalSeparator, with: ".")) }
            }
        }
        
        var floatNumberString: String {
            if numberString.contains("x") {
                return "\(floatNumberArray.first ?? 0)\("*")\(floatNumberArray.last ?? 0)"
            } else if numberString.contains("÷") {
                return "\(floatNumberArray.first ?? 0)\("/")\(floatNumberArray.last ?? 0)"
            } else {
                return "\(floatNumberArray.first ?? 0)\(symbol)\(floatNumberArray.last ?? 0)"
            }
        }
        //allow to insert 0 after the decimal symbol to avoid formatting i.e. 2.04
        formatter.minimumFractionDigits = numberString.last == Character(formatter.decimalSeparator) && string == "0" ? 1 : 0
        
        //allow string to be modified by backspace button
        if string == "" { return false }
        if string == "=" && numberString.last == Character(symbol) {
            textField.text = "\(formatter.string(for: Double(numberString.dropLast())) ?? "")"
            return false
        }
        
        //allow numbers as a first character, except math symbols
        if numberString == "" {
            if Character(string).isNumber {
                textField.text = string
            } else {
                return false
            }
        }
        //allow only one decimal symbol per number
        for number in numbersArray {
            let amountOfDecimalSigns = number.filter({$0 == "."}).count
            if amountOfDecimalSigns > 1 { return false }
        }
         
        if numbersArray.count > 1 {
        //if number is entered
            if Character(string).isNumber {
                textField.text = "\(formatter.string(for: Double("\(numbersArray.first?.replacingOccurrences(of: formatter.decimalSeparator, with: ".") ?? "")") ?? 0) ?? "")\(symbol)\(formatter.string(for: Double("\(numbersArray.last?.replacingOccurrences(of: formatter.decimalSeparator, with: ".") ?? "")") ?? 0) ?? "")"
        //if symbol is entered
            } else if string == formatter.decimalSeparator {
                textField.text = "\(textField.text ?? "")\(string)"
            } else {
        //perform calculation if last entered character is a number
                if lastCharacter.isNumber {
                    if floatNumberArray.count == 2 {
                        let result = performCalculation(format: floatNumberString)
                        textField.text = string == "=" ? "\(formatter.string(from: result) ?? "")" : "\(formatter.string(from: result) ?? "")\(string)"
                    } else {
                        textField.text = "\(textField.text ?? "")\(string)"
                    }
        //perform calculation if last entered character is a decimal symbol
                } else if lastCharacter == Character(formatter.decimalSeparator) {
                    let result = performCalculation(format: floatNumberString)
                    textField.text = string == "=" ? "\(formatter.string(from: result) ?? "")" : "\(formatter.string(from: result) ?? "")\(string)"
        //change math symbol before enter a second number
                } else {
                    textField.text = "\(textField.text?.dropLast() ?? "")\(string)"
                }
            }
        } else {
        //if number is entered
            if Character(string).isNumber {
                textField.text = "\(formatter.string(for: Double("\(numbersArray.first?.replacingOccurrences(of: formatter.decimalSeparator, with: ".") ?? "")") ?? 0) ?? "")"
            } else {
        //if math symbol is entered
                if lastCharacter.isNumber {
                    textField.text = "\(textField.text ?? "")\(string)"
                }
            }
        }
        return false
    }
    
    func performCalculation(format: String) -> NSNumber {
        let expression = NSExpression(format: format)
        let answer = expression.expressionValue(with: nil, context: nil)
        return answer as! NSNumber
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
