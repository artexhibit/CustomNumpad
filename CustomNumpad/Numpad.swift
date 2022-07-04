
import UIKit

class Numpad: UIView {
    
    @IBOutlet var buttons: [UIButton]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "Numpad"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        
        roundButtons()
    }
    
    func roundButtons() {
        for button in buttons {
            button.clipsToBounds = true
            button.layer.cornerRadius = button.frame.width / 2
        }
    }
}
