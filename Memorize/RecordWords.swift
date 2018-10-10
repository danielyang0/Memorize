//
//  RecordWords.swift
//  Memorize
//
//  Created by Daniel Yang on 5/14/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation
import UIKit

class RecordWords: NSObject, NSCoding {
    var recordsWordsLineUp: [String]
    
    init (recordsWordsLineUp lineup: [String]) {
        self.recordsWordsLineUp = lineup
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.recordsWordsLineUp, forKey: "recordsWordsLineUp")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storedLineup = aDecoder.decodeObjectForKey("recordsWordsLineUp") as? [String]
        
        guard storedLineup != nil else {
            return nil
        }
        self.init(recordsWordsLineUp: storedLineup!)
    }
    
    func deleteOldWords() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let fetchedResultsController = appDelegate.dataController.getNonNewWords()
        let count = fetchedResultsController.sections![0].numberOfObjects
        var oldWordsStringList = [String]()
        for(var i=0;i<count;i++){
            let word = fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! Word
            oldWordsStringList.append(word.spell!)
        }
        recordsWordsLineUp = recordsWordsLineUp.filter { !oldWordsStringList.contains($0) }
    }
}