//
//  DataController.swift
//  Memorize
//
//  Created by 尊 杨 on 5/2/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import Foundation
import CoreData


//store an instance, keep track of an instance of NSManagedObjectContext
class DataController {
    
    let managedObjectContext: NSManagedObjectContext //we'll manipulate dataStore through managedObjectContext
    
    init(moc: NSManagedObjectContext) {
        self.managedObjectContext = moc
    }
    
    convenience init?() {
        
        //models are stored in the main bundle of the app
        //momd instead of xcdatamodeld,bacause when compiled,app turn .xcdatamodeld files into .momd files
        guard let modelURL = NSBundle.mainBundle().URLForResource("Model", withExtension: "momd") else {
            return nil
        }
        
        //encapsulate the model file
        guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
            return nil
        }
        
        //create PersistentStoreCoordinator using model file
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        //create the actual ManagedObjectContext
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc//assign coordinator to context
        
        
        //set user file directory path  .DocumentDirectory instead of the .CacheDirectory,because we want it to be backed up
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let persistantStoreFileURL = urls[0].URLByAppendingPathComponent("words.sqlite") //get store file path
        
        do {
            try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: persistantStoreFileURL, options: nil) //connect coordinator with store file
        } catch {
            fatalError("Error adding store.")
        }
        
        self.init(moc: moc) //moc->psc(mom)->storefile
        //moc is like the sqlHelper
        //psc represents the model;
        //storefile is where data be saved in the hard drive
        
    }
    
    
    func searchWords(key:String) -> NSFetchedResultsController {
        let request = NSFetchRequest(entityName: "Word")
        request.predicate = NSPredicate(format: "spell contains[c] %@",key)
        request.sortDescriptors = [ NSSortDescriptor(key: "spell", ascending: true) ]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) //NSFetchedResultsController is a special class which works well with table views
        do {
            try fetchedResultsController.performFetch() //make sure fetchedResultsController gets those objects
        } catch {
            fatalError("words fetch failed")
        }
        return fetchedResultsController
    }
    
    
    func matchAWord(key:String) -> NSFetchedResultsController {
        let request = NSFetchRequest(entityName: "Word")
        request.predicate = NSPredicate(format: "spell == %@",key)
        request.sortDescriptors = [ NSSortDescriptor(key: "spell", ascending: true) ]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) //NSFetchedResultsController is a special class which works well with table views
        do {
            try fetchedResultsController.performFetch() //make sure fetchedResultsController gets those objects
        } catch {
            fatalError("words fetch failed")
        }
        return fetchedResultsController
    }
    
    func getNonNewWords() -> NSFetchedResultsController {
    
        let request = NSFetchRequest(entityName: "Word")
        request.predicate = NSPredicate(format: "#first != nil")
        request.sortDescriptors = [ NSSortDescriptor(key: "next", ascending: true) ]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) //NSFetchedResultsController is a special class which works well with table views
        do {
            try fetchedResultsController.performFetch() //make sure fetchedResultsController gets those objects
        } catch {
            fatalError("words fetch failed")
        }
        return fetchedResultsController
    }
    
    func getNewWords() -> NSFetchedResultsController {
        
        let request = NSFetchRequest(entityName: "Word")
        request.predicate = NSPredicate(format: "#first == nil")
        request.sortDescriptors = [NSSortDescriptor(key: "spell", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) //NSFetchedResultsController is a special class which works well with table views
        do {
            try fetchedResultsController.performFetch() //make sure fetchedResultsController gets those objects
        } catch {
            fatalError("words fetch failed")
        }
        return fetchedResultsController
    }
    
    
    
    
    
//    func getAllWords() -> NSFetchedResultsController {
//        
//        let request = NSFetchRequest(entityName: "Word")
////        request.sortDescriptors = [NSSortDescriptor(key: "spell", ascending: true)]
//        request.sortDescriptors = [NSSortDescriptor(key: "next", ascending: true)]
//        //            let wordTableController = application.windows[0].rootViewController as? WordTableViewController
//        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil) //NSFetchedResultsController is a special class which works well with table views
//        do {
//            try fetchedResultsController.performFetch() //make sure fetchedResultsController gets those objects
////            self.fetchedResultsController = fetchedResultsController
//        } catch {
//            fatalError("words fetch failed")
//        }
//        return fetchedResultsController
//    }
    
    
    func getWord(wordSpell:String) -> Word {
        let result = tryGetWord(wordSpell)
        return result!
    }
    
    func tryGetWord(wordSpell:String) -> Word? {
        let wordsFetch = NSFetchRequest(entityName: "Word") //指定要fectch which entity from your document
        wordsFetch.predicate = NSPredicate(format: "spell == %@", wordSpell)//指定查询条件
        //use condition: title(Tag's attribute)= tagtitle(user designated); use this condition to select things out
        //title=%@ is Cocoa Predicate syntax ; it's different from sql query syntax
        var fetchedWords: [Word]!
        do {
            fetchedWords = try self.managedObjectContext.executeFetchRequest(wordsFetch) as! [Word] //it's like execute sql
        } catch {
            fatalError("fetch failed")
        }
        //print("fetch到的word数量: "+String(fetchedWords.count))
        if fetchedWords.count == 0 {
            return nil
        }else {
            let word = fetchedWords[0]
            return word
        }
        
    }
    
    func deleteWord(spell:String) -> Bool {
        let result = tryGetWord(spell)
        if result == nil {
            return false
        }
        self.managedObjectContext.deleteObject(result!)
        do {
            try self.managedObjectContext.save() //前面都没有真正保存，只是记录了变动，这句代码才真正保存到文件中
        } catch {
            fatalError("couldn't delete context")
        }
        return true
    }
    
    
    func addWord(spell: String) -> Bool{
        
        let result = tryGetWord(spell)
        if result != nil {
            return false
        }
        
        let newWord = NSEntityDescription.insertNewObjectForEntityForName("Word", inManagedObjectContext: self.managedObjectContext) as! Word
        
        newWord.spell = spell
        return saveContext()
        
    }
    
    func batchAddWord(spells: [String]) -> Int{
        var sucNum = 0
        for spell in spells {
            if addWord(spell) {
                sucNum++
            }
        }
        return sucNum
    }
    

    
    //返回实际index指向的日期，不是返回next
    func memorizeForward(wordSpell: String) -> NSDate? {
        let word = getWord(wordSpell)
        
        if indexOutOfRange(word){
            return nil
        }
        
        word.setADateMoveForward(NSDate())
        
        setEbbinDatesFromIndex(word)

        let theDate = setNextPropertyAndgetDatesAtIndex(word)
        
        if saveContext() {
            return theDate
        }else{
            return nil
        }

    }
    

    
    func backward(wordSpell: String) {
        let word = getWord(wordSpell)
        word.moveIndexBackward()
        
        setEbbinDatesFromIndex(word)
        setNextPropertyAndgetDatesAtIndex(word)
        
        saveContext()
    }
    
    
    func reMemorizeAtLastTime(wordSpell: String) -> NSDate? {
        let word = getWord(wordSpell)
        word.moveIndexBackward()
        word.setADateMoveForward(NSDate())
        
        setEbbinDatesFromIndex(word)
        
        let theDate = setNextPropertyAndgetDatesAtIndex(word)
        
        if saveContext() {
            return theDate
        }else{
            return nil
        }
    }
    
    private func setNextPropertyAndgetDatesAtIndex(word: Word) -> NSDate? {
        let theIndex = Int(word.index!)
        let theDate = word.getAdate(theIndex) //当word未初始化以及index指向范围外时，都是nil
        if indexOutOfRange(word) {//如果index指向范围外时,next时间设为10年以后
            word.next = NSDate(timeInterval: 3600*24*10*365, sinceDate: NSDate())
        }else {
            word.next = theDate
        }
        return theDate
    }
    
    
    private func saveContext() -> Bool {
        do {
            try self.managedObjectContext.save() //前面都没有真正保存，只是记录了变动，这句代码才真正保存到文件中
            return true
        } catch {
            fatalError("couldn't save context")
        }
        return false
    }
    
    
    private func setEbbinDatesFromIndex(word: Word){
        let hasDates = word.getHasDates()
        let ebbin = Ebbin(original: hasDates) //已背日期
        word.setDates(ebbin.schedule)
    }
    
    private func indexOutOfRange(word: Word) -> Bool {
        if Int(word.index!) >= 12 {
            return true
        }else{
            return false
        }
    }
    
    
}

