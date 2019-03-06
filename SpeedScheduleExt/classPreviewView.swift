//
//  classPreviewView.swift
//  SpeedScheduleExt
//
//  Created by Rolf Locher on 3/1/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

protocol CompactViewDelegate : class {
    func updateCompactClasses()
}

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
    
    var timer = Timer()
    var timerIsRunning = false
    var startTime = 100.0
    var timerCount = 60.0
    
    var firstLoad = true
    
    weak var compactViewDelegate : CompactViewDelegate?
    
    var barRightLeft = NSLayoutConstraint()
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var roomLabel: UILabel!
    
    @IBOutlet var progressBarView: UIView!
    
    @IBOutlet var hideProgressConstraint: NSLayoutConstraint!
    
    
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
        if firstLoad {
//            barRightLeft = NSLayoutConstraint(item: progressBarView, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: 0)
//            contentView.addConstraint(barRightLeft)
            print("common init called, hiding constraint added")
            countLabel.text = "30"
            firstLoad = false
        }
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
        
        
        
//        contentView.removeConstraint(barRightLeft)
        //self.progressBarView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
    }
    
    func updateProgress() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        if hour > startHour && (hour < endHour || hour == endHour && minutes <= endMin) || hour == startHour && minutes >= startMin && (hour < endHour || hour == endHour && minutes < endMin) {
            
//            for x in contentView.constraints {
//                if x == barRightLeft {
//                    contentView.removeConstraint(barRightLeft)
//                }
//
//            }
            
            if progressBarView.backgroundColor != UIColor.green {
                progressBarView.backgroundColor = UIColor.green
            }
            
            
            
            let count = 60*60*(endHour - hour) + 60*(endMin-minutes) - seconds
            
            let total = 60*60*(endHour-startHour) + 60*(endMin-startMin)
            
            let newX = CGFloat(contentView.frame.size.width) * CGFloat(total-count)/CGFloat(total) - CGFloat(contentView.frame.size.width)
            
            //print("new minutes: \(minutes) new seconds: \(seconds)")
            //print("new count: \(count) new total: \(total) new X: \(newX) \n")
//            print("ongoing class, new progress X: \(newX)")
            
            if !timerIsRunning {
                startTime = Date().timeIntervalSinceReferenceDate
                timerCount = Double(count)
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
                timerIsRunning = true
            }

            UIView.animate(withDuration: 5, animations: {
                self.progressBarView.frame = CGRect(x: newX, y: 0, width: self.contentView.frame.size.width, height: self.contentView.frame.size.height)
                self.layoutIfNeeded()
            }, completion: { (finished: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.updateProgress()
                }
                
            })
            
        }
        else if hour < startHour || hour == startHour && minutes < startMin {
            print("waiting for class to start, polling")
            progressBarView.backgroundColor = UIColor.clear
            hideProgressConstraint.isActive=true
            DispatchQueue.main.asyncAfter(deadline: .now() + 30) {
                self.updateProgress()
            }
        }
        else {
            print("this class is ova")
            //contentView.addConstraint(barRightLeft)
            
            countLabel.text = ""
            hideProgressConstraint.isActive=true
            compactViewDelegate?.updateCompactClasses()
            // this was to change the coomit
            print("dpes this commiot")
        }
    }
    
    @objc func updateTimer() {
        timerCount -= 1
        if timerCount < 0 {
            timer.invalidate()
            timerIsRunning = false
            print("timer reached 0")
        }
        else {
            countLabel.text = String(Int(timerCount))
        }
        
    }
    
}
