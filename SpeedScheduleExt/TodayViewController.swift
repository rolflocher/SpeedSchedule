//
//  TodayViewController.swift
//  SpeedScheduleExt
//
//  Created by Rolf Locher on 1/24/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var scheduleView: ScheduleView!
    
    @IBOutlet var timeView: UIView!
    
    @IBOutlet var mondayView: UIView!
    
    @IBOutlet var tuesdayView: UIView!
    
    @IBOutlet var wednesdayView: UIView!
    
    @IBOutlet var thursdayView: UIView!
    
    @IBOutlet var fridayView: UIView!
    
    @IBOutlet var upcomingDayView: upcomingDayView!
    
    
    var startHour = 8
    var startMin = 30
    var endHour = 20
    var endMin = 30
    var firstLoad = true
    var loadedIntoCompact = false
    var drewLines = false
    var classListGlobal = [[String:Any]]()
    
    var deviceSize = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        deviceSize = UIScreen.main.bounds.height
        print("Device height: \(deviceSize)")
        if self.extensionContext?.widgetActiveDisplayMode == .compact {
            hideAll()
            upcomingDayView.isHidden = false
        }
        else {
            showAll()
            upcomingDayView.isHidden = true
        }
        if hasPreviousData() {
            upcomingDayView.layoutClasses(classList:classListGlobal)
            switch deviceSize {
            case 667.0 : // 8
                scheduleView.height = 424
                scheduleView.width = 63
            case 736.0 : // 8P, 7P
                scheduleView.height = 424
                scheduleView.width = 70.5
            case 568.0 : //SE
                scheduleView.height = 424
                scheduleView.width = 52
            case 812.0 : //XS, X
                scheduleView.height = 424
                scheduleView.width = 63
            case 896.0 : //XS Max, XR
                scheduleView.height = 424
                scheduleView.width = 70.5
            default :
                print("unrecognized size")
            }
            self.scheduleView.drawLines()
            self.scheduleView.drawClasses(classList: classListGlobal)
            // NEXT incorporate time labels into scheduleview heirarchy
            drawTimeLines(classList: classListGlobal)
        }
    }
    
