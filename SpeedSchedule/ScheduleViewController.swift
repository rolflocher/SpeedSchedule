//
//  ScheduleViewController.swift
//  SpeedSchedule
//
//  Created by Rolf Locher on 1/29/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit


class ScheduleViewController: UIViewController, UITextFieldDelegate, ButtonTapDelegate, ClassTapDelegate {
    
    func editStartEditing() {
        menuWindow.isHidden = true
        self.timeWheelBlurView.isHidden=false
        self.timeWheel.minuteInterval=5
        self.timeWheel.isHidden=false
        self.timeWheelLabel.text = "New Class Start Time"
        self.closeIconImageView.isHidden=false
    }
    
    func editEndEditing() {
        menuWindow.isHidden = true
        self.timeWheelBlurView.isHidden=false
        self.timeWheel.minuteInterval=5
        self.timeWheel.isHidden=false
        self.timeWheelLabel.text = "New Class End Time"
        self.closeIconImageView.isHidden=false
    }
    
    func classTapped(id: Int) {
        
        let classInfo = classList[id]
        
        if isLinking {
            var senderInfo = classList[menuWindow.id]
            senderInfo["color"] = classInfo["color"]
            classList[menuWindow.id] = senderInfo
            if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
                let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classList, requiringSecureCoding: false)
                userDefaults.set(encodedDic, forKey: "classList")
                userDefaults.synchronize()
            }
            _ = hasPreviousData()
            isLinking = false
            menuWindow.colorCollectionView.backgroundColor = classInfo["color"] as? UIColor
        }
        else {
            menuWindow.id = id
            menuWindow.nameTextField.text = classInfo["name"] as? String
            
            if classInfo["startHour"] as! Int == 12 {
                menuWindow.startTextField.text = String(classInfo["startHour"] as! Int) + ":" + String(classInfo["startMin"] as! Int) + " PM"
            }
            else if classInfo["startHour"] as! Int > 12 {
                let startHour = classInfo["startHour"] as! Int - 12
                menuWindow.startTextField.text = String(startHour) + ":" + String(classInfo["startMin"] as! Int) + " PM"
            }
            else {
                menuWindow.startTextField.text = String(classInfo["startHour"] as! Int) + ":" + String(classInfo["startMin"] as! Int) + " AM"
            }
            
            if classInfo["endHour"] as! Int == 12 {
                menuWindow.endTextField.text = String(classInfo["endHour"] as! Int) + ":" + String(classInfo["endMin"] as! Int) + " PM"
            }
            else if classInfo["endHour"] as! Int > 12 {
                let endHour = classInfo["endHour"] as! Int - 12
                menuWindow.endTextField.text = String(endHour) + ":" + String(classInfo["endMin"] as! Int) + " PM"
            }
            else {
                menuWindow.endTextField.text = String(classInfo["endHour"] as! Int) + ":" + String(classInfo["endMin"] as! Int) + " AM"
            }
            menuWindow.colorCollectionView.backgroundColor = classInfo["color"] as? UIColor
            menuWindow.isHidden=false
        }
        
    }
    
    func editLinkPressed(id : Int) {
        print("link pressed")
        menuWindow.isHidden = true
        isLinking = true
    }
    
    func editSavePressed(id : Int) {
        print("the xib called a function in the view controller, nice")
        
        let nameText = menuWindow.nameTextField.text!
        if nameText == "" || nameText == "Invalid" {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let startText = menuWindow.startTextField.text!
        let endText = menuWindow.endTextField.text!
        if startText == "" || endText == "" {
            return
        }
        if startText == "invalid" || endText == "invalid" {
            return
        }
        
        let classStartTime = dateFormatter.date(from: startText)!
        let classEndTime = dateFormatter.date(from: endText)!
        
        if classStartTime > classEndTime {
            menuWindow.startTextField.text = "invalid"
            return
        }
        
        var classInfo = classList[id]
        classInfo["name"] = menuWindow.nameTextField.text ?? ""
        dateFormatter.dateFormat="HH"
        classInfo["startHour"] = Int(dateFormatter.string(from: classStartTime))!
        classInfo["endHour"] = Int(dateFormatter.string(from: classEndTime ))!
        dateFormatter.dateFormat="mm"
        classInfo["startMin"] = Int(dateFormatter.string(from: classStartTime ))!
        classInfo["endMin"] = Int(dateFormatter.string(from: classEndTime))!
        classList[id] = classInfo
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classList, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "classList")
            userDefaults.synchronize()
        }
        hasPreviousData() ? print("") : print("")
        menuWindow.isHidden = true
    }
    
    func editDeletePressed(id : Int) {
        print(id)
        classList.remove(at: id)
        if id == classList.count {
            print("that was the last guy")
        }
        else if classList.count > 1 {
            for x in id...classList.count-1 {
                var classInfo = classList[x]
                classInfo["id"] = x
                classList[x] = classInfo
            }
        }
        else if classList.count == 1 {
            var classInfo = classList.last!
            classList.removeAll()
            classInfo["id"] = 0
            classList.append(classInfo)
        }
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classList, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "classList")
            userDefaults.synchronize()
        }
        hasPreviousData() ? print("") : print("")
        menuWindow.isHidden = true
    }

    @IBOutlet var helpfulButton: UIButton!
    
    @IBAction func helpfulButtonPressed(_ sender: Any) {
        //menuContainerView.isHidden = !menuContainerView.isHidden
        //if !menuContainerView.isHidden {
            
        //}
    }
    
    @IBAction func addClassStartTimeEditing(_ sender: Any) {
        DispatchQueue.main.async {
            self.addClassBlurView.isHidden = true
            self.addClassStartTextField.endEditing(true)
            self.timeWheelBlurView.isHidden=false
            self.timeWheel.minuteInterval=5
            self.timeWheel.isHidden=false
            self.timeWheelLabel.text = "Class Start Time"
            self.closeIconImageView.isHidden=false
        }
    }
    
    @IBAction func addClassEndTimeEditing(_ sender: Any) {
        DispatchQueue.main.async {
            self.addClassBlurView.isHidden = true
            self.addClassEndTextField.endEditing(true)
            self.timeWheelBlurView.isHidden=false
            self.timeWheel.minuteInterval=5
            self.timeWheel.isHidden=false
            self.timeWheelLabel.text = "Class End Time"
            self.closeIconImageView.isHidden=false
        }
    }
    
    @IBAction func startTimeEditing(_ sender: Any) {
        self.startTimeTextField.endEditing(true)
        self.timeWheelBlurView.isHidden=false
        self.timeWheel.minuteInterval=30
        self.timeWheel.isHidden=false
        self.timeWheelLabel.text = "Start Time"
        self.closeIconImageView.isHidden=false
    }
    
    @IBAction func endTimeEditing(_ sender: Any) {
        self.endTimeTextField.endEditing(true)
        self.timeWheelBlurView.isHidden=false
        self.timeWheel.minuteInterval=30
        self.timeWheel.isHidden=false
        self.timeWheelLabel.text = "End Time"
        self.closeIconImageView.isHidden=false
    }
        
    @IBOutlet var mondayView: UIView!
    
    @IBOutlet var tuesdayView: UIView!
    
    @IBOutlet var wednesdayView: UIView!
    
    @IBOutlet var thursdayView: UIView!
    
    @IBOutlet var fridayView: UIView!
    
    @IBOutlet var timeAxisView: UIView!
    
    @IBOutlet var mondayLongView: UIView!
    
    @IBOutlet var tuesdayLongView: UIView!
    
    @IBOutlet var wednesdayLongView: UIView!
    
    @IBOutlet var thursdayLongView: UIView!
    
    @IBOutlet var fridayLongView: UIView!
    
    @IBOutlet var startTimeTextField: UITextField!
    
    @IBOutlet var endTimeTextField: UITextField!
    
    @IBOutlet var timeWheel: UIDatePicker!
    
    @IBOutlet var timeWheelBlurView: UIVisualEffectView!
    
    @IBOutlet var timeWheelLabel: UILabel!
    
    @IBOutlet var closeIconImageView: UIImageView!
    
    @IBOutlet var addClassBlurView: UIVisualEffectView!
    
    @IBOutlet var addClassNameTextView: UITextField!
    
    @IBAction func addClassNameEntered(_ sender: Any) {
        print("checking for valid class name")
        //else reassign first responder
    }
    
    @IBOutlet var addClassStartTextField: UITextField!
    
    @IBOutlet var addClassEndTextField: UITextField!
    
    @IBOutlet var addClassDayLabel: UILabel!
    
    @IBOutlet var addClassMLabel: UILabel!
    
    @IBOutlet var addClassTLabel: UILabel!
    
    @IBOutlet var addClassWLabel: UILabel!
    
    @IBOutlet var addClassFLabel: UILabel!
    
    @IBOutlet var addClassTHLabel: UILabel!
    
    @IBOutlet var addClassCancelImageView: UIImageView!
    
    @IBOutlet var addClassSaveImageView: UIImageView!
    
    var menuWindow = MenuView()
    
    // Global Vars
    var startHour : Int = 8
    var startMin : Int = 30
    var endHour : Int = 20
    var endMin : Int = 30
    var shouldLayoutTimes = true
    var colorsUnused = [CGColor]()
    var isLinking = false
    
    // let cyan = UIColor(displayP3Red: 255, green: 0, blue: 225/255, alpha: 1).cgColor
    // let yellow = UIColor(displayP3Red: 255, green: 234/255, blue: 0, alpha: 1).cgColor
    // let blue = UIColor(displayP3Red: 0, green: 204/255, blue: 255, alpha: 1).cgColor
    // let orange = UIColor(displayP3Red: 255, green: 85/255, blue: 0, alpha: 1).cgColor
    
    let color1 = UIColor(displayP3Red: 227/255, green: 113/255, blue: 103/255, alpha: 1).cgColor // x-red
    let color2 = UIColor(displayP3Red: 133/255, green: 104/255, blue: 181/255, alpha: 1).cgColor // method-purple
    let color3 = UIColor(displayP3Red: 244/255, green: 170/255, blue: 162/255, alpha: 1).cgColor // swift-orange
    let color4 = UIColor(displayP3Red: 97/255, green: 185/255, blue: 168/255, alpha: 1).cgColor // check-green
    let color5 = UIColor(displayP3Red: 238/255, green: 107/255, blue: 112/255, alpha: 1).cgColor // itunes-red
    let color6 = UIColor(displayP3Red: 171/255, green: 219/255, blue: 253/255, alpha: 1).cgColor // baby-blue
    let color7 = UIColor(displayP3Red: 88/255, green: 140/255, blue: 224/255, alpha: 1).cgColor // blur-blue
    let color8 = UIColor(displayP3Red: 228/255, green: 142/255, blue: 189/255, alpha: 1).cgColor // ipad-pink
    let color9 = UIColor(displayP3Red: 164/255, green: 231/255, blue: 237/255, alpha: 1).cgColor // ipad-teal
    
    
    // Other Colors
    // 227    113    103   x-red
    // 133    104    181   method-purple
    // 244    170    162   swift-orange
    // 97    185    168    check-green
    // 238    107    112   itunes-red
    // 171    219    253   baby-blue
    // 88    140    224    blur-blue
    // 228    142    189   ipad-pink
    // 164    231    237   ipad-teal
    
    
    
    // Global Classlist
    var classList = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addClassBlurView.layer.cornerRadius = 10.0
        addClassBlurView.clipsToBounds = true
        
        self.colorsUnused = [color1, color2, color3, color4, color5, color6, color7, color8, color9]
        
        self.addClassNameTextView.delegate = self
        
        self.closeIconImageView.image = UIImage(named:"cancel.png")
        
        self.addClassCancelImageView.layer.cornerRadius = 8.0
        self.addClassCancelImageView.clipsToBounds = true
        
        self.addClassSaveImageView.layer.cornerRadius = 8.0
        self.addClassSaveImageView.clipsToBounds = true
        
        self.addClassMLabel.layer.cornerRadius = 5.0
        self.addClassMLabel.clipsToBounds = true
        
        self.addClassTLabel.layer.cornerRadius = 5.0
        self.addClassTLabel.clipsToBounds = true
        
        self.addClassWLabel.layer.cornerRadius = 5.0
        self.addClassWLabel.clipsToBounds = true
        
        self.addClassTHLabel.layer.cornerRadius = 5.0
        self.addClassTHLabel.clipsToBounds = true
        
        self.addClassFLabel.layer.cornerRadius = 5.0
        self.addClassFLabel.clipsToBounds = true
        
        let addClassCancelTap = UITapGestureRecognizer(target: self, action: #selector(addClassCancelTapped))
        self.addClassCancelImageView.addGestureRecognizer(addClassCancelTap)
        self.addClassCancelImageView.isUserInteractionEnabled = true
        
        let addClassEnterTap = UITapGestureRecognizer(target: self, action: #selector(addClassEnterTapped))
        self.addClassSaveImageView.addGestureRecognizer(addClassEnterTap)
        self.addClassSaveImageView.isUserInteractionEnabled = true
        
        let addClassMTap = UITapGestureRecognizer(target: self, action: #selector(addClassMTapped))
        self.addClassMLabel.addGestureRecognizer(addClassMTap)
        self.addClassMLabel.isUserInteractionEnabled = true
        
        let addClassTTap = UITapGestureRecognizer(target: self, action: #selector(addClassTTapped))
        self.addClassTLabel.addGestureRecognizer(addClassTTap)
        self.addClassTLabel.isUserInteractionEnabled = true
        
        let addClassWTap = UITapGestureRecognizer(target: self, action: #selector(addClassWTapped))
        self.addClassWLabel.addGestureRecognizer(addClassWTap)
        self.addClassWLabel.isUserInteractionEnabled = true
        
        let addClassTHTap = UITapGestureRecognizer(target: self, action: #selector(addClassTHTapped))
        self.addClassTHLabel.addGestureRecognizer(addClassTHTap)
        self.addClassTHLabel.isUserInteractionEnabled = true
        
        let addClassFTap = UITapGestureRecognizer(target: self, action: #selector(addClassFTapped))
        self.addClassFLabel.addGestureRecognizer(addClassFTap)
        self.addClassFLabel.isUserInteractionEnabled = true
        
        let mondayTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(mondayTapPressed))
        self.mondayView.addGestureRecognizer(mondayTapPressRecognizer)
        self.mondayView.isUserInteractionEnabled = true
        
        let tuesdayTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(tuesdayTapPressed))
        self.tuesdayView.addGestureRecognizer(tuesdayTapPressRecognizer)
        self.tuesdayView.isUserInteractionEnabled = true
        
        let wednesdayTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(wednesdayTapPressed))
        self.wednesdayView.addGestureRecognizer(wednesdayTapPressRecognizer)
        self.wednesdayView.isUserInteractionEnabled = true
        
        let thursdayTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(thursdayTapPressed))
        self.thursdayView.addGestureRecognizer(thursdayTapPressRecognizer)
        self.thursdayView.isUserInteractionEnabled = true
        
        let fridayTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(fridayTapPressed))
        self.fridayView.addGestureRecognizer(fridayTapPressRecognizer)
        self.fridayView.isUserInteractionEnabled = true
        
        self.timeWheelBlurView.layer.cornerRadius = 10.0
        self.timeWheelBlurView.clipsToBounds=true
        
        let cancelTapPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelTapPressed))
        self.closeIconImageView.addGestureRecognizer(cancelTapPressRecognizer)
        self.closeIconImageView.isUserInteractionEnabled = true
        
        //editDeletePressed(id: <#T##Int#>)
    }
    
    override func viewDidLayoutSubviews() {
        
        print("didLayoutSubviews called")
        if shouldLayoutTimes {
            self.layoutScheduleChart()
            self.shouldLayoutTimes = false
            hasPreviousData() ? print(true) : print(false)
            
            
            
            //let editWindow = MenuView(frame: CGRect(x: self.view.center.x-120, y: self.view.center.y-120, width: 240, height: 239))
            menuWindow = MenuView(frame: CGRect(x: self.view.center.x-120, y: self.view.center.y-120, width: 240, height: 239))
            menuWindow.buttonDelegate = self
            menuWindow.isUserInteractionEnabled=true
            menuWindow.contentView.isUserInteractionEnabled=true
            menuWindow.isHidden = true
            self.view.addSubview(menuWindow)
        }
        
    }
    
    func updateUnusedColors() {
        colorsUnused = [color1, color2, color3, color4, color5, color6, color7, color8, color9]
        for classX in classList {
            if let index = colorsUnused.firstIndex(of: (classX["color"] as! UIColor).cgColor) {
                colorsUnused.remove(at: index)
            }
        }
    }
    
    func hasPreviousData () -> Bool {
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            
            if let classListData = userDefaults.object(forKey: "classList") as? Data {
                let classListDecoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(classListData) as! [[String:Any]]
                self.classList = classListDecoded!
                for view in mondayLongView.subviews {
                    view.removeFromSuperview()
                }
                for view in tuesdayLongView.subviews {
                    view.removeFromSuperview()
                }
                for view in wednesdayLongView.subviews {
                    view.removeFromSuperview()
                }
                for view in thursdayLongView.subviews {
                    view.removeFromSuperview()
                }
                for view in fridayLongView.subviews {
                    view.removeFromSuperview()
                }
                for classInfo in classListDecoded! {
                    drawClass(sentInfo: classInfo)
                }
                return true
            }

        }
        return false
    }
    
    func layoutScheduleChart () {
        var numSegments = 2 * (self.endHour - self.startHour)
        numSegments += (self.endMin - self.startMin) / 30
        
        var startOffset = 2 * (self.startHour-8)
        startOffset += (self.startMin-30) / 30
        
        var adjustHour = endHour
        if endHour > 12 {
            adjustHour = endHour - 12
        }
        
        if startMin < 10 {
            self.startTimeTextField.text = String(self.startHour)+":0" + String(self.startMin) + " AM"
        }
        else {
            self.startTimeTextField.text = String(self.startHour)+":"+String(self.startMin) + " AM"
        }
        if endMin < 10 {
            self.endTimeTextField.text = String(adjustHour)+":0" + String(self.endMin) + " PM"
        }
        else {
            self.endTimeTextField.text = String(adjustHour)+":"+String(self.startMin) + " PM"
        }
        
        self.mondayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.tuesdayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.wednesdayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.thursdayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.fridayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.timeAxisView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        for x in 1...numSegments+1 {
            let height = CGFloat((self.mondayLongView.frame.size.height/CGFloat(numSegments+1)) * CGFloat(x))
            let width = self.mondayLongView.frame.size.width+30
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: height))
            path.addLine(to: CGPoint(x: width, y: height))
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.strokeColor = UIColor.white.cgColor// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
            lineLayer.lineWidth = 2
            
            self.mondayLongView.layer.addSublayer(lineLayer)
            
            let path1 = UIBezierPath()
            path1.move(to: CGPoint(x: 0, y: height))
            path1.addLine(to: CGPoint(x: width, y: height))
            
            let lineLayer1 = CAShapeLayer()
            lineLayer1.path = path1.cgPath
            lineLayer1.fillColor = UIColor.clear.cgColor
            lineLayer1.strokeColor = UIColor.white.cgColor// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
            lineLayer1.lineWidth = 2
            
            self.tuesdayLongView.layer.addSublayer(lineLayer1)
            
            let path2 = UIBezierPath()
            path2.move(to: CGPoint(x: 0, y: height))
            path2.addLine(to: CGPoint(x: width, y: height))
            
            let lineLayer2 = CAShapeLayer()
            lineLayer2.path = path1.cgPath
            lineLayer2.fillColor = UIColor.clear.cgColor
            lineLayer2.strokeColor = UIColor.white.cgColor// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
            lineLayer2.lineWidth = 2
            
            self.wednesdayLongView.layer.addSublayer(lineLayer2)
            
            let path3 = UIBezierPath()
            path3.move(to: CGPoint(x: 0, y: height))
            path3.addLine(to: CGPoint(x: width, y: height))
            
            let lineLayer3 = CAShapeLayer()
            lineLayer3.path = path1.cgPath
            lineLayer3.fillColor = UIColor.clear.cgColor
            lineLayer3.strokeColor = UIColor.white.cgColor// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
            lineLayer3.lineWidth = 2
            
            self.thursdayLongView.layer.addSublayer(lineLayer3)
            
            let path4 = UIBezierPath()
            path4.move(to: CGPoint(x: 0, y: height))
            path4.addLine(to: CGPoint(x: width, y: height))
            
            let lineLayer4 = CAShapeLayer()
            lineLayer4.path = path1.cgPath
            lineLayer4.fillColor = UIColor.clear.cgColor
            lineLayer4.strokeColor = UIColor.white.cgColor// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
            lineLayer4.lineWidth = 2
            
            self.fridayLongView.layer.addSublayer(lineLayer4)
            
            let textLayer = CATextLayer()
            textLayer.frame = self.mondayLongView.frame
            textLayer.backgroundColor = UIColor.clear.cgColor
            textLayer.foregroundColor = UIColor.lightGray.cgColor
            textLayer.fontSize = 14
            
            let switchInt = x+startOffset
            
            switch (switchInt) {
            case 1:
                textLayer.string = "8:30"
            case 2:
                textLayer.string = "9:00"
            case 3:
                textLayer.string = "9:30"
            case 4:
                textLayer.string = "10:00"
            case 5:
                textLayer.string = "10:30"
            case 6:
                textLayer.string = "11:00"
            case 7:
                textLayer.string = "11:30"
            case 8:
                textLayer.string = "12:00"
            case 9:
                textLayer.string = "12:30"
            case 10:
                textLayer.string = "1:00"
            case 11:
                textLayer.string = "1:30"
            case 12:
                textLayer.string = "2:00"
            case 13:
                textLayer.string = "2:30"
            case 14:
                textLayer.string = "3:00"
            case 15:
                textLayer.string = "3:30"
            case 16:
                textLayer.string = "4:00"
            case 17:
                textLayer.string = "4:30"
            case 18:
                textLayer.string = "5:00"
            case 19:
                textLayer.string = "5:30"
            case 20:
                textLayer.string = "6:00"
            case 21:
                textLayer.string = "6:30"
            case 22:
                textLayer.string = "7:00"
            case 23:
                textLayer.string = "7:30"
            case 24:
                textLayer.string = "8:00"
            case 25:
                textLayer.string = "8:30"
            default:
                print("f")
            }
            textLayer.alignmentMode = .right
            if (self.view.frame.size.height == 667.0) {
                textLayer.position = CGPoint(x:2,y:height+220)
            }
            else if (self.view.frame.size.height == 736.0) {
                textLayer.position = CGPoint(x:-3,y:height+253)
            }
            else if (self.view.frame.size.height == 568.0) {
                textLayer.position = CGPoint(x:7,y:height+173)
            }
            else if (self.view.frame.size.height == 812.0) {
                textLayer.position = CGPoint(x:2,y:height+261)
            }
            else if (self.view.frame.size.height == 896.0) {
                textLayer.position = CGPoint(x:-2,y:height+301)
            }
            else {
                textLayer.position = CGPoint(x:2,y:height+220)
            }
            
            self.timeAxisView.layer.addSublayer(textLayer)
        }
        
        DispatchQueue.main.async {
            self.view.setNeedsDisplay()
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let count = textField.text?.count {
            if count > 20 {
                self.addClassNameTextView.text = "20 char limit"
            }
        }
        
        return true
    }
    
    
    @objc func addClassMTapped(sender:UITapGestureRecognizer) {
        if self.addClassDayLabel.text == "Monday" {
            return
        }
        if self.addClassMLabel.layer.borderWidth == 0.0 {
            self.addClassMLabel.layer.borderWidth = 2.0
            self.addClassMLabel.layer.borderColor = UIColor.gray.cgColor
        }
        else {
            self.addClassMLabel.layer.borderWidth = 0.0
        }
    }
    
    @objc func addClassTTapped(sender:UITapGestureRecognizer) {
        if self.addClassDayLabel.text == "Tuesday" {
            return
        }
        if self.addClassTLabel.layer.borderWidth == 0.0 {
            self.addClassTLabel.layer.borderWidth = 2.0
            self.addClassTLabel.layer.borderColor = UIColor.gray.cgColor
        }
        else {
            self.addClassTLabel.layer.borderWidth = 0.0
        }
    }
    
    @objc func addClassWTapped(sender:UITapGestureRecognizer) {
        if self.addClassDayLabel.text == "Wednesday" {
            return
        }
        if self.addClassWLabel.layer.borderWidth == 0.0 {
            self.addClassWLabel.layer.borderWidth = 2.0
            self.addClassWLabel.layer.borderColor = UIColor.gray.cgColor
        }
        else {
            self.addClassWLabel.layer.borderWidth = 0.0
        }
    }
    
    @objc func addClassTHTapped(sender:UITapGestureRecognizer) {
        if self.addClassDayLabel.text == "Thursday" {
            return
        }
        if self.addClassTHLabel.layer.borderWidth == 0.0 {
            self.addClassTHLabel.layer.borderWidth = 2.0
            self.addClassTHLabel.layer.borderColor = UIColor.gray.cgColor
        }
        else {
            self.addClassTHLabel.layer.borderWidth = 0.0
        }
    }
    
    @objc func addClassFTapped(sender:UITapGestureRecognizer) {
        if self.addClassDayLabel.text == "Friday" {
            return
        }
        if self.addClassFLabel.layer.borderWidth == 0.0 {
            self.addClassFLabel.layer.borderWidth = 2.0
            self.addClassFLabel.layer.borderColor = UIColor.gray.cgColor
        }
        else {
            self.addClassFLabel.layer.borderWidth = 0.0
        }
    }
    
    @objc func addClassCancelTapped(sender: UITapGestureRecognizer) {
        self.addClassNameTextView.text = ""
        self.addClassStartTextField.text = ""
        self.addClassEndTextField.text = ""
        self.addClassMLabel.layer.borderWidth = 0.0
        self.addClassTLabel.layer.borderWidth = 0.0
        self.addClassWLabel.layer.borderWidth = 0.0
        self.addClassTHLabel.layer.borderWidth = 0.0
        self.addClassFLabel.layer.borderWidth = 0.0
        self.addClassBlurView.isHidden = true
    }
    
    @objc func addClassEnterTapped(sender: UITapGestureRecognizer) {
        // needs to validate all form entries, else mark error
        
        updateUnusedColors()
        
        let nameText = self.addClassNameTextView.text!
        if nameText == "" || nameText == "20 char limit" {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="hh:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        let startText = self.addClassStartTextField.text!
        let endText = self.addClassEndTextField.text!
        if startText == "" || endText == "" {
            return
        }
        if startText == "invalid" || endText == "invalid" {
            return
        }
        
        if !startText.contains("M") {
            dateFormatter.dateFormat="HH:mm"
        }
        
        let classStartTime = dateFormatter.date(from: startText)!
        let classEndTime = dateFormatter.date(from: endText)!
        
//        dateFormatter.dateFormat="hh"
//        var classStartHour = dateFormatter.date(from: startText)!
//        var classEndHour = dateFormatter.date(from: endText)!
//        if classStartHour >= 12 {
//            classStartHour = classStartHour - 12
//        }
//        if classEndHour >= 12 {
//            classEndHour = classEndHour - 12
//        }
        
        if classStartTime > classEndTime {
            self.addClassStartTextField.layer.borderColor = UIColor.red.cgColor
            self.addClassEndTextField.layer.borderColor = UIColor.red.cgColor
            self.addClassStartTextField.layer.borderWidth = 2.0
            self.addClassEndTextField.layer.borderWidth = 2.0
            return
        }
        
        
        var classInfo = [String:Any]()
        dateFormatter.dateFormat="HH"
        classInfo["startHour"] = Int(dateFormatter.string(from: classStartTime))!
        classInfo["endHour"] = Int(dateFormatter.string(from: classEndTime ))!
        dateFormatter.dateFormat="mm"
        classInfo["startMin"] = Int(dateFormatter.string(from: classStartTime ))!
        classInfo["endMin"] = Int(dateFormatter.string(from: classEndTime))!
        
        let startHour = classInfo["startHour"] as! Int
        let endHour = classInfo["endHour"] as! Int
        let startMin = classInfo["startMin"] as! Int
        let endMin = classInfo["endMin"] as! Int
        
        if colorsUnused.count > 0 {
            classInfo["color"] = UIColor(cgColor: colorsUnused.first!)
            colorsUnused.removeFirst()
        }
        else {
            classInfo["color"] = UIColor.red
        }
        
        
        
        // Repeat validation begin
        if self.addClassMLabel.layer.borderWidth == 2.0 {
             for classX in self.classList {
                if classX["day"] as! String == "Monday" {
                    if (startHour > classX["startHour"] as! Int) && (startHour < classX["endHour"] as! Int) {
                         self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                         return
                    }
                    if (startHour == classX["startHour"] as! Int) && (startMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["endHour"] as! Int) && (startMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    
                    
                    if (endHour > classX["startHour"] as! Int) && (endHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["startHour"] as! Int) && (endMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["endHour"] as! Int) && (endMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                }
            }
            classInfo["name"] = nameText
            classInfo["day"] = "Monday"
            classInfo["id"] = classList.count
            self.classList.append(classInfo)
            drawClass(sentInfo: classInfo)
        }
        
        if self.addClassTLabel.layer.borderWidth == 2.0 {
            for classX in self.classList {
                if classX["day"] as! String == "Tuesday" {
                    if (startHour > classX["startHour"] as! Int) && (startHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["startHour"] as! Int) && (startMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["endHour"] as! Int) && (startMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    
                    
                    if (endHour > classX["startHour"] as! Int) && (endHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["startHour"] as! Int) && (endMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["endHour"] as! Int) && (endMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                }
            }
            classInfo["name"] = nameText
            classInfo["day"] = "Tuesday"
            classInfo["id"] = classList.count
            self.classList.append(classInfo)
            drawClass(sentInfo: classInfo)
        }
        
        if self.addClassWLabel.layer.borderWidth == 2.0 {
            for classX in self.classList {
                if classX["day"] as! String == "Wednesday" {
                    if (startHour > classX["startHour"] as! Int) && (startHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["startHour"] as! Int) && (startMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["endHour"] as! Int) && (startMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }

                    
                    if (endHour > classX["startHour"] as! Int) && (endHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["startHour"] as! Int) && (endMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["endHour"] as! Int) && (endMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                }
            }
            classInfo["name"] = nameText
            classInfo["day"] = "Wednesday"
            classInfo["id"] = classList.count
            self.classList.append(classInfo)
            drawClass(sentInfo: classInfo)
        }
        
        if self.addClassTHLabel.layer.borderWidth == 2.0 {
            for classX in self.classList {
                if classX["day"] as! String == "Thursday" {
                    if (startHour > classX["startHour"] as! Int) && (startHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["startHour"] as! Int) && (startMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["endHour"] as! Int) && (startMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    
                    
                    if (endHour > classX["startHour"] as! Int) && (endHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["startHour"] as! Int) && (endMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["endHour"] as! Int) && (endMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                }
            }
            classInfo["name"] = nameText
            classInfo["day"] = "Thursday"
            classInfo["id"] = classList.count
            self.classList.append(classInfo)
            drawClass(sentInfo: classInfo)
        }
        
        if self.addClassFLabel.layer.borderWidth == 2.0 {
            for classX in self.classList {
                if classX["day"] as! String == "Friday" {
                    if (startHour > classX["startHour"] as! Int) && (startHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["startHour"] as! Int) && (startMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (startHour == classX["endHour"] as! Int) && (startMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    
                    
                    if (endHour > classX["startHour"] as! Int) && (endHour < classX["endHour"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["startHour"] as! Int) && (endMin >= classX["startMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                    if (endHour == classX["endHour"] as! Int) && (endMin <= classX["endMin"] as! Int) {
                        self.addClassMLabel.layer.borderColor = UIColor.red.cgColor
                        return
                    }
                }
            }
            classInfo["name"] = nameText
            classInfo["day"] = "Friday"
            classInfo["id"] = classList.count
            self.classList.append(classInfo)
            drawClass(sentInfo: classInfo)
        }
        
        self.addClassNameTextView.text = ""
        self.addClassStartTextField.text = ""
        self.addClassEndTextField.text = ""
        
        self.addClassStartTextField.layer.borderWidth = 0.0
        self.addClassEndTextField.layer.borderWidth = 0.0
        self.addClassBlurView.isHidden = true
        
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            let encodedDic: Data = try! NSKeyedArchiver.archivedData(withRootObject: classList, requiringSecureCoding: false)
            userDefaults.set(encodedDic, forKey: "classList")
            userDefaults.synchronize()
        }
    }
    
    
    func drawClass(sentInfo : Any) {
        
        let classInfo = sentInfo as! [String:Any]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="HH"
        let classStartHour = classInfo["startHour"] as! Int//Int(dateFormatter.string(from: classInfo["start"] as! Date))!
        let classEndHour = classInfo["endHour"] as! Int//Int(dateFormatter.string(from: classInfo["end"] as! Date))!
        dateFormatter.dateFormat="mm"
        let classStartMin = classInfo["startMin"] as! Int//Int(dateFormatter.string(from: classInfo["start"] as! Date))!
        let classEndMin = classInfo["endMin"] as! Int//Int(dateFormatter.string(from: classInfo["end"] as! Date))!

        let dayOffset = 2*CGFloat(self.endHour-self.startHour) + CGFloat(self.endMin-self.startMin)/30
        let classStartOffset = 2*(classStartHour-self.startHour)+(classStartMin - self.startMin)/30
        let classEndOffset = 2*CGFloat(self.endHour-classEndHour)+CGFloat(self.endMin - classEndMin)/30
        let classStartPixel = CGFloat(self.mondayLongView.frame.size.height) * (CGFloat(classStartOffset)/CGFloat(dayOffset+1))
        let classEndPixel = CGFloat(self.mondayLongView.frame.size.height) * (CGFloat(dayOffset-classEndOffset)/CGFloat(dayOffset+1)) // classEndOffset)/CGFloat(dayOffset+1))
        let newHeight = classEndPixel-classStartPixel
        
        let classFrame = ClassView(frame: CGRect(x: 0,y: classStartPixel,width: 73,height: newHeight))
        classFrame.backgroundColor = classInfo["color"] as? UIColor
        classFrame.nameLabel.text = classInfo["name"] as? String
        classFrame.id = classInfo["id"] as! Int
        
        
        classFrame.isUserInteractionEnabled = true
        classFrame.classDelegate = self
        

//        let classFrame = UIView(frame: CGRect(x: 0,y: classStartPixel,width: 73,height: newHeight))
//        classFrame.backgroundColor = classInfo["color"] as? UIColor
//
//        let className = UILabel(frame : CGRect(x: 10,y: 0,width: 100,height: classFrame.frame.size.height))
//        className.numberOfLines = 5
//        className.text = classInfo["name"] as? String
//        classFrame.addSubview(className)
        
//        self.mondayLongView.addSubview(classFrame)
        
        if classInfo["day"] as! String == "Monday" {
            self.mondayLongView.addSubview(classFrame)
        }
        else if classInfo["day"] as! String == "Tuesday" {
            self.tuesdayLongView.addSubview(classFrame)
        }
        else if classInfo["day"] as! String == "Wednesday" {
            self.wednesdayLongView.addSubview(classFrame)
        }
        else if classInfo["day"] as! String == "Thursday" {
            self.thursdayLongView.addSubview(classFrame)
        }
        else if classInfo["day"] as! String == "Friday" {
            self.fridayLongView.addSubview(classFrame)
        }
    }
    
    
    
    @objc func cancelTapPressed(sender: UITapGestureRecognizer) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="HH:mm a"
        dateFormatter.timeStyle = .short
        let fullDateString = dateFormatter.string(from: self.timeWheel!.date)
        
        dateFormatter.dateFormat="HH"
        let shortHourInt = Int(dateFormatter.string(from: self.timeWheel!.date))!
        dateFormatter.dateFormat="mm"
        let shortMinInt = Int(dateFormatter.string(from: self.timeWheel!.date))!
        
        if (self.timeWheelLabel.text == "Start Time") {
            
            if (shortHourInt == 8 && shortMinInt == 30 || shortHourInt >= 9 && shortHourInt < 13) {
                
                DispatchQueue.main.async {
                    self.startTimeTextField.text = fullDateString
                    self.startHour = shortHourInt
                    self.startMin = shortMinInt
                    self.shouldLayoutTimes = true
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
                
            }
            else {
                print("invalid start time")
            }
        }
        else if (self.timeWheelLabel.text == "End Time"){
            if (shortHourInt > 12 && shortHourInt < 21) {
                self.endTimeTextField.text = fullDateString
                self.endHour = shortHourInt
                self.endMin = shortMinInt
                self.shouldLayoutTimes = true
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
            else {
                print("invalid end time")
            }
        }
        else if (self.timeWheelLabel.text == "Class End Time") {
            if shortHourInt == self.startHour && shortMinInt > self.startMin || shortHourInt > self.startHour && shortHourInt <= self.endHour {
                DispatchQueue.main.async {
                    self.addClassEndTextField.text = fullDateString
                }
            }
            else {
                DispatchQueue.main.async {
                    self.addClassEndTextField.text = "invalid"
                }
            }
            DispatchQueue.main.async {
                self.addClassBlurView.isHidden = false
            }
        }
        else if (self.timeWheelLabel.text == "Class Start Time") {
            if shortHourInt == self.startHour && shortMinInt >= self.startMin || shortHourInt > self.startHour && shortHourInt <= self.endHour {
                DispatchQueue.main.async {
                    self.addClassStartTextField.text = fullDateString
                }
            }
            else {
                DispatchQueue.main.async {
                    self.addClassStartTextField.text = "invalid"
                }
            }
            DispatchQueue.main.async {
                self.addClassBlurView.isHidden = false
            }
        }
        else if (self.timeWheelLabel.text == "New Class Start Time") {
            if shortHourInt == self.startHour && shortMinInt >= self.startMin || shortHourInt > self.startHour && shortHourInt <= self.endHour {
                //DispatchQueue.main.async {
                menuWindow.startTextField.text = fullDateString
                //}
            }
            else {
                //DispatchQueue.main.async {
                menuWindow.startTextField.text = "invalid"
                //}
            }
            //DispatchQueue.main.async {
            self.menuWindow.isHidden = false
            //}
        }
        else if (self.timeWheelLabel.text == "New Class End Time") {
            if shortHourInt == self.startHour && shortMinInt >= self.startMin || shortHourInt > self.startHour && shortHourInt <= self.endHour {
                //DispatchQueue.main.async {
                menuWindow.endTextField.text = fullDateString
                //}
            }
            else {
                //DispatchQueue.main.async {
                menuWindow.endTextField.text = "invalid"
                //}
            }
            //DispatchQueue.main.async {
            self.menuWindow.isHidden = false
            //}
        }
        //DispatchQueue.main.async {
        self.timeWheelBlurView.isHidden=true
        //}
    }
    
    @objc func mondayTapPressed(sender: UITapGestureRecognizer) {
        self.addClassDayLabel.text = "Monday"
        self.addClassMLabel.layer.borderColor = UIColor.gray.cgColor
        self.addClassMLabel.layer.borderWidth = 2.0
        self.addClassTLabel.layer.borderWidth = 0.0
        self.addClassWLabel.layer.borderWidth = 0.0
        self.addClassTHLabel.layer.borderWidth = 0.0
        self.addClassFLabel.layer.borderWidth = 0.0
        
        self.addClassBlurView.isHidden=false
        self.addClassNameTextView.becomeFirstResponder()
    }
    
    @objc func tuesdayTapPressed(sender: UITapGestureRecognizer) {
        self.addClassDayLabel.text = "Tuesday"
        self.addClassTLabel.layer.borderColor = UIColor.gray.cgColor
        self.addClassMLabel.layer.borderWidth = 0.0
        self.addClassTLabel.layer.borderWidth = 2.0
        self.addClassWLabel.layer.borderWidth = 0.0
        self.addClassTHLabel.layer.borderWidth = 0.0
        self.addClassFLabel.layer.borderWidth = 0.0
        
        self.addClassBlurView.isHidden=false
        self.addClassNameTextView.becomeFirstResponder()
    }
    
    @objc func wednesdayTapPressed(sender: UITapGestureRecognizer) {
        self.addClassDayLabel.text = "Wednesday"
        self.addClassWLabel.layer.borderColor = UIColor.gray.cgColor
        self.addClassMLabel.layer.borderWidth = 0.0
        self.addClassTLabel.layer.borderWidth = 0.0
        self.addClassWLabel.layer.borderWidth = 2.0
        self.addClassTHLabel.layer.borderWidth = 0.0
        self.addClassFLabel.layer.borderWidth = 0.0
        
        self.addClassBlurView.isHidden=false
        self.addClassNameTextView.becomeFirstResponder()
    }
    
    @objc func thursdayTapPressed(sender: UITapGestureRecognizer) {
        self.addClassDayLabel.text = "Thursday"
        self.addClassTHLabel.layer.borderColor = UIColor.gray.cgColor
        self.addClassMLabel.layer.borderWidth = 0.0
        self.addClassTLabel.layer.borderWidth = 0.0
        self.addClassWLabel.layer.borderWidth = 0.0
        self.addClassTHLabel.layer.borderWidth = 2.0
        self.addClassFLabel.layer.borderWidth = 0.0
      
        self.addClassBlurView.isHidden=false
        self.addClassNameTextView.becomeFirstResponder()
    }
    
    @objc func fridayTapPressed(sender: UITapGestureRecognizer) {
        self.addClassDayLabel.text = "Friday"
        self.addClassFLabel.layer.borderColor = UIColor.gray.cgColor
        self.addClassMLabel.layer.borderWidth = 0.0
        self.addClassTLabel.layer.borderWidth = 0.0
        self.addClassWLabel.layer.borderWidth = 0.0
        self.addClassTHLabel.layer.borderWidth = 0.0
        self.addClassFLabel.layer.borderWidth = 2.0
        
        self.addClassBlurView.isHidden=false
        self.addClassNameTextView.becomeFirstResponder()
    }
    
    
}
