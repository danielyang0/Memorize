//
//  WordTableViewController.swift
//  Memorize
//
//  Created by Daniel Yang on 5/2/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import UIKit
import CoreData

class WordTableViewController: UITableViewController {
    
    
    var superVC: ContainerViewController!

    
    var colorIndex = 0
    let pas = UIPasteboard.generalPasteboard()

    var wordExisted:String = ""
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func myReloadData() {
        self.colorIndex = 0
        self.tableView.reloadData()
        self.superVC.refreshDisplayDictionaryIfNeeded()
    }
    
    
    private func getIndexPath(sender: UIButton) -> NSIndexPath {
        var superView = sender.superview
        while superView?.isKindOfClass(UITableViewCell) == false {
            superView = superView?.superview
        }
        let cell = superView as! UITableViewCell
        let indexPath = self.tableView.indexPathForCell(cell)! as NSIndexPath
        return indexPath
    }
    
    
    private func getWordAtButton(sender: UIButton) -> Word {
        let indexPath = self.getIndexPath(sender)
        return self.superVC.viewManager.wordAtIndexPath(indexPath)
    }
    

//  --  button C
    @IBAction func displayDefinitionAction(sender: UIButton) {
        let word = getWordAtButton(sender)
        let wordSpell = word.spell!
        displayYoudaoButtonDidPressed(wordSpell)
 
    }
    
    
    func displayYoudaoButtonDidPressed(wordSpell: String) {
        superVC.webManager.loadOrdownloadYoudaoDefinition(wordSpell) { (defination) -> Void in
            var msg: String = defination.youdaoDefination
            if msg == "" {
                msg = "没有查到单词"
            }
            let title = "The definition of " + wordSpell + defination.phonetic
            
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                self.superVC.webManager.dataTask?.cancel()
            }
            alertController.addAction(defaultAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                self.superVC.webManager.dataTask?.cancel()
            }
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

    @IBAction func builtInDictionaryAction(sender: UIButton) {
        let word = getWordAtButton(sender)
        let wordSpell = word.spell!
        
        let alertTitle = "Actions for " + wordSpell
        let msg = ""
        
        let alertController = UIAlertController(title: alertTitle, message: msg, preferredStyle: .Alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .Default) { (action) -> Void in
            self.deleteOperation(wordSpell)
        }
        
        let reMemorizeAction = UIAlertAction(title: "Rememorize", style: .Default) { (action) -> Void in
            self.reMemorizeOperation(wordSpell)
        }
        let toRecords = UIAlertAction(title: "ToRecords", style: .Default) { (action) -> Void in
            self.toRecordsOperation(wordSpell)
        }
        
        let removeFromRecords = UIAlertAction(title: "RemoveFromRecords", style: .Default) { (action) -> Void in
            self.removeFromRecordsOperation(wordSpell)
        }
        
        let backAction = UIAlertAction(title: "Back", style: .Default) { (action) -> Void in
            self.backOperation(wordSpell)
        }
        
        let copyAction = UIAlertAction(title: "Copy", style: .Default) { (action) -> Void in
            self.pas.string = wordSpell
            self.superVC.silentTime = 2*60
        }
        
        let websterAction = UIAlertAction(title: "Webster", style: .Default) { (action) -> Void in
            self.superVC.silentTime = 2*60
            self.pas.string = wordSpell
            let schemeUrl = "mw-collegiate://"
            let url = NSURL(string: schemeUrl)!
            UIApplication.sharedApplication().openURL(url)
            
        }
        
        let youdictAction = UIAlertAction(title: "Youdict", style: .Default) { (action) -> Void in
            self.superVC.silentTime = 2*60
            self.pas.string = wordSpell
            let schemeUrl = "yddictProapp://"
            let url = NSURL(string: schemeUrl)!
            UIApplication.sharedApplication().openURL(url)
        }
        
        
        let WebsterWebAction = UIAlertAction(title: "WebWebster", style: .Default) { (action) -> Void in
            self.superVC.silentTime = 2*60
            self.pas.string = wordSpell
            let schemeUrl = "https://www.merriam-webster.com/dictionary/" + wordSpell
            let url = NSURL(string: schemeUrl)!
            UIApplication.sharedApplication().openURL(url)
        }
        
        
        
        
        let youdictWebAction = UIAlertAction(title: "WebYoudict", style: .Default) { (action) -> Void in
            self.superVC.silentTime = 2*60
            self.pas.string = wordSpell
            let schemeUrl = "http://dict.youdao.com/w/eng/"+wordSpell+"/#keyfrom=dict2.index"
            let url = NSURL(string: schemeUrl)!
            UIApplication.sharedApplication().openURL(url)
        }
        
        let youciAction = UIAlertAction(title: "Youci", style: .Default) { (action) -> Void in
            self.superVC.silentTime = 2*60
            self.pas.string = wordSpell
            let schemeUrl = "http://www.youdict.com/w/"+wordSpell
            let url = NSURL(string: schemeUrl)!
            UIApplication.sharedApplication().openURL(url)
        }
        
        
        let googleAction = UIAlertAction(title: "Google", style: .Default) { (action) -> Void in
            self.superVC.silentTime = 2*60
            self.pas.string = wordSpell
            let schemeUrl = "https://www.google.com"
            let url = NSURL(string: schemeUrl)!
            UIApplication.sharedApplication().openURL(url)
        }
        
        
        alertController.addAction(deleteAction)
        alertController.addAction(reMemorizeAction)
        alertController.addAction(toRecords)
        alertController.addAction(removeFromRecords)
        alertController.addAction(backAction)
        alertController.addAction(copyAction)
        alertController.addAction(websterAction)
        alertController.addAction(youdictAction)
        alertController.addAction(WebsterWebAction)
        alertController.addAction(youdictWebAction)
        alertController.addAction(youciAction)
        alertController.addAction(googleAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func lookUpBuiltInDictionaryButtonDidPressed(wordSpell: String) -> Bool {
        self.superVC.silentTime = 2*60
        self.pas.string = wordSpell
        return self.superVC.displayWordInBuiltInDictionary(wordSpell)
    }
    
    //when select a line, show the result in dictonary
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let word = self.superVC.viewManager.wordAtIndexPath(indexPath)
        let wordSpell = word.spell!
        lookUpBuiltInDictionaryButtonDidPressed(wordSpell)
        
    }

    
    func appendToMemorizedHistory(wordString: String) {
        if self.appDelegate.memorizedWords.count > 100 {
            self.appDelegate.memorizedWords.removeAtIndex(0)
        }
        self.appDelegate.memorizedWords.append(wordString)
    }
    
    @IBAction func memorize(sender: UIButton) {
        let indexPath = self.getIndexPath(sender)
        let word = self.superVC.viewManager.wordAtIndexPath(indexPath)
        memorizeOpration(word.spell!)
    }
    
    
    func memorizeOpration(wordSpell: String) {
        appendToMemorizedHistory(wordSpell)
        let theDate = appDelegate.dataController.memorizeForward(wordSpell)
        if theDate != nil { // && Int(word.index!) < 12
            self.superVC.viewManager.updateEarlistDueDate(theDate!)
        }
        self.superVC.viewManager.retrieveData()
        self.superVC.confirmDisplay()
    }
    
    
    func addWordBasicOperation(wordSpell: String) -> Bool {
        if wordSpell == "" {
            self.wordExisted = "不能输入空"
            return false
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let success = appDelegate.dataController.addWord(wordSpell)
        if success {
            self.wordExisted = ""
            self.superVC.viewManager.fetchedNewWordsResultsController = self.appDelegate.dataController.getNewWords()
            if self.superVC.viewManager.whichView == ViewManager.Views.search {
                self.superVC.viewManager.fetchedSearchResultsController = appDelegate.dataController.searchWords(self.superVC.searchInput)
            }
        }else {
            self.wordExisted = wordSpell + " existed! "
        }
        return success
    }
    
    
    func addWord() {
        let msg = self.wordExisted + "Type your word"
        let alertController = UIAlertController(title: "Add Word", message: msg, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Add", style: .Default) { (action) -> Void in
            if let wordSpell = alertController.textFields![0].text {
                if self.addWordBasicOperation(wordSpell) {
                    self.superVC.confirmDisplay()
                }else{
                    self.addWord()
                }
            }
        }
        
        let addAndToRecordsAction = UIAlertAction(title: "AddAndToRecord", style: .Default) { (action) -> Void in
            if let wordSpell = alertController.textFields![0].text {
                self.appDelegate.recordWordsGroups.addWordToCurrentGroup(wordSpell)
                if !self.addWordBasicOperation(wordSpell) {
                    self.addWord()
                }
                self.superVC.confirmDisplay()
            }
        }
        
        let addAndShowAction = UIAlertAction(title: "Add and show", style: .Default) { (action) -> Void in
            if let wordSpell = alertController.textFields![0].text {
                if self.addWordBasicOperation(wordSpell) {
                    self.superVC.searchInput = wordSpell
                    self.superVC.viewManager.fetchedSearchResultsController = self.appDelegate.dataController.searchWords(self.superVC.searchInput)
                    self.superVC.rememberOldOrNewWordViewIfNeccessay()
                    self.superVC.viewManager.whichView = ViewManager.Views.search
                    self.superVC.confirmDisplay()
                }else {
                    self.addWord()
                }
            }
        }
        
        let addShowToRecordsAction = UIAlertAction(title: "Go", style: .Default) { (action) -> Void in
            if let wordSpell = alertController.textFields![0].text {
                self.appDelegate.recordWordsGroups.addWordToCurrentGroup(wordSpell)
                if self.addWordBasicOperation(wordSpell) {
                    self.superVC.searchInput = wordSpell
                    self.superVC.viewManager.fetchedSearchResultsController = self.appDelegate.dataController.searchWords(self.superVC.searchInput)
                    self.superVC.rememberOldOrNewWordViewIfNeccessay()
                    self.superVC.viewManager.whichView = ViewManager.Views.search
                }else {
                    self.addWord()
                }
                self.superVC.confirmDisplay()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            self.wordExisted = ""
        }

        alertController.addAction(defaultAction)
        alertController.addAction(addAndToRecordsAction)
        alertController.addAction(addAndShowAction)

        alertController.addAction(addShowToRecordsAction)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler(nil)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func backOperation(wordSpell: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.dataController.backward(wordSpell)
        self.superVC.viewManager.retrieveData()
        self.superVC.confirmDisplay()
    }
    
    func reMemorizeOperation(wordSpell: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let theDate = appDelegate.dataController.reMemorizeAtLastTime(wordSpell)
        if theDate != nil { // && Int(word.index!) < 12
            self.superVC.viewManager.updateEarlistDueDate(theDate!)
        }
        self.superVC.viewManager.retrieveData()
        self.superVC.confirmDisplay()
    }
    
    
    
    func deleteOperation(wordSpell: String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let success = appDelegate.dataController.deleteWord(wordSpell)
        
        if success {
            if self.superVC.viewManager.whichView == ViewManager.Views.search {
                self.superVC.viewManager.fetchedSearchResultsController = appDelegate.dataController.searchWords(self.superVC.searchInput)
            }
            self.superVC.viewManager.deleteStringFromRecords(wordSpell)
            self.superVC.viewManager.retrieveData()
            self.superVC.confirmDisplay()
        }
    }
    
    func toRecordsOperation(wordSpell: String) {
        self.appDelegate.recordWordsGroups.addWordToCurrentGroup(wordSpell)
        self.superVC.confirmDisplay()
    }
    
    func removeFromRecordsOperation(wordSpell: String) {
        self.superVC.viewManager.deleteStringFromRecords(wordSpell)
        self.superVC.confirmDisplay()
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.superVC.viewManager.resultSectionCount

    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.superVC.viewManager.getNumberOfRowsInSection(section)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wordCell", forIndexPath: indexPath) as! WordTableViewCell
        let word = self.superVC.viewManager.wordAtIndexPath(indexPath)
        
        var rowContent = getRowContent(word)
        if rowContent.nth != "" {
            rowContent.nth = " 第"+rowContent.nth+"次"
        }
        cell.cellText.text = rowContent.spell+rowContent.date+rowContent.nth
        cell.remindLabel.text = rowContent.reminder
        cell.backgroundColor = rowContent.bgColor
        if let theDate = rowContent.nsdate {
            self.superVC.viewManager.setEarlistDueDateOnlyOnce(theDate)
        }
        return cell
    }
    
    
    
    func getStatusString(word: Word) -> String {
        var displayString = ""
        let rowContent = getRowContent(word)
        if rowContent.reminder == "" {
            displayString = " new"
        }else{
            displayString = "第"+rowContent.nth+"次 "+rowContent.reminder
        }
        return displayString
    }
    
    func popUpStatus(word: Word) {
        let alertController = UIAlertController(title: word.spell!+"的状态", message: getStatusString(word), preferredStyle: UIAlertControllerStyle.ActionSheet)
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
        }
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    typealias RowContent = (spell: String, date: String, nsdate: NSDate?, nth: String, reminder: String, bgColor:UIColor)
    
    let formatter = NSDateFormatter()
    let color1 = UIColor(red: 255/255, green: 228/255, blue: 196/255, alpha: 0.3) //Bisque
    let color2 = UIColor(red: 0/255, green: 139/255, blue: 139/255, alpha: 0.3) //Darkcyan
    let color3 = UIColor(red: 255/255, green: 140/255, blue: 0/255, alpha: 0.3) //Darkorange
    let color4 = UIColor(red: 147/255, green: 112/255, blue: 219/255, alpha: 0.3) //Mediumpurple
    
    
    func getRowContent(word: Word) -> RowContent {
        
        let spell = word.spell!
        var date: String
        var nsdate: NSDate?
        var nth: String
        var reminder: String
        var bgColor: UIColor
        let theIndex = Int(word.index!)
        let theDate = word.getAdate(theIndex)
        
        
        if theIndex == 0 {
            date = ""
            nsdate = nil
            nth = ""
            reminder = ""
            let colors = [color1,color2,color3,color4]
            bgColor = UIColor.whiteColor()
            for(var i = 65; i < 91; i++) {
                var lower = ""
                lower.append(Character(UnicodeScalar(i)))
                var upper = ""
                upper.append(Character(UnicodeScalar(i+32)))
                if spell.hasPrefix(lower) || spell.hasPrefix(upper) {
                    if i != colorIndex/10 {
                        self.colorIndex = i*10 + (self.colorIndex % 10 + 1) % 4
                    }
                    bgColor = colors[self.colorIndex % 10]
                }
            }

        }else if theIndex == 12{
            date = ""
            nsdate = nil
            nth = ""
            reminder = "finished"
            bgColor = UIColor(red: 107/255, green: 142/255, blue: 35/255, alpha: 0.8)
        }else {
            self.formatter.dateFormat = "MM-dd HH:mm"
            date = " "+formatter.stringFromDate(theDate!)
            nsdate = theDate
            nth = String(theIndex+1)
            let now = NSDate()
            let day = 86400
            let month = 2592000
            let hour = 3600
            let fromNowToDate = Int(theDate!.timeIntervalSinceDate(now))
            if fromNowToDate > month {
                bgColor = UIColor(red: 245/255, green: 245/255, blue: 220/255, alpha: 0.8)
                reminder = String(Double(fromNowToDate*10/month)/10.0)+"m"
            }else if fromNowToDate > day {
                bgColor = UIColor(red: 176/255, green: 196/255, blue: 222/255, alpha: 0.8) //Lightsteelblue, more than one day, less than one month
                reminder = String(Double(fromNowToDate*10/day)/10.0)+"d"
            }else if fromNowToDate > 12*hour {
                bgColor = UIColor(red: 60/255, green: 179/255, blue: 113/255, alpha: 0.8) //Mediumseagreen, more than 12h，less than 1天
                reminder = String(Double(fromNowToDate*10/hour)/10.0)+"h"
            }else if fromNowToDate > 3*hour {
                bgColor = UIColor(red: 147/255, green: 112/255, blue: 219/255, alpha: 0.8) //Mediumpurple,more than 3h，less than 12h
                reminder = String(Double(fromNowToDate*10/hour)/10.0)+"h"
            }else if fromNowToDate > hour {
                bgColor = UIColor(red: 135/255, green: 206/255, blue: 250/255, alpha: 0.8) //Lightskyblue, more than 1h，less than 3h
                reminder = String(Double(fromNowToDate*10/hour)/10.0)+"h"
            }else if fromNowToDate > 30*60 {
                bgColor = UIColor(red: 240/255, green: 230/255, blue: 140/255, alpha: 0.8) //khaki more than 30min, less than 1h
                reminder = String(Double(fromNowToDate*10/60)/10.0)+"min"
            }else if fromNowToDate > 0 {
                bgColor = UIColor(red: 255/255, green: 165/255, blue: 0, alpha: 0.8)//orange  less than 30min
                reminder = String(Double(fromNowToDate*10/60)/10.0)+"min"
            }else {
                bgColor = UIColor(red: 255/255, green: 69/255, blue: 0, alpha: 0.8) //orangered
                reminder = "due"
            }
        }
        let rowContent: RowContent = (spell: spell, date: date, nsdate: nsdate, nth: nth, reminder: reminder, bgColor:bgColor)
        return rowContent
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        self.superVC.viewManager.retrieveData()
        self.superVC.confirmDisplay()
        
        
    }
    
    

    
    
    //return ture when date1 is prior to date2
    func before(date1:NSDate,date2:NSDate) -> Bool {
        let result:NSComparisonResult = date1.compare(date2)
        if result == NSComparisonResult.OrderedDescending{
            return false
        }
        return true
    }
    
    func beforeInterval(date1:NSDate,date2:NSDate,timeIntervalSeconds:NSTimeInterval) -> Bool {
        let date1After = NSDate(timeInterval: timeIntervalSeconds, sinceDate: date1)
        return before(date1After,date2: date2)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
