
import UIKit

class CalculatorButton: UIButton {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = frame.width / 2
    }
}
