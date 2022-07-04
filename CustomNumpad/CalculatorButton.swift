
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
}
