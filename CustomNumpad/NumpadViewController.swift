
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
        
        var shouldChange: Bool = true
        var symbol: String?
        let mathSymbols = "+-x/"
        //current text visible in the text field
        let numberString = textField.text ?? ""
        //last character in the text field
        let lastCharacter = numberString.last ?? "+"
        //get all the numbers displayed in the textfield by separating them from symbols
        let numbersArray = numberString.components(separatedBy: CharacterSet(charactersIn: mathSymbols))
        
        if string == "" { return false }
        //if symbol is a first character in a string - do not insert
        if numberString == "" {
            if !Character(string).isNumber { shouldChange = false }
        }
        //if a number is entered check for the decimal points
        else if Character(string).isNumber {
            if numbersArray.last?.contains(NumberFormatter().decimalSeparator) ?? true && numbersArray.last?.components(separatedBy: NumberFormatter().decimalSeparator).last?.count == 2 && Character(string).isNumber {
                shouldChange =  false
            } else {
                for character in numberString {
                    if mathSymbols.contains(character){
                        symbol = String(character)
                        break
                    }
                }
                if symbol != nil {
                    textField.text = "\(numbersArray.first?.formatted() ?? "")\(symbol!)\(((numbersArray.last ?? "") + string).formatted())"
                } else {
                    textField.text = "\(((numbersArray.first ?? "") + string).formatted())"
                }
                shouldChange = false
            }
            // if symbol is entered
        } else {
            if string == NumberFormatter().decimalSeparator {
                if !lastCharacter.isNumber { shouldChange = false }
            }
            //if there are more than 1 number in numbersArray, calculate the value
            else if lastCharacter.isNumber {
                if numbersArray.count > 1 {
                    let correctDecimalString = numberString.replacingOccurrences(of: NumberFormatter().groupingSeparator, with: "")
                    let correctString = correctDecimalString.replacingOccurrences(of: NumberFormatter().decimalSeparator, with: ".")
                    let expression = NSExpression(format: correctString)
                    let answer = expression.expressionValue(with: nil, context: nil) as! Double
                    textField.text = "\(answer.formatted())\(string)"
                    shouldChange = false
                }
            } else {
                //change the symbol
                textField.text = "\(numberString.dropLast())\(string)"
                shouldChange = false
            }
        }
        return shouldChange
    }
}

extension String {
    func formatted() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = .current
        let correctDecimalString = self.replacingOccurrences(of: formatter.groupingSeparator, with: "")
        let correctString = correctDecimalString.replacingOccurrences(of: formatter.decimalSeparator, with: ".")
        return formatter.string(from: NSNumber(value: Double(correctString) ?? 0)) ?? ""
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
