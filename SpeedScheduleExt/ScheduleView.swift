//
//  ScheduleView.swift
//  SpeedScheduleExt
//
//  Created by Rolf Locher on 2/24/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import UIKit

class ScheduleView: UIView {

    @IBOutlet var contentView: ScheduleView!
    
    @IBOutlet var mondayLongView: UIView!
    
    @IBOutlet var tuesdayLongView: UIView!
    
    @IBOutlet var wednesdayLongView: UIView!
    
    @IBOutlet var thursdayLongView: UIView!
    
    @IBOutlet var fridayLongView: UIView!
    
    
    
    var startHour = 8
    var startMin = 30
    var endHour = 20
    var endMin = 30
    
    var height : CGFloat = 400.0
    var width : CGFloat = 74.0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ScheduleView", owner: self, options: nil)
        contentView.fixInView(self)
    }
    
    func drawClasses (classList : [[String:Any]]) {
        
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
        
//        print("scheduleview thinks width is \(self.mondayLongView.frame.width)")
        print("scheduleview thinks width is \(width)")
        
        for classInfo in classList {
            
            let classStartHour = classInfo["startHour"] as! Int
            let classStartMin = classInfo["startMin"] as! Int
            let classEndHour = classInfo["endHour"] as! Int
            let classEndMin = classInfo["endMin"] as! Int
            
            let dayOffset = 2*CGFloat(self.endHour-self.startHour) + CGFloat(self.endMin-self.startMin)/30
            let classStartOffset = 2*(classStartHour-self.startHour)+(classStartMin - self.startMin)/30
            let classEndOffset = 2*CGFloat(self.endHour-classEndHour)+CGFloat(self.endMin - classEndMin)/30
            let classStartPixel = CGFloat(self.height) * (CGFloat(classStartOffset)/CGFloat(dayOffset))
            let classEndPixel = CGFloat(self.height) * (CGFloat(dayOffset-classEndOffset)/CGFloat(dayOffset)) // classEndOffset)/CGFloat(dayOffset+1))
            let newHeight = classEndPixel-classStartPixel
            
//            let classFrame = ClassView(frame: CGRect(x: 0,y: classStartPixel, width: self.mondayLongView.frame.size.width,height: newHeight))
            let classFrame = ClassView(frame: CGRect(x: 0,y: classStartPixel, width: width,height: newHeight))
            classFrame.backgroundColor = classInfo["color"] as? UIColor
            classFrame.nameLabel.text = classInfo["name"] as? String
            classFrame.id = classInfo["id"] as! Int
            
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
        for views in mondayLongView.subviews {
            //let equalWidthConstraint = NSLayoutConstraint(item: views, attribute: .width, relatedBy: .equal, toItem: mondayLongView, attribute: .width, multiplier: 1, constant: 0)
            //mondayLongView.addConstraint(equalWidthConstraint)
            //views.translatesAutoresizingMaskIntoConstraints = true
            views.widthAnchor.constraint(equalTo: mondayLongView.widthAnchor)
            mondayLongView.layoutIfNeeded()
        }
    }
    
    func drawLines () {
        self.mondayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.tuesdayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.wednesdayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.thursdayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.fridayLongView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        var numSegments = 2 * (self.endHour - self.startHour)
        numSegments += (self.endMin - self.startMin) / 30
        print("scheduleview drawing lines, thinks height is \(self.height)")
        
        for x in 1...numSegments+1 {
            if x % 2 == 1 {
                
                let height = CGFloat((self.height/CGFloat(numSegments+1)) * CGFloat(x))
                let width = self.mondayLongView.frame.size.width+30
                
//                if x == 1 {
//                    print("lines: ")
//                    print(height)
//                }
                
                let path = UIBezierPath()
                path.move(to: CGPoint(x: 0, y: height))
                path.addLine(to: CGPoint(x: width, y: height))
                
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.fillColor = UIColor.clear.cgColor
                lineLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07)
                lineLayer.lineWidth = 2
                
                self.mondayLongView.layer.addSublayer(lineLayer)
                
                let path1 = UIBezierPath()
                path1.move(to: CGPoint(x: 0, y: height))
                path1.addLine(to: CGPoint(x: width, y: height))
                
                let lineLayer1 = CAShapeLayer()
                lineLayer1.path = path1.cgPath
                lineLayer1.fillColor = UIColor.clear.cgColor
                lineLayer1.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07)// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
                lineLayer1.lineWidth = 2
                
                self.tuesdayLongView.layer.addSublayer(lineLayer1)
                
                let path2 = UIBezierPath()
                path2.move(to: CGPoint(x: 0, y: height))
                path2.addLine(to: CGPoint(x: width, y: height))
                
                let lineLayer2 = CAShapeLayer()
                lineLayer2.path = path1.cgPath
                lineLayer2.fillColor = UIColor.clear.cgColor
                lineLayer2.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07)// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
                lineLayer2.lineWidth = 2
                
                self.wednesdayLongView.layer.addSublayer(lineLayer2)
                
                let path3 = UIBezierPath()
                path3.move(to: CGPoint(x: 0, y: height))
                path3.addLine(to: CGPoint(x: width, y: height))
                
                let lineLayer3 = CAShapeLayer()
                lineLayer3.path = path1.cgPath
                lineLayer3.fillColor = UIColor.clear.cgColor
                lineLayer3.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07)// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
                lineLayer3.lineWidth = 2
                
                self.thursdayLongView.layer.addSublayer(lineLayer3)
                
                let path4 = UIBezierPath()
                path4.move(to: CGPoint(x: 0, y: height))
                path4.addLine(to: CGPoint(x: width, y: height))
                
                let lineLayer4 = CAShapeLayer()
                lineLayer4.path = path1.cgPath
                lineLayer4.fillColor = UIColor.clear.cgColor
                lineLayer4.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.07)// #colorLiteral(red: 0.2784313725, green: 0.5411764706, blue: 0.7333333333, alpha: 1).cgColor
                lineLayer4.lineWidth = 2
                
                self.fridayLongView.layer.addSublayer(lineLayer4)
            }
        }
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
