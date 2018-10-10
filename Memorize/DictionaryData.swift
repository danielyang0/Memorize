//
//  DictionaryData.swift
//  Memorize
//
//  Created by Daniel Yang on 5/14/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class DictionaryData: NSObject, NSCoding {
    
    var lookedUpHistory: [String]
    var lookedUpHistoryIndex: Int
    var lookedUpHistoryIndexLimit: Int = 1000
    
 
    
    init (lookedUpHistory history: [String], lookedUpHistoryIndex index: Int ) {
        self.lookedUpHistory = history
        self.lookedUpHistoryIndex = index
    }
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.lookedUpHistory, forKey: "lookedUpHistory")
        aCoder.encodeObject(self.lookedUpHistoryIndex, forKey: "lookedUpHistoryIndex")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storedLookedUpHistory = aDecoder.decodeObjectForKey("lookedUpHistory") as? [String]
        let storedLookedUpHistoryIndex = aDecoder.decodeObjectForKey("lookedUpHistoryIndex") as? Int
        guard storedLookedUpHistory != nil && storedLookedUpHistoryIndex != nil else {
            return nil
        }
        self.init(lookedUpHistory: storedLookedUpHistory!, lookedUpHistoryIndex: storedLookedUpHistoryIndex!)
    }
    
    
    func clearExceptCurrentOne() {
        if self.lookedUpHistory.count > 0 {
            lookedUpHistory = [lookedUpHistory[lookedUpHistoryIndex]]
            lookedUpHistoryIndex = 0
        }
        
    }
    
    func moveLookedUpHistoryIndexForward() -> Bool {
        if lookedUpHistory.count == 0 {
            return false
        }
        if lookedUpHistoryIndex == lookedUpHistory.count - 1 {
            return false
        }else {
            self.lookedUpHistoryIndex += 1
            return true
        }
    }
    
    func moveLookedUpHistoryIndexBackward() -> Bool {
        if lookedUpHistoryIndex == 0 {
            return false
        }else {
            self.lookedUpHistoryIndex -= 1
            return true
        }
    }
    
    //add a new word, then move index to the end
    func addANewWordTolookedUpHistory(word: String) {
        if lookedUpHistory.count == lookedUpHistoryIndexLimit{
            lookedUpHistory.removeAtIndex(0)
        }
        lookedUpHistory.append(word)
        lookedUpHistoryIndex = lookedUpHistory.count - 1
    }
    
    //get the history word at the current index
    func showLookedUpHistoryAtIndex() -> String? {
        if lookedUpHistory.count == 0 {
            return nil
        }else{
            return lookedUpHistory[lookedUpHistoryIndex]
        }
    }
    
    //when user press << button, change index and show the word at the new index.
    func historyBackAndShow() -> String? {
        if moveLookedUpHistoryIndexBackward() {
            return showLookedUpHistoryAtIndex()
        }else {
            return nil
        }
        
    }
    
    //when user press >> button, change index and show the word at the new index.
    func historyForwardAndShow() -> String? {
        if moveLookedUpHistoryIndexForward() {
            return showLookedUpHistoryAtIndex()
        }else{
            return nil
        }
        
    }
    
    //delete all the dictionary data after current index
    func removeDicDataAfterwards() {
        if lookedUpHistory.count > 1 && lookedUpHistoryIndex < lookedUpHistory.count - 1 {
            let newLookedUpHistory = lookedUpHistory[0...lookedUpHistoryIndex]
            self.lookedUpHistory = Array(newLookedUpHistory)
        }
        
    }
}
