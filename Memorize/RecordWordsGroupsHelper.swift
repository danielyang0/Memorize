//
//  RecordWordsGroupsHelper.swift
//  Memorize
//
//  Created by Daniel Yang on 6/3/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class RecordWordsGroupsHelper {
    
    func theFilePath() -> String {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let filePath = paths[0].URLByAppendingPathComponent("recordWordsGroups.plist") //create the file name
        return filePath.path!
    }
    
    func saveRecordWordsData(recordWordsGroups: RecordWordsGroups) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(recordWordsGroups, toFile: theFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readRecordWordsData(completion: (recordWordsGroups: RecordWordsGroups?) -> Void) {
        let path = theFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        completion(recordWordsGroups: unarchivedObject as? RecordWordsGroups)
    }
}
