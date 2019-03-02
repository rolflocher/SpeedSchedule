//
//  MenuView.swift
//  SpeedSchedule
//
//  Created by Rolf Locher on 2/22/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

protocol ButtonTapDelegate : class {
    func editSavePressed(id: Int)
    func editDeletePressed(id: Int)
    func editLinkPressed(id : Int)
    func editStartEditing()
    func editEndEditing()
}

class MenuView: UIView {
    
    @IBOutlet var contentView: MenuView!
    
    weak var buttonDelegate : ButtonTapDelegate?
    
    @IBOutlet var menuBlurView: UIVisualEffectView!
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBOutlet var startTextField: UITextField!
    
    @IBOutlet var endTextField: UITextField!
    
    @IBOutlet var colorCollectionView: UICollectionView!
    
    var id : Int = 0
    
    
    let kCONTENT_XIB_NAME = "MenuView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        menuBlurView.layer.cornerRadius = 10.0
        menuBlurView.clipsToBounds = true
        colorCollectionView.layer.cornerRadius = 5.0
        colorCollectionView.clipsToBounds = true
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        buttonDelegate?.editSavePressed(id: id)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        buttonDelegate?.editDeletePressed(id: id)
    }
    
    @IBAction func linkButtonPressed(_ sender: Any) {
        buttonDelegate?.editLinkPressed(id: id)
    }
    
    @IBAction func startEditingBegan(_ sender: Any) {
        startTextField.resignFirstResponder()
        buttonDelegate?.editStartEditing()
    }
    
    @IBAction func endEditingBegan(_ sender: Any) {
        endTextField.resignFirstResponder()
        buttonDelegate?.editEndEditing()
    }
    
    

}

extension UIView
{
    func fixInView(_ container: UIView!){
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
