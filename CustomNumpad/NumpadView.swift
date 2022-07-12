
import UIKit

class NumpadView: UIView, UIInputViewAudioFeedback {
    
    var target: UITextInput?
    var enableInputClicksWhenVisible: Bool { return true }
    
    init(target: UITextInput) {
        super.init(frame: .zero)
        self.target = target
        initializeSubview()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubview()
    }
    
    func initializeSubview() {
        let xibFileName = "NumpadView"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    @IBAction func buttonPressed(_ sender: NumpadButton) {
        insertText((sender.titleLabel!.text)!)
    }
    
    func insertText(_ string: String) {
        guard let range = target?.selectedRange else { return }
        if let textField = target as? UITextField, textField.delegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) == false {
            return 
        }
        target?.insertText(string)
    }
}

extension UITextInput {
    var selectedRange: NSRange? {
        guard let selectedRange = selectedTextRange else { return nil }
        let location = offset(from: beginningOfDocument, to: selectedRange.start)
        let length = offset(from: selectedRange.start, to: selectedRange.end)
        return NSRange(location: location, length: length)
    }
}
