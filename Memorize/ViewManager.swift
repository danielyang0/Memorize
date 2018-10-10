//
//  ViewManager.swift
//  Memorize
//
//  Created by Daniel Yang on 5/10/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ViewManager {
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    var fetchedResultsController: NSFetchedResultsController!
    var earlistDueDate:NSDate?
    
    
    
    var fetchedOldWordsResultsController: NSFetchedResultsController!
    var fetchedNewWordsResultsController: NSFetchedResultsController!
    var fetchedSearchResultsController: NSFetchedResultsController!
    
    var numberOfRowsInSection: Int!
    var recordsDisplayOrder = 1 // 0: normal order，1:reverese order(default)
    
    func retrieveData() {
        self.fetchedNewWordsResultsController = self.appDelegate.dataController.getNewWords()
        self.fetchedOldWordsResultsController = self.appDelegate.dataController.getNonNewWords()
    }
    
    // 1:the words that are being memorized; 2: new words
    var whichView = Views.oldWords
    var lastWhichView = Views.oldWords
    enum Views {
        case oldWords
        case newWords
        case search
        case records
        case memorizedHistory
    }
    
    
    
    func updateEarlistDueDate(theDate: NSDate) {
        if self.earlistDueDate == nil {
            self.earlistDueDate = theDate
        }else {
            if before(theDate, date2: self.earlistDueDate!) {
                self.earlistDueDate = theDate
            }
        }
    }
    
    func setEarlistDueDateOnlyOnce(theDate: NSDate) {
        if self.earlistDueDate == nil {
            self.earlistDueDate = theDate
        }
    }
    
    
    var resultSectionCount: Int {
        get {
            if self.whichView == Views.records {
                return 1
            }
            return self.fetchedResultsController.sections!.count
        }
    }
    
    
    func getNumberOfRowsInSection(section: Int) -> Int {
        if self.whichView == Views.records {
            self.numberOfRowsInSection = appDelegate.recordWordsGroups.getWordsCountAtCurrentIndex()
            return self.numberOfRowsInSection
        }else if self.whichView == Views.memorizedHistory {
            self.numberOfRowsInSection = appDelegate.memorizedWords.count
            return self.numberOfRowsInSection
        }
        self.numberOfRowsInSection = self.fetchedResultsController.sections![section].numberOfObjects
        return self.numberOfRowsInSection
    }
    
    
    func getRowsCount() -> Int {
        if self.whichView == Views.records {
            return appDelegate.recordWordsGroups.getWordsCountAtCurrentIndex()
        }else if self.whichView == Views.memorizedHistory {
            return appDelegate.memorizedWords.count
        }else {
            return self.getNumberOfRowsInSection(0)
        }
    }
    
    
    func dueWordsCount() -> Int {
        var dueCount = 0
        let count = fetchedOldWordsResultsController.sections![0].numberOfObjects
        for(var i = 0; i<count; i++){
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            let word = self.fetchedOldWordsResultsController.objectAtIndexPath(indexPath) as! Word
            if Int(word.next!.timeIntervalSinceDate(NSDate())) <= 0 {
                dueCount++
            }else{
                break
            }
        }
        return dueCount
    }
    
    func getNavigationTitle() -> String {
        if whichView == Views.newWords {
            return "N: " + String(getRowsCount())// new words
        }else if whichView == Views.oldWords {
            return "L " + String(getRowsCount()) + "-" + String(dueWordsCount()) //List of word in the process of memorizing
        }else if whichView == Views.search {
            return "F: " + String(getRowsCount()) //found
        }else if whichView == Views.records {
            let title = appDelegate.recordWordsGroups.getGroupTitle()
            let range=Range<String.Index>(start: title.startIndex.advancedBy(0), end: title.startIndex.advancedBy(1))
            return "R/" + title.substringWithRange(range) + ": " + String(getRowsCount()) //records
        }else if whichView == Views.memorizedHistory {
            return "M: " + String(getRowsCount()) //records
        }else {
            return ""
        }
    }
    
    
    func prepareDisplay() {
        if whichView == Views.newWords {
            self.fetchedResultsController = self.fetchedNewWordsResultsController
        }else if whichView == Views.oldWords{
            self.earlistDueDate = nil
            self.fetchedResultsController = self.fetchedOldWordsResultsController
        }else if whichView == Views.search {
            self.fetchedResultsController =  self.fetchedSearchResultsController
        }
    }
    
    func switchButtonPressed() {
        if self.whichView == Views.oldWords {
            self.whichView = Views.newWords
        }else if self.whichView == Views.newWords {
            self.whichView = Views.oldWords
        }else if self.whichView == Views.search {
            self.whichView = self.lastWhichView
        }else if whichView == Views.records {
            whichView = lastWhichView
        }else if whichView == Views.memorizedHistory {
            whichView = lastWhichView
        }
    }
    
    
    
    func wordAtIndexPath(indexPath: NSIndexPath) -> Word {
        var word: Word
        if self.whichView == Views.records {
            let wordString: String
            if self.recordsDisplayOrder == 0 {
                wordString = self.appDelegate.recordWordsGroups.getWordsGroup()[indexPath.row]
            }else{
                wordString = self.appDelegate.recordWordsGroups.getWordsGroup()[self.numberOfRowsInSection-1-indexPath.row]
            }
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let matchResultController = appDelegate.dataController.matchAWord(wordString)
            word = matchResultController.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! Word
        }else if self.whichView == Views.memorizedHistory {
            let wordString: String
            wordString = self.appDelegate.memorizedWords[self.numberOfRowsInSection-1-indexPath.row]
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let matchResultController = appDelegate.dataController.matchAWord(wordString)
            word = matchResultController.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! Word
        }else{
            word = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Word
        }
        return word
    }
    
    
    //return ture when date1 is prior to date2
    func before(date1:NSDate,date2:NSDate) -> Bool {
        let result:NSComparisonResult = date1.compare(date2)
        if result == NSComparisonResult.OrderedDescending{
            return false
        }
        return true
    }
    
    func deleteStringFromRecords(string:String){
        let originalWordsGroup = appDelegate.recordWordsGroups.getWordsGroup()
        appDelegate.recordWordsGroups.setWordsGroup(originalWordsGroup.filter(){ $0 != string })
    }
    
    func clearRecords() {
        appDelegate.recordWordsGroups.clearWordsGroup()
    }
    
    
}