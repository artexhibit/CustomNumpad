
import UIKit

class NumpadButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                alpha = 0.5
            } else {
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear) {
                    self.alpha = 1.0
                }

            }
        }
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    private func setup() {
        let buttonSize = frame.height / 2
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: buttonSize)
        
        clipsToBounds = true
        layer.cornerRadius = buttonSize
        //adjust buttons text to fit its size
        titleLabel?.font = UIFont.systemFont(ofSize: buttonSize)
        setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
    }
}
