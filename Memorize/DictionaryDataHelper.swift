//
//  DictionaryDataHelper.swift
//  Memorize
//
//  Created by Daniel Yang on 5/14/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class DictionaryDataHelper {
    
    func dictionaryFilePath() -> String {
        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let filePath = paths[0].URLByAppendingPathComponent("dictionaryData.plist") //create the file name
        return filePath.path!
    }
    
    func saveDictionaryData(dictionaryData: DictionaryData) -> Bool {
        let success = NSKeyedArchiver.archiveRootObject(dictionaryData, toFile: dictionaryFilePath())
        assert(success, "failed to write archive")
        return success
    }
    
    func readDictionaryData(completion: (dictionaryData: DictionaryData?) -> Void) {
        let path = dictionaryFilePath()
        let unarchivedObject = NSKeyedUnarchiver.unarchiveObjectWithFile(path)
        completion(dictionaryData: unarchivedObject as? DictionaryData)
    }
}