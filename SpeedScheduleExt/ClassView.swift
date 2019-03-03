//
//  ClassView.swift
//  SpeedSchedule
//
//  Created by Rolf Locher on 2/22/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

protocol ClassTapDelegate : class {
    func classTapped(id: Int)
}

class ClassView: UIView {

    var name : String
    var id : Int
    
    weak var classDelegate : ClassTapDelegate?
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        nameLabel.adjustsFontForContentSizeCategory = true
        nameLabel.text = name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    override init(frame: CGRect) {
        name = "temp"
        id = 0
        super.init(frame: frame)
        setupView()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = "temp"
        id = 0
        super.init(coder: aDecoder)
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        addSubview(nameLabel)
        
        let classTap = UITapGestureRecognizer(target: self, action: #selector(classTapped))
        self.addGestureRecognizer(classTap)
        self.isUserInteractionEnabled = true
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: self.frame.size.width-4)
            ])
    }
    
    @objc func classTapped() {
        classDelegate?.classTapped(id: id)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
