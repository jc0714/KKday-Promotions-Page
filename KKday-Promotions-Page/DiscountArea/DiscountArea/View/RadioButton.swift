

import UIKit

@IBDesignable

class RadioButton: UIButton {
    @IBInspectable var selectedButtonColor: UIColor = UIColor.systemTeal
    @IBInspectable var borderColor: UIColor = .lightGray
    @IBInspectable var centerCircleColor: UIColor = UIColor.white
    
    private var outerLayer: CAShapeLayer?
    private var centerLayer: CAShapeLayer?
    
    override func draw(_ rect: CGRect) {
        self.tintColor = UIColor.clear
        layer.cornerRadius = self.frame.width / 2
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = 0.5
        layer.masksToBounds = true
        updateLayer()
    }
    
    override var isSelected: Bool {
        didSet {
            updateLayer()
        }
    }
    
    private func updateLayer() {
        
        outerLayer?.removeFromSuperlayer()
        centerLayer?.removeFromSuperlayer()
        
        if isSelected {
            
            let outerLayer = CAShapeLayer()
            let outerPath = UIBezierPath(ovalIn: bounds)
            outerLayer.path = outerPath.cgPath
            outerLayer.fillColor = selectedButtonColor.cgColor
            layer.addSublayer(outerLayer)
            self.outerLayer = outerLayer
            
            let centerLayer = CAShapeLayer()
            let centerCircleDiameter = bounds.width / 2.5
            let centerCircleRect = CGRect(
                x: (bounds.width - centerCircleDiameter) / 2,
                y: (bounds.height - centerCircleDiameter) / 2,
                width: centerCircleDiameter,
                height: centerCircleDiameter
            )
            let centerPath = UIBezierPath(ovalIn: centerCircleRect)
            centerLayer.path = centerPath.cgPath
            centerLayer.fillColor = centerCircleColor.cgColor
            layer.addSublayer(centerLayer)
            self.centerLayer = centerLayer
        }
    }
}

