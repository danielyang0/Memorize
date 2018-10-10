//
//  Word.swift
//  Memorize
//
//  Created by 尊 杨 on 5/3/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation
import CoreData


class Word: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    let TOTAL_COUNT = 12
    func getAdate(idx:Int) -> NSDate? {
        if idx == 0 {
            return self.first
        }else if idx == 1 {
            return self.second
        }else if idx == 2 {
            return self.third
        }else if idx == 3 {
            return self.forth
        }else if idx == 4 {
            return self.fifth
        }else if idx == 5 {
            return self.sixth
        }else if idx == 6 {
            return self.seventh
        }else if idx == 7 {
            return self.eighth
        }else if idx == 8 {
            return self.ninth
        }else if idx == 9 {
            return self.tenth
        }else if idx == 10 {
            return self.eleventh
        }else if idx == 11 {
            return self.twelfth
        }else {
            return nil
        }
    }
    
    
    func setADate(date:NSDate, idx:Int){
        if idx == 0 {
            self.first = date
        }else if idx == 1 {
            self.second = date
        }else if idx == 2 {
            self.third = date
        }else if idx == 3 {
            self.forth = date
        }else if idx == 4 {
            self.fifth = date
        }else if idx == 5 {
            self.sixth = date
        }else if idx == 6 {
            self.seventh = date
        }else if idx == 7 {
            self.eighth = date
        }else if idx == 8 {
            self.ninth = date
        }else if idx == 9 {
            self.tenth = date
        }else if idx == 10 {
            self.eleventh = date
        }else if idx == 11 {
            self.twelfth = date
        }else {
            return
        }
    }
    
    func setADateMoveForward(date:NSDate) {
        self.setADate(date, idx: Int(self.index!))
        let presentIndex = Int(self.index!)
        if presentIndex < TOTAL_COUNT {
            self.index = NSNumber(integer: presentIndex + 1 )
        }
    }
    
    
    func moveIndexBackward() {
        let idx = Int(self.index!)
        if idx > 0 {
            self.index = NSNumber(integer: idx-1)
        }
    }
    
    func setDates(dates:[NSDate?]) {
        self.first = dates[0]
        self.second = dates[1]
        self.third = dates[2]
        self.forth = dates[3]
        self.fifth = dates[4]
        self.sixth = dates[5]
        self.seventh = dates[6]
        self.eighth = dates[7]
        self.ninth = dates[8]
        self.tenth = dates[9]
        self.eleventh = dates[10]
        self.twelfth = dates[11]
        //        self.index = NSNumber(integer: idx)
    }
    
    func getHasDates() -> [NSDate?]{
        
        var dates = [NSDate?]()
        var idx = Int(self.index!)
        
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.first!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.second!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.third!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.forth!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.fifth!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.sixth!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.seventh!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.eighth!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.ninth!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.tenth!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.eleventh!)
        if idx == 0 {
            return dates
        }
        idx -= 1
        dates.append(self.twelfth!)
        return dates
        
    }
    

}
