//
//  classPreviewView.swift
//  SpeedScheduleExt
//
//  Created by Rolf Locher on 3/1/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class classPreviewView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var name : String = ""
    var startHour : Int = 8
    var endHour : Int = 9
    var startMin : Int = 30
    var endMin : Int = 20
    var room : String = "Tol 308"
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var roomLabel: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("classPreviewView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
}
