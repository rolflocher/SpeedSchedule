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
    var startHour = 8
    var startMin = 30
    var endHour = 9
    var endMin = 20
    
    var barRightLeft = NSLayoutConstraint()
    var barRightRight = NSLayoutConstraint()
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var roomLabel: UILabel!
    
    @IBOutlet var progressBarView: UIView!
    
    
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
        barRightLeft = NSLayoutConstraint(item: progressBarView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0)
        barRightRight = NSLayoutConstraint(item: progressBarView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: 0)
        contentView.addConstraint(barRightLeft)
    }
    
    func drawInfo(classInfo : [String:Any]) {
        nameLabel.text = classInfo["name"] as? String
        
        startHour = classInfo["startHour"] as! Int
        startMin = classInfo["startMin"] as! Int
        endHour = classInfo["endHour"] as! Int
        endMin = classInfo["endMin"] as! Int
        
        var timeText : String = String(startHour)
        timeText += ":" + String(startMin)
        timeText += "-" + String(endHour)
        timeText += ":" + String(endMin)
        timeLabel.text = timeText
        roomLabel.text = "Tol 305"
        
        updateProgress()
    }
    
    func updateProgress() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        print("saved class start hour: ")
        print(startHour)
        print("current hour: ")
        print(hour)
        
        if hour >= startHour {
            
            let count = 60*(endHour - hour) + (endMin-minutes)
            
            self.countLabel.text = String(count)
            
            let total = 60*(endHour-startHour) + (endMin-startMin)
            
            print("total: ")
            print(total)
            
            contentView.removeConstraint(barRightLeft)
            let newX = CGFloat(contentView.frame.size.width) * CGFloat(count/total)
            
            self.progressBarView.frame = CGRect(x: newX, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height)
            
            UIView.animate(withDuration: TimeInterval(count*60), animations: {
                self.contentView.addConstraint(self.barRightRight)
                self.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                print("done animating")
            })
            
            
        }
        else {
            print("times dont match up")
        }
    }
    
}