//    override func viewDidLayoutSubviews() {
//
////        print("current height: \(self.timeView.frame.height)")
////        print("current width: \(self.scheduleView.mondayLongView.frame.width)")
//
//        if firstLoad {
//            if self.extensionContext?.widgetActiveDisplayMode == .compact {
//                if self.scheduleView.mondayLongView.frame.width != 74.0 {
//                    hideAll()
//                    upcomingDayView.isHidden = false
//                    if hasPreviousData() {
//                        //upcomingDayView.layoutClasses(classList: classListGlobal)
//
//                        // debug fun
//                        //var temp = [[String:Any]]()
////                        var tempClass = [String:Any]()
////                        tempClass["name"] = "Coded Test Class"
////                        tempClass["color"] = UIColor.cyan
////                        tempClass["startHour"] = 0
////                        tempClass["endHour"] = 0
////                        tempClass["startMin"] = 40
////                        tempClass["endMin"] = 44
////                        tempClass["day"] = "Wednesday"
////                        classListGlobal.append(tempClass)
//                        upcomingDayView.layoutClasses(classList:classListGlobal)
//                    }
//                    firstLoad = false
//                    loadedIntoCompact = true
//                }
//                else {
//                    self.view.setNeedsLayout()
//                }
//            }
//            else {
//                if self.scheduleView.mondayLongView.frame.width != 74.0 && self.timeView.frame.height != 84.0 {
//                    showAll()
//                    upcomingDayView.isHidden = true
//                    if hasPreviousData() {
//                        if !drewLines {
//                            self.scheduleView.drawLines()
//                            self.scheduleView.drawClasses(classList: classListGlobal)
//                            drawTimeLines(classList: classListGlobal)
//                            drewLines = true
//                        }
//                    }
//                    firstLoad = false
//                }
//                else {
//                    self.view.setNeedsLayout()
//                }
//            }
//        }
//
////        if self.scheduleView.mondayLongView.frame.width != 74.0 && self.timeView.frame.height != 84.0 {
////            if firstLoad {
////                if self.extensionContext?.widgetActiveDisplayMode == .compact {
////                    hideAll()
////                    //NSLayoutConstraint.activate(
////                    //    [scheduleView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 7)])
////                    upcomingDayView.isHidden = false
////                    hasPreviousData()
////                    firstLoad = false
////                }
////                else {
////
////                    showAll()
////                    //NSLayoutConstraint.activate(
////                    //    [scheduleView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 7)])
////                    upcomingDayView.isHidden = true
////                    hasPreviousData()
////                    firstLoad = false
////                }
////            }
////        }
////        else {
////            print("not layed out fully...")
////            self.view.setNeedsLayout()
////        }
//
//    }
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = CGSize(width: 398, height: 110)
            hideAll()
            upcomingDayView.isHidden = false
            
            if !firstLoad {
                if hasPreviousData() {
                    upcomingDayView.layoutClasses(classList: classListGlobal)
                }
            }
            
        }
        else {
            self.preferredContentSize = CGSize(width: 398, height: 450)
            showAll()
            upcomingDayView.isHidden = true
            if !firstLoad {
                if hasPreviousData() {
                    if !drewLines {
                        //self.extensionContext?.
                        self.scheduleView.drawLines()
                        self.scheduleView.drawClasses(classList: classListGlobal)
                        drawTimeLines(classList: classListGlobal)
                        drewLines = true
                    }
                }
            }
        }
    }
    
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func hideAll() {
        self.scheduleView.isHidden = true
        self.mondayView.isHidden = true
        self.tuesdayView.isHidden = true
        self.wednesdayView.isHidden = true
        self.thursdayView.isHidden = true
        self.fridayView.isHidden = true
        self.timeView.isHidden = true
        
    }
    
    func showAll() {
        self.scheduleView.isHidden = false
        self.mondayView.isHidden = false
        self.tuesdayView.isHidden = false
        self.wednesdayView.isHidden = false
        self.thursdayView.isHidden = false
        self.fridayView.isHidden = false
        self.timeView.isHidden = false
        
    }
    
    func hasPreviousData() -> Bool {
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            
            if let classListData = userDefaults.object(forKey: "classList") as? Data {
                let classListDecoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(classListData) as! [[String:Any]]
                
                classListGlobal = classListDecoded!
                return true
                //self.scheduleView.height = self.preferredContentSize.height - 26.0
                
//                if !loadedIntoCompact {
//                    self.scheduleView.drawLines()
//                    self.scheduleView.drawClasses(classList: classListDecoded!)
//                    drawTimeLines(classList: classListDecoded!)
//                    print("in haspreviousdata, finished expanded drawing")
//                }
//
//
//                upcomingDayView.layoutClasses(classList: classListDecoded!)
                
            }
            else {
                print("couldn't find classList")
                return false
            }
        }
        else {
            return false
        }
        
    }
    
    func drawTimeLines(classList: [[String:Any]]) {
        
        var usableHeight = CGFloat()
        switch deviceSize {
        case 667.0 :
            usableHeight = 424.0
        case 736.0 :
            usableHeight = 424.0
        case 568.0 :
            usableHeight = 424.0
        case 812.0 :
            usableHeight = 424.0
        case 896.0 :
            usableHeight = 424.0
        default :
            print("unrecognized size")
        }
        
//        startHour = 24
//        startMin = 0
//        endHour = 0
//        endMin = 0
        startHour = 8
        startMin = 0
        endHour = 20
        endMin = 0
        
        self.timeView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
//        for classInfo in classList {
//            if (classInfo["startHour"] as! Int) < startHour {
//                if (classInfo["startMin"] as! Int) < startMin {
//                    self.startMin = (classInfo["startMin"] as! Int)
//                }
//                self.startHour = (classInfo["startHour"] as! Int)
//            }
//            if (classInfo["endHour"] as! Int) > endHour {
//                if (classInfo["endMin"] as! Int) < endMin {
//                    self.endMin = (classInfo["endMin"] as! Int)
//                }
//                self.endHour = (classInfo["endHour"] as! Int)
//            }
//        }
//
//        if self.startMin < 30 {
//            self.startMin = 0
//        }
//        if self.endMin > 0 {
//            self.endMin = 30
//        }
        
        var startOffset = 2 * (self.startHour-8)
        startOffset += (self.startMin-30) / 30
        
        var numSegments = 2 * (self.endHour - self.startHour)
        numSegments += (self.endMin - self.startMin) / 30
        
        for x in 1...numSegments+1 {
            
            //let height = CGFloat((self.timeView.frame.size.height/CGFloat(numSegments+1)) * CGFloat(x))
            let height = CGFloat((usableHeight/CGFloat(numSegments+1)) * CGFloat(x))
            
            if x == 1 {
                print("time label drawer thinks height is \(usableHeight)")
            }
            
            let textLayer = CATextLayer()
            textLayer.frame = self.timeView.frame // may need to hardcode
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = #colorLiteral(red: 0.2041128576, green: 0.2041538656, blue: 0.2041074634, alpha: 0.9130996919)
            textLayer.fontSize = 14
            
            let switchInt = x+startOffset
            
            switch (switchInt) {
            case 1:
                print("")
            case 2:
                textLayer.string = "9 AM"
            case 3:
                print("")
            case 4:
                textLayer.string = "10 AM"
            case 5:
                print("")
            case 6:
                textLayer.string = "11 AM"
            case 7:
                print("")
            case 8:
                textLayer.string = "Noon"
            case 9:
                print("")
            case 10:
                textLayer.string = "1 PM"
            case 11:
                print("")
            case 12:
                textLayer.string = "2 PM"
            case 13:
                print("")
            case 14:
                textLayer.string = "3 PM"
            case 15:
                print("")
            case 16:
                textLayer.string = "4 PM"
            case 17:
                print("")
            case 18:
                textLayer.string = "5 PM"
            case 19:
                print("")
            case 20:
                textLayer.string = "6 PM"
            case 21:
                print("")
            case 22:
                textLayer.string = "7 PM"
            case 23:
                print("")
            case 24:
                textLayer.string = "8 PM"
            case 25:
                print("")
            default:
                print("f")
            }
            textLayer.alignmentMode = .right
            if (deviceSize == 667.0) {
                textLayer.position = CGPoint(x:17,y:height+169)
            }
            else if (deviceSize == 736.0) {
                textLayer.position = CGPoint(x:17,y:height+168)
            }
            else if (deviceSize == 568.0) {
                textLayer.position = CGPoint(x:17,y:height+169)
            }
            else if (deviceSize == 812.0) {
                textLayer.position = CGPoint(x:17,y:height+169)
            }
            else if (deviceSize == 896.0) {
                textLayer.position = CGPoint(x:17,y:height+169)//8
            }
            else {
                textLayer.position = CGPoint(x:-2,y:height+301)
                print("default text position used, unknown device height")
            }
            
            self.timeView.layer.addSublayer(textLayer)
        }
        
        
        DispatchQueue.main.async {
            self.view.setNeedsDisplay()
        }
    }
    
}
