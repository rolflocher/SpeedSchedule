//
//  upcomingDayView.swift
//  SpeedScheduleExt
//
//  Created by Rolf Locher on 3/1/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class upcomingDayView: UIView, CompactViewDelegate {
    
    var localClassList = [[String:Any]]()
    
    func updateCompactClasses() {
        print("trying to relayout the classes cuz that one just ended")
        layoutClasses(classList: localClassList)
        //self.layoutIfNeeded()
    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var classPreviewView: classPreviewView!
    
    @IBOutlet var classPreviewView1: classPreviewView!
    
    @IBOutlet var classPreviewView2: classPreviewView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("upcomingDayView", owner: self, options: nil)
        contentView.fixInView(self)
        classPreviewView.compactViewDelegate = self
    }
    
    func layoutClasses(classList: [[String:Any]]) {
        
        localClassList = classList //got an exc bad acesss termination here once sry
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let day = calendar.component(.weekday, from: date) // disregard warning until release
        
        // DELETE THIS
//        day = 6 // commenting is like deleting
        
        var sentList : [[String:Any]] = []
        
        // this was to change the coomit
        print("dpes this commiot")
        
        for classInfo in classList {
            if (classInfo["day"] as! String) == "Monday" && day == 2 {
                if (classInfo["endHour"] as! Int > hour || classInfo["endHour"] as! Int == hour && classInfo["endMin"] as! Int > minutes) {
                    sentList.append(classInfo)
                }
            }
            if (classInfo["day"] as! String) == "Tuesday" && day == 3 {
                if (classInfo["endHour"] as! Int > hour || classInfo["endHour"] as! Int == hour && classInfo["endMin"] as! Int > minutes) {
                    sentList.append(classInfo)
                }
            }
            if (classInfo["day"] as! String) == "Wednesday" && day == 4 {
                if (classInfo["endHour"] as! Int > hour || classInfo["endHour"] as! Int == hour && classInfo["endMin"] as! Int > minutes) {
                    sentList.append(classInfo)
                }
            }
            if (classInfo["day"] as! String) == "Thursday" && day == 5 {
                if (classInfo["endHour"] as! Int > hour || classInfo["endHour"] as! Int == hour && classInfo["endMin"] as! Int > minutes) {
                    sentList.append(classInfo)
                }
            }
            if (classInfo["day"] as! String) == "Friday" && day == 6 {
                if (classInfo["endHour"] as! Int > hour || classInfo["endHour"] as! Int == hour && classInfo["endMin"] as! Int > minutes) {
                    sentList.append(classInfo)
                }
            }
        }
        
        var referenceTime = [String:Any]()
        referenceTime["startHour"] = 24
        referenceTime["startMin"] = 30
        
        if sentList.count == 1 {
            
            var firstClass : [String:Any] = referenceTime
            
            for classX in sentList {
                if (classX["startHour"] as! Int) * 60 + (classX["startMin"] as! Int) <= (firstClass["startHour"] as! Int) * 60 + (firstClass["startMin"] as! Int) {
                    firstClass = classX
                }
            }
            
            classPreviewView.drawInfo(classInfo: firstClass)
            classPreviewView.updateProgress()
            classPreviewView.progressBarView.backgroundColor = UIColor.green
            classPreviewView.contentView.backgroundColor = firstClass["color"] as? UIColor
            classPreviewView1.progressBarView.backgroundColor = UIColor.clear
            classPreviewView2.progressBarView.backgroundColor = UIColor.clear
            
            classPreviewView1.contentView.backgroundColor = UIColor.clear
            classPreviewView1.nameLabel.text = ""
            classPreviewView1.timeLabel.text = ""
            classPreviewView1.countLabel.text = ""
            classPreviewView1.roomLabel.text = ""
            
            classPreviewView2.contentView.backgroundColor = UIColor.clear
            classPreviewView2.nameLabel.text = ""
            classPreviewView2.timeLabel.text = ""
            classPreviewView2.countLabel.text = ""
            classPreviewView2.roomLabel.text = ""
            
            
        }
        else if sentList.count == 2 {
            
            var firstClass : [String:Any] = referenceTime
            var secondClass : [String:Any] = referenceTime
            
            for classX in sentList {
                if (classX["startHour"] as! Int) * 60 + (classX["startMin"] as! Int) <= (firstClass["startHour"] as! Int) * 60 + (firstClass["startMin"] as! Int) {
                    secondClass = firstClass
                    firstClass = classX
                }
                else if (classX["startHour"] as! Int) * 60 + (classX["startMin"] as! Int) <= (secondClass["startHour"] as! Int) * 60 + (secondClass["startMin"] as! Int) {
                    secondClass = classX
                }
            }
            
            classPreviewView.drawInfo(classInfo: firstClass)
            classPreviewView1.drawInfo(classInfo: secondClass)
            classPreviewView.updateProgress()
            classPreviewView.progressBarView.backgroundColor = UIColor.green
            classPreviewView.contentView.backgroundColor = firstClass["color"] as? UIColor
            classPreviewView1.progressBarView.backgroundColor = UIColor.clear
            classPreviewView1.contentView.backgroundColor = secondClass["color"] as? UIColor
            classPreviewView2.progressBarView.backgroundColor = UIColor.clear
            
            classPreviewView2.contentView.backgroundColor = UIColor.clear
            classPreviewView2.nameLabel.text = ""
            classPreviewView2.timeLabel.text = ""
            classPreviewView2.countLabel.text = ""
            classPreviewView2.roomLabel.text = ""
        }
        else if sentList.count >= 3 {
            
            var firstClass : [String:Any] = referenceTime
            var secondClass : [String:Any] = referenceTime
            var thirdClass : [String:Any] = referenceTime
            
            for classX in sentList {
                if (classX["startHour"] as! Int) * 60 + (classX["startMin"] as! Int) <= (firstClass["startHour"] as! Int) * 60 + (firstClass["startMin"] as! Int) {
                    thirdClass = secondClass
                    secondClass = firstClass
                    firstClass = classX
                }
                else if (classX["startHour"] as! Int) * 60 + (classX["startMin"] as! Int) <= (secondClass["startHour"] as! Int) * 60 + (secondClass["startMin"] as! Int) {
                    thirdClass = secondClass
                    secondClass = classX
                }
                else if (classX["startHour"] as! Int) * 60 + (classX["startMin"] as! Int) <= (thirdClass["startHour"] as! Int) * 60 + (thirdClass["startMin"] as! Int) {
                    thirdClass = classX
                }
            }
            
            classPreviewView.drawInfo(classInfo: firstClass)
            classPreviewView1.drawInfo(classInfo: secondClass)
            classPreviewView2.drawInfo(classInfo: thirdClass)
            classPreviewView.updateProgress()
            classPreviewView.contentView.backgroundColor = firstClass["color"] as? UIColor
            classPreviewView1.progressBarView.backgroundColor = UIColor.clear
            classPreviewView1.contentView.backgroundColor = secondClass["color"] as? UIColor
            classPreviewView2.progressBarView.backgroundColor = UIColor.clear
            classPreviewView2.contentView.backgroundColor = thirdClass["color"] as? UIColor
        }
        else {
            print("theres no more classes today")
        }
        
        
        
        
    
        
    }
    
    
}
