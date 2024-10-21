

import UIKit

protocol RadioButtonControllerDelegate: AnyObject  {
    func didSelectedButton(_ radioButtonController:RadioButtonController, _ currentSelectedButton:RadioButton?)
}

class RadioButtonController: NSObject {
    var buttonArray = [RadioButton]()
    var canDeSelect:Bool = false
    var name:String = ""
    weak var delegate: RadioButtonControllerDelegate?
        
    init(buttons:[RadioButton]){
        super.init()
        for button in buttons{
            button.addTarget(self, action: #selector(self.radioButtonTap(sender:)), for: .touchUpInside)
        }
        self.buttonArray = buttons
    }
    
    func addButton(_ addButton:RadioButton){
        buttonArray.append(addButton)
        addButton.addTarget(self, action: #selector(self.radioButtonTap(sender:)), for: .touchUpInside)
    }
    
    func removeButton(_ removeButton:RadioButton){
        for (index, checkButton) in buttonArray.enumerated(){
            if checkButton == removeButton{
                checkButton.removeTarget(self, action: #selector(self.radioButtonTap(sender:)), for: .touchUpInside)
                buttonArray.remove(at: index)
            }
        }
    }

     @objc func radioButtonTap(sender:RadioButton){
        var currentSelectedButton:RadioButton? = nil
        if sender.isSelected{
            if canDeSelect{
                sender.isSelected = false
                currentSelectedButton = nil
            }
        }else{
            self.buttonArray.forEach { (button) in
                button.isSelected = false
            }
            sender.isSelected = true
            currentSelectedButton = sender
        }
        self.delegate?.didSelectedButton(self, currentSelectedButton)
    }
}


