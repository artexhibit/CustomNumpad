
import UIKit

class NumpadView: UIView, UIInputViewAudioFeedback {
    
    @IBOutlet var buttons: [UIButton]!
    
    var enableInputClicksWhenVisible: Bool {
        return true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
}
