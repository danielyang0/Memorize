//
//  DefinationNScodingHelper.swift
//  Memorize
//
//  Created by Daniel Yang on 5/12/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class DefinationHelper {
    
    var word: String
    
    init (word newWord: String) {
        word = newWord
    }
    
    func feedFilePath() -> String {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let filePath = paths[0].URLByAppendingPathComponent(self.word+".plist") //create the file name
        return filePath.path!
    }
    
    func saveDefination(defination: Defination) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(defination, toFile: feedFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readDefination(completion: (defination: Defination?) -> Void) {
        let path = feedFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        completion(defination: unarchivedObject as? Defination)
    }
}