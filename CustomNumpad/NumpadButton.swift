
import UIKit

class NumpadButton: UIButton {
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIDevice.current.playInputClick()
                switch self.tag {
                case 1...6: backgroundColor = UIColor(named: "FadeOrangeColor")
                case 7 : backgroundColor = UIColor(named: "FadeBlueColor")
                default: backgroundColor = UIColor(named: "FadeGrayColor")
                }
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction]) {
                    switch self.tag {
                    case 1...6: self.backgroundColor = UIColor(named: "NumpadOrangeColor")
                    case 7 : self.backgroundColor = UIColor(named: "NumpadBlueColor")
                    default: self.backgroundColor = UIColor(named: "NumpadGrayColor")
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupButtonStyle()
    }
    
    private func setupButtonStyle() {
        let buttonSize = frame.height / 2
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: buttonSize)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        //round corners
        clipsToBounds = false
        layer.cornerRadius = windowScene.interfaceOrientation == .portrait ? 15 : 5
        //layout buttons label size to fit the button height
        titleLabel?.font = UIFont.systemFont(ofSize: buttonSize)
        setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        //bottom shadow
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
    }
}
