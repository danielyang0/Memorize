//
//  RecordWordsGroups.swift
//  Memorize
//
//  Created by Daniel Yang on 6/3/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation
import UIKit

class RecordWordsGroups: NSObject, NSCoding {
    var recordsWordsLineUp: [[String]]
    
    var groupIndex:Int
    var groupTitles: [String]
    
    init (recordsWordsLineUp lineup: [[String]], groupIndex index: Int, groupTitles titles: [String]) {
        self.recordsWordsLineUp = lineup
        self.groupIndex = index
        self.groupTitles = titles
    }
    
    func getWordsCountAtCurrentIndex() -> Int {
        return self.recordsWordsLineUp[groupIndex].count
    }
    
    func getWordsGroup() -> [String] {
        return self.recordsWordsLineUp[self.groupIndex]
    }
    
    func getGroupTitle() -> String {
        return self.groupTitles[groupIndex]
    }
    
    func moveIndexForward() {
        let count = self.recordsWordsLineUp.count
        groupIndex = (groupIndex + 1) % count
    }
    
    func clearWordsGroup() {
        if self.getGroupTitle() == "default" {
            self.setWordsGroup([String]())
        }else{
            self.removeCurrentGroup()
            self.removeCurrentTitle()
            if groupIndex >= recordsWordsLineUp.count {
                groupIndex = 0
            }
        }
        
    }
    
    func removeCurrentGroup() {
        recordsWordsLineUp.removeAtIndex(self.groupIndex)
    }
    func removeCurrentTitle() {
        groupTitles.removeAtIndex(self.groupIndex)
    }
    
    func setWordsGroup(wordsGroup: [String]) {
        self.recordsWordsLineUp[self.groupIndex] = wordsGroup
    }
    
    func addWordToCurrentGroup(word: String) {
        self.recordsWordsLineUp[self.groupIndex].append(word)
    }
    
    func addWordListToCurrentGroup(wordList: [String]) {
        addWordListToGroupAtIndex(wordList, index: self.groupIndex)
    }
    
    func addWordListToGroupAtIndex(wordList: [String], index: Int) {
        let indexGroup = self.recordsWordsLineUp[index]
        let filtered = wordList.filter { !indexGroup.contains($0) }
        self.recordsWordsLineUp[index] += filtered
    }
    
    func insertAnEmptyNewGroup(title: String) {
        recordsWordsLineUp.append([String]())
        groupTitles.append(title)
    }
    
    func addWordListAsAGroup(wordList: [String], title: String) {
        let indexOfTitle = groupTitles.indexOf(title)
        if indexOfTitle == nil {
            //new group
            insertAnEmptyNewGroup(title)
            addWordListToGroupAtIndex(wordList, index: recordsWordsLineUp.count-1)
        }else{
            addWordListToGroupAtIndex(wordList, index: indexOfTitle!)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.recordsWordsLineUp, forKey: "recordsWordsLineUp")
        aCoder.encodeObject(self.groupIndex, forKey: "groupIndex")
        aCoder.encodeObject(self.groupTitles, forKey: "groupTitles")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storedLineup = aDecoder.decodeObjectForKey("recordsWordsLineUp") as? [[String]]
        let storedIndex = aDecoder.decodeObjectForKey("groupIndex") as? Int
        let storedTitles = aDecoder.decodeObjectForKey("groupTitles") as? [String]
        
        guard storedLineup != nil else {
            return nil
        }
        self.init(recordsWordsLineUp: storedLineup!, groupIndex: storedIndex!, groupTitles: storedTitles!)
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
        //to do:
        recordsWordsLineUp[groupIndex] = recordsWordsLineUp[groupIndex].filter { !oldWordsStringList.contains($0) }
    }
}