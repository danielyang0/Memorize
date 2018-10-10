//
//  Ebbin.swift
//  Memorize
//
//  Created by 尊 杨 on 5/2/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class Ebbin {
//    let gap12 = 5 * 60
//    let gap23 = 30 * 60
//    let gap34 = 60 * 60
//    let gap45 = 12 * 60 * 60
//    let gap56 = 1 * 24 * 60 * 60
//    let gap67 = 2 * 24 * 60 * 60
//    let gap78 = 4 * 24 * 60 * 60
//    let gap89 = 8 * 24 * 60 * 60
//    let gap90 = 15 * 24 * 60 * 60
//    let gap101 = 30 * 24 * 60 * 60
//    let gap112 = 60 * 24 * 60 * 60
    let minu = 60
    let hour = 3600
    let day = 86400
    var schedule:[NSDate?]
    var delta:[Int]
    
    let TOTAL = 12
    
    init (original: [NSDate?]) {
//        self.delta = [0,5*minu,30*minu,1*hour,12*hour,1*day,2*day,4*day,7*day,15*day,30*day,60*day]
//        self.delta = [0,5*minu,30*minu,6*hour,12*hour,1*day,2*day,4*day,7*day,15*day,30*day,60*day]
        self.delta = [0,30*minu,6*hour,12*hour,1*day,2*day,4*day,7*day,15*day,30*day,45*day,60*day]
        let deltaCount = self.delta.count
        var newSchedule = original
        if newSchedule.count == 0 {
//            newSchedule.append(NSDate())
//            print("addFirst "+NSDate().description)
            for(var i=0;i<TOTAL;i++) {
                newSchedule.append(nil)
            }
            self.schedule = newSchedule
            return
        }
        
        let startIndex = newSchedule.count
        
        if startIndex < deltaCount {
            for(var i = startIndex; i < deltaCount; i++){
                let lastOne = newSchedule[i-1]
//                let lo = lastOne.description
                let newDate = NSDate(timeInterval: Double(self.delta[i]), sinceDate: lastOne!)
//                let st = newDate.description
                newSchedule.append(newDate)
            }
        }
        self.schedule = newSchedule
        
//        for (var i = 0; i<newSchedule.count; i++) {
//            print(newSchedule[i].description)
//        }
    }
    
    
//    static func test1() {
//        let now = NSDate()
//        let original = [now, NSDate(timeInterval:10,sinceDate: now) ]
//        Ebbin(original: original)
//    }
//    
//    static func test2() {
//        let now = NSDate()
//        let original = [NSDate]()
//        Ebbin(original: original)
//    }
    
}
