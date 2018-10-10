//
//  YoudaoDifination.swift
//  Memorize
//
//  Created by Daniel Yang on 5/12/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation

class Defination: NSObject, NSCoding{
    var word: String
    var youdaoDefination: String
    var phonetic: String
    
    init (word newWords: String, youdaoDefination newYoudaoDefination: String, phonetic newPhonetic: String) {
        self.word = newWords
        self.youdaoDefination = newYoudaoDefination
        self.phonetic = newPhonetic
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.word, forKey: "word")
        aCoder.encodeObject(self.youdaoDefination, forKey: "youdaoDefination")
        aCoder.encodeObject(self.phonetic, forKey: "phonetic")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let storedWord = aDecoder.decodeObjectForKey("word") as? String
        let storedYoudaoDefination = aDecoder.decodeObjectForKey("youdaoDefination") as? String
        let storedPhonetic = aDecoder.decodeObjectForKey("phonetic") as? String
        
        guard storedWord != nil && storedYoudaoDefination != nil && storedPhonetic != nil else {
            return nil
        }
        self.init(word: storedWord!, youdaoDefination: storedYoudaoDefination!, phonetic: storedPhonetic!)
    }
    
    
    convenience init(youdaoPage: Youdao) {

        let chineseDifinition: String
        if let parsedChineseDifinition = youdaoPage.parseChineseDefinition() {
            chineseDifinition = parsedChineseDifinition
        }else {
            chineseDifinition = ""
        }
        
        let phonetic: String
        if let parsedPhonetic = youdaoPage.parsePhonetic() {
            phonetic = parsedPhonetic
        }else {
            phonetic = ""
        }
        self.init(word: youdaoPage.word, youdaoDefination: chineseDifinition, phonetic: phonetic)
    }
    
}