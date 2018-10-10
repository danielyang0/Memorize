//
//  RecordWordsHelper.swift
//  Memorize
//
//  Created by Daniel Yang on 5/14/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class RecordWordsHelper {
    
    func theFilePath() -> String {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let filePath = paths[0].URLByAppendingPathComponent("recordWords.plist") //create the file name
        return filePath.path!
    }
    
    func saveRecordWordsData(recordWords: RecordWords) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(recordWords, toFile: theFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readRecordWordsData(completion: (recordWords: RecordWords?) -> Void) {
        let path = theFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        completion(recordWords: unarchivedObject as? RecordWords) //Reading a file could take long, so put it in another thead with completion method
    }
}
