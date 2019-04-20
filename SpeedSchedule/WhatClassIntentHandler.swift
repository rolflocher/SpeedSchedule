//
//  WhatClassIntentHandler.swift
//  SpeedSchedule
//
//  Created by Rolf Locher on 3/9/19.
//  Copyright © 2019 Rolf Locher. All rights reserved.
//

import Foundation
import Intents

class WhatClassIntentHandler: NSObject, WhatClassIntentHandling {
    
    var classListGlobal = [[String:Any]]()
    
    func confirm(intent: WhatClassIntent, completion: @escaping (WhatClassIntentResponse) -> Void) {
        
        completion(WhatClassIntentResponse(code: .ready, userActivity: nil))
        
    }
    
    func handle(intent: WhatClassIntent, completion: @escaping (WhatClassIntentResponse) -> Void) {
        
        var responseStringForm = ""
        
        if true {//hasPreviousData() {
            
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let day = calendar.component(.weekday, from: date)
            
            var nextClass = [String:Any]()
//            nextClass["startHour"] = 24
//            nextClass["startMin"] = 59
//            nextClass["day"] = "Friday"
            var nextClassTime = 10000
            
            let adjustedTimeNow = 60*24*(day-1)+60*hour+minutes
            
            var classList = [[String:Any]]()
            var classInfo = [String:Any]()
            classInfo["name"] = "CPE II"
            classInfo["startHour"] = 8
            classInfo["startMin"] = 30
            classInfo["endHour"] = 9
            classInfo["endMin"] = 20
            classInfo["day"] = "Monday"
            classInfo["room"] = "Tolentine 305"
            classInfo["id"] = 9345
            //classInfo["color"] = colorList.first!
            classList.append(classInfo)
            
            classInfo["name"] = "CPE II"
            classInfo["start"] = 30
            classInfo["startHour"] = 8
            classInfo["startMin"] = 30
            classInfo["endHour"] = 9
            classInfo["endMin"] = 20
            classInfo["day"] = "Wednesday"
            classInfo["room"] = "Tolentine 305"
            classInfo["id"] = 9346
            //classInfo["color"] = colorList.first!
            classList.append(classInfo)
            
            classInfo["name"] = "CPE II"
            classInfo["startHour"] = 8
            classInfo["startMin"] = 30
            classInfo["endHour"] = 9
            classInfo["endMin"] = 20
            classInfo["day"] = "Friday"
            classInfo["room"] = "Tolentine 305"
            classInfo["id"] = 9347
            //classInfo["color"] = colorList.removeFirst()
            classList.append(classInfo)
            
            classInfo["name"] = "Computer Networks"
            classInfo["startHour"] = 13
            classInfo["startMin"] = 30
            classInfo["endHour"] = 14
            classInfo["endMin"] = 45
            classInfo["day"] = "Monday"
            classInfo["room"] = "CEER 001"
            classInfo["id"] = 9348
            //classInfo["color"] = colorList.first!
            classList.append(classInfo)
            
            classInfo["name"] = "Computer Networks"
            classInfo["startHour"] = 13
            classInfo["startMin"] = 30
            classInfo["endHour"] = 14
            classInfo["endMin"] = 45
            classInfo["day"] = "Wednesday"
            classInfo["room"] = "CEER 001"
            classInfo["id"] = 9349
            //classInfo["color"] = colorList.removeFirst()
            classList.append(classInfo)
            
            classInfo["name"] = "Design Seminar"
            classInfo["startHour"] = 9
            classInfo["startMin"] = 0
            classInfo["endHour"] = 11
            classInfo["endMin"] = 20
            classInfo["day"] = "Tuesday"
            classInfo["room"] = "CEER 001"
            classInfo["id"] = 9350
            //classInfo["color"] = colorList.removeFirst()
            classList.append(classInfo)
            
            classInfo["name"] = "Compiler Construction"
            classInfo["startHour"] = 11
            classInfo["startMin"] = 30
            classInfo["endHour"] = 12
            classInfo["endMin"] = 45
            classInfo["day"] = "Tuesday"
            classInfo["room"] = "Mendel 290"
            classInfo["id"] = 9351
            //classInfo["color"] = colorList.first!
            classList.append(classInfo)
            
            classInfo["name"] = "Compiler Construction"
            classInfo["startHour"] = 11
            classInfo["startMin"] = 30
            classInfo["endHour"] = 12
            classInfo["endMin"] = 45
            classInfo["day"] = "Thursday"
            classInfo["room"] = "Mendel 290"
            classInfo["id"] = 9352
            //classInfo["color"] = colorList.removeFirst()
            classList.append(classInfo)
            
            classInfo["name"] = "Discrete Structures"
            classInfo["startHour"] = 13
            classInfo["startMin"] = 30
            classInfo["endHour"] = 15
            classInfo["endMin"] = 45
            classInfo["day"] = "Tuesday"
            classInfo["room"] = "Mendel 290"
            classInfo["id"] = 9353
            //classInfo["color"] = colorList.first!
            classList.append(classInfo)
            
            classInfo["name"] = "Discrete Structures"
            classInfo["startHour"] = 13
            classInfo["startMin"] = 30
            classInfo["endHour"] = 15
            classInfo["endMin"] = 45
            classInfo["day"] = "Thursday"
            classInfo["room"] = "Mendel 290"
            classInfo["id"] = 9354
            //classInfo["color"] = colorList.removeFirst()
            classList.append(classInfo)
            
            classInfo["name"] = "Computer Networks Lab"
            classInfo["startHour"] = 16
            classInfo["startMin"] = 30
            classInfo["endHour"] = 18
            classInfo["endMin"] = 30
            classInfo["day"] = "Tuesday"
            classInfo["room"] = "Tolentine 208"
            classInfo["id"] = 9355
            //classInfo["color"] = classList[3]["color"] as! UIColor
            classList.append(classInfo)
            
            classInfo["name"] = "CPE II Lab"
            classInfo["startHour"] = 17
            classInfo["startMin"] = 30
            classInfo["endHour"] = 20
            classInfo["endMin"] = 20
            classInfo["day"] = "Wednesday"
            classInfo["room"] = "CEER 206"
            classInfo["id"] = 9356
            //classInfo["color"] = classList[1]["color"] as! UIColor
            classList.append(classInfo)
            classListGlobal = classList
            
            for classX in classListGlobal {
                var adjustedStartTime = 60*(classX["startHour"] as! Int)+(classX["startMin"] as! Int)
                if (classX["day"] as! String) == "Monday" {
                    adjustedStartTime += 24*60
                }
                else if (classX["day"] as! String) == "Tuesday" {
                    adjustedStartTime += 24*60*2
                }
                else if (classX["day"] as! String) == "Wednesday" {
                    adjustedStartTime += 24*60*3
                }
                else if (classX["day"] as! String) == "Thursday" {
                    adjustedStartTime += 24*60*4
                }
                else if (classX["day"] as! String) == "Friday" {
                    adjustedStartTime += 24*60*5
                }
                
                if adjustedStartTime > adjustedTimeNow && adjustedStartTime < nextClassTime {
                    nextClass = classX
                    nextClassTime = adjustedStartTime
                }
            }
            
            if nextClassTime == 10000 {
                for classX in classListGlobal {
                    var adjustedStartTime = 60*(classX["startHour"] as! Int)+(classX["startMin"] as! Int)
                    if (classX["day"] as! String) == "Monday" {
                        adjustedStartTime += 24*60
                    }
                    else if (classX["day"] as! String) == "Tuesday" {
                        adjustedStartTime += 24*60*2
                    }
                    else if (classX["day"] as! String) == "Wednesday" {
                        adjustedStartTime += 24*60*3
                    }
                    else if (classX["day"] as! String) == "Thursday" {
                        adjustedStartTime += 24*60*4
                    }
                    else if (classX["day"] as! String) == "Friday" {
                        adjustedStartTime += 24*60*5
                    }
                    
                    if adjustedStartTime < nextClassTime {
                        nextClass = classX
                        nextClassTime = adjustedStartTime
                    }
                }
            }
            
            responseStringForm += "Your next class is "
            
            
            
            if classListGlobal.count == 0 {
                responseStringForm = "You have no classes scheduled."
            }
            else {
                responseStringForm += nextClass["name"] as! String + ", "
                responseStringForm += "at " + String(nextClass["startHour"] as! Int) + ":"
                responseStringForm += String(nextClass["startMin"] as! Int)
            }
            
        }
//        else {
//            responseStringForm = "I Could not find your class list."
//        }
        
        
        completion(WhatClassIntentResponse.success(responseString: responseStringForm))
        
    }
    
    func hasPreviousData() -> Bool {
        if let userDefaults = UserDefaults(suiteName: "group.rlocher.schedule") {
            
            if let classListData = userDefaults.object(forKey: "classList") as? Data {
                let classListDecoded = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(classListData) as! [[String:Any]]
                
                classListGlobal = classListDecoded!
                return true
            }
            else {
                print("couldn't find classList")
                return false
            }
        }
        else {
            print("couldn't find group")
            return false
        }
        
    }
}
