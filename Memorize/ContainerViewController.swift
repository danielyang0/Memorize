//
//  ContainerViewController.swift
//  Memorize
//
//  Created by Daniel Yang on 5/11/18.
//  Copyright © 2018 raindrean. All rights reserved.
//

import UIKit
import AVFoundation

class ContainerViewController: UIViewController {

    @IBOutlet var addWordButton: UIBarButtonItem!
    
    var player: AVAudioPlayer!
    func loadMp3() {
        if let path = NSBundle.mainBundle().pathForResource("冰雨", ofType:"mp3") {
            let url = NSURL(fileURLWithPath: path)
            do {
                self.player = try AVAudioPlayer(contentsOfURL: url)
                print("about to play")
                self.player.play()
            } catch {
                print("couldn't load file")
            }
        }
    }
    
    var device = AppleDevice(deviceName: "iphone6sp")
    var dictionaryAdditonLabelWith: CGFloat = 220
    var textVCWidth:CGFloat = 35
    var searchInput:String = ""
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var webManager: WebManager = WebManager()
    var viewManager:ViewManager = ViewManager()
    
    var silentTime: NSTimeInterval = 0
    
    lazy var tableVC: WordTableViewController = {
        
        let storyboard = UIStoryboard(name:"Main",bundle:NSBundle.mainBundle())
        var table = storyboard.instantiateViewControllerWithIdentifier("WordTableViewController") as! WordTableViewController
        table.superVC = self
        return table
    }()
    var isdDicShown: Bool = false
    
    var dicVC: UIReferenceLibraryViewController!

    lazy var textVC: TextFieldViewController = {
        let storyboard = UIStoryboard(name:"Main",bundle:NSBundle.mainBundle())
        var tvc = storyboard.instantiateViewControllerWithIdentifier("TextFieldViewController") as! TextFieldViewController
        tvc.superVC = self
        return tvc
    }()
    
    
    lazy var dicAdditonVC: DictionaryAddtionController = {
        let storyboard = UIStoryboard(name:"Main",bundle:NSBundle.mainBundle())
        var dvc = storyboard.instantiateViewControllerWithIdentifier("DictionaryAddtionController") as! DictionaryAddtionController
        dvc.superVC = self
        return dvc
    }()
    
    
    func onBecomeActive() {
        self.tableVC.myReloadData()
        self.confirmDisplay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeToBeChildAndSetSubView(self.tableVC)
        setOriginalFrameSizes()
        
    }
    
    func setOriginalFrameSizes() {
        self.setViewFrameWithYAndHeight(self.tableVC, y: 0, height: UIScreen.mainScreen().bounds.height)
    }
    
    
    func confirmDisplay() {
        self.viewManager.prepareDisplay()
        self.navigationItem.title = self.viewManager.getNavigationTitle()
        self.tableVC.myReloadData()
    }
    
    

    func displayWordInBuiltInDictionary(word: String) -> Bool {
        if displayWordInBuiltInDictionaryOperation(word) {
            self.appDelegate.dictionaryData.addANewWordTolookedUpHistory(word)
            return true
        }else {
            return false
        }
    }
    
    func removeDicDataAfterwards() {
        self.appDelegate.dictionaryData.removeDicDataAfterwards()
    }
    
    func clearDictionaryData() {
        self.appDelegate.dictionaryData.clearExceptCurrentOne()
    }

    
    func displayWordInBuiltInDictionaryOperation(word: String) -> Bool {
        if UIReferenceLibraryViewController.dictionaryHasDefinitionForTerm(word) {
            if isdDicShown {
                hideDictionary()
            }
            
            textVC.wordString = word
            dicVC = UIReferenceLibraryViewController(term: word)
            self.displayDictionary()
 
            return true
        }else{
            return false
        }
    }
    
    
    func historyBackButtonPressed() {
        if let word = self.appDelegate.dictionaryData.historyBackAndShow() {
            displayWordInBuiltInDictionaryOperation(word)
        }
    }
    
    func historyForwardButtonPressed() {
        if let word = self.appDelegate.dictionaryData.historyForwardAndShow() {
            displayWordInBuiltInDictionaryOperation(word)
        }
    }


    
    func setFrameSizesForiOSDevice(deviceScreenHeight: CGFloat, dictionaryHeight: CGFloat) {
        setViewFrameWithYAndHeight(dicVC, y: 0, height: dictionaryHeight)
        setViewFrameWithYAndHeight(self.textVC, y: dictionaryHeight-40, height: self.textVCWidth)
        
        setViewFrameWithYAndHeight(self.tableVC, y: dictionaryHeight-62, height: deviceScreenHeight-dictionaryHeight+62)
    }
    


    
    
    func displayDictionary() {
        self.setChildAndSetSubView(dicVC, vc: textVC)
        self.setChildAndSetSubView(dicVC, vc: dicAdditonVC)
        makeToBeChildAndSetSubView(dicVC)
        setFrameSizesForiOSDevice(device.deviceScreenHeight, dictionaryHeight: device.dictionaryHeight)
  
        refreshDictionaryControllers()
        
        
        isdDicShown = true
    }
    
    
    func setDicAdditionControllerLabel(postfix: String, wordSpell: String) {
        self.webManager.loadOrdownloadYoudaoDefinition(wordSpell) { (defination) -> Void in
            self.dicAdditonVC.wordLabel.text = defination.word + defination.phonetic + postfix
            self.dicAdditonVC.definitionTextField.text = defination.youdaoDefination
        }
    }
    
    
    func refreshDictionaryControllers() {
        var postfix = ""
        let matchResultController = tableVC.appDelegate.dataController.matchAWord(textVC.wordString)
        if let matchedWord = matchResultController.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? Word {
            self.dicAdditonVC.wordLabel.textColor = UIColor.blackColor()
            setViewFrameWithXYAndHeight(dicAdditonVC, x: device.deviceScreenWidth-self.dictionaryAdditonLabelWith, y: 0, height: 30)
            
            textVC.word = matchedWord
            let rowContent = self.tableVC.getRowContent(textVC.word!)
            if rowContent.reminder == "" {
                postfix = " new"
            }else{
                postfix = rowContent.nth+" "+rowContent.reminder
            }
        }else {
            self.dicAdditonVC.wordLabel.textColor = UIColor(red: 128/255, green: 128/255, blue: 128/255, alpha: 128/255)
            textVC.word = nil
            
        }
        setDicAdditionControllerLabel(postfix, wordSpell: textVC.wordString)
        
    }
    
    func refreshDisplayDictionaryIfNeeded() {
        if isdDicShown {
            refreshDictionaryControllers()
        }
    }
    
    
    
    func toggleDictionary() {
        if isdDicShown {
            hideDictionaryAndResetTableView()
        }else {
            if dicVC != nil {
                displayDictionary()
            }else {
                if let word = self.appDelegate.dictionaryData.showLookedUpHistoryAtIndex() {
                    textVC.wordString = word
                    dicVC = UIReferenceLibraryViewController(term: word)
                    displayDictionary()
                }
            }  
        }
    }
    
    func hideDictionary() {
        removeChild(textVC)
        removeChild(dicAdditonVC)
        removeChild(dicVC)
        isdDicShown = false
    }
    
    func hideDictionaryAndResetTableView() {
        hideDictionary()
        setOriginalFrameSizes()
    }
    
    
    
    
    @IBAction func switchButtonAction(sender: UIBarButtonItem) {
        self.viewManager.switchButtonPressed()
        self.confirmDisplay()
    }
    
    
    
    func rememberOldOrNewWordViewIfNeccessay() {
        if self.viewManager.whichView == ViewManager.Views.oldWords || self.viewManager.whichView == ViewManager.Views.newWords {
            self.viewManager.lastWhichView = self.viewManager.whichView
        }
    }

    @IBAction func searchButtonAction(sender: UIBarButtonItem) {
        let msg = "input part of the word"
        
        let alertController = UIAlertController(title: "Search Word", message: msg, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            if let input = alertController.textFields![0].text {
                self.searchInput = input
                self.viewManager.fetchedSearchResultsController = self.appDelegate.dataController.searchWords(input)
                self.rememberOldOrNewWordViewIfNeccessay()
                self.viewManager.whichView = ViewManager.Views.search
                self.confirmDisplay()
            }
            
        }
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler(nil)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func recordsButtonAction(sender: UIBarButtonItem) {
        self.rememberOldOrNewWordViewIfNeccessay()
        if self.viewManager.whichView != ViewManager.Views.records {
            self.viewManager.whichView = ViewManager.Views.records
        }else {
            appDelegate.recordWordsGroups.moveIndexForward()
        }
        
        
        self.confirmDisplay()
    }
    
    @IBAction func keepSilent(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Keep silent for: ", message: "input minutes", preferredStyle: .Alert)
        let silentInputAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            if let inputMinute = alertController.textFields![0].text {
                if let minute = Int(inputMinute) {
                    self.silentTime = NSTimeInterval(minute*60)
                }
            }
        }
        let silentResetAction = UIAlertAction(title: "reset", style: .Default) { (action) -> Void in
            self.silentTime = 60
        }
        let silent1Action = UIAlertAction(title: "2 min", style: .Default) { (action) -> Void in
            self.silentTime += 2*60
        }
        let silent2Action = UIAlertAction(title: "5 min", style: .Default) { (action) -> Void in
            self.silentTime += 5*60
        }
        let silent3Action = UIAlertAction(title: "10 min", style: .Default) { (action) -> Void in
            self.silentTime += 10*60
        }
        let silent4Action = UIAlertAction(title: "20 min", style: .Default) { (action) -> Void in
            self.silentTime += 20*60
        }
        let silent5Action = UIAlertAction(title: "30 min", style: .Default) { (action) -> Void in
            self.silentTime += 30*60
        }
        let silent6Action = UIAlertAction(title: "60 min", style: .Default) { (action) -> Void in
            self.silentTime += 60*60
        }
        let silent7Action = UIAlertAction(title: "9 h", style: .Default) { (action) -> Void in
            self.silentTime += 9*60*60
        }
        let recordsOrderTitle: String
        if self.viewManager.recordsDisplayOrder == 0 {
            recordsOrderTitle = "records现在是顺序";
        }else{
            recordsOrderTitle = "records现在是逆序";
        }
            
        let recordsOrderAction = UIAlertAction(title: recordsOrderTitle, style: .Default) { (action) -> Void in
            self.viewManager.recordsDisplayOrder = (self.viewManager.recordsDisplayOrder + 1 ) % 2
            self.tableVC.myReloadData()
        }
        let memorizedHistoryAction = UIAlertAction(title: "show memorized", style: .Default) { (action) -> Void in
            self.rememberOldOrNewWordViewIfNeccessay()
            self.viewManager.whichView = ViewManager.Views.memorizedHistory
            self.confirmDisplay()
        }
        let addWordsFromLoadedTextFileAction = UIAlertAction(title: "从文件中添加单词", style: .Default) { (action) -> Void in
            self.importWordFromFile()
        }
        
        let deleteOldWordsInRecordsAction = UIAlertAction(title: "清理records", style: .Default) { (action) -> Void in
            self.appDelegate.recordWordsGroups.deleteOldWords()
            self.confirmDisplay()
        }
        
        let clearRecords = UIAlertAction(title: "emptyRecords", style: .Default) { (action) -> Void in
            let emptyController = UIAlertController(title: "确定清空吗", message: "", preferredStyle: .Alert)
            let emptyCancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            emptyController.addAction(emptyCancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                self.viewManager.clearRecords()
                self.confirmDisplay()
            }
            emptyController.addAction(OKAction)
            self.presentViewController(emptyController, animated: true, completion: nil)
        }
        
        
        alertController.addAction(silentInputAction)
        alertController.addAction(silentResetAction)
        alertController.addAction(silent3Action)
        alertController.addAction(silent6Action)
        alertController.addAction(silent7Action)
        alertController.addAction(recordsOrderAction)
        alertController.addAction(deleteOldWordsInRecordsAction)
        alertController.addAction(clearRecords)
        alertController.addAction(memorizedHistoryAction)
        alertController.addAction(addWordsFromLoadedTextFileAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler(nil)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func importWordFromFile() {
        let alertController = UIAlertController(title: "从文件中导入单词", message: "输入文件名", preferredStyle: .Alert)
        let fileNameInputAction = UIAlertAction(title: "输入的文件名", style: .Default) { (action) -> Void in
            if let inputFileName = alertController.textFields![0].text where inputFileName != "" {
                self.importWordsOperation(inputFileName)
            }
        }
        alertController.addAction(fileNameInputAction)
        
        let loadFileNames = self.appDelegate.loadFileNames
        for fileName in loadFileNames {
            alertController.addAction(UIAlertAction(title: fileName, style: .Default, handler: { (action) -> Void in
                self.importWordsOperation(fileName)
            }))
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addTextFieldWithConfigurationHandler(nil)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    func importWordsOperation(inputFileName: String) {
        var showTitle:String
        var showMsg:String
        if let msg = self.appDelegate.addWordsFromLoadedFile(inputFileName) {
            self.viewManager.fetchedNewWordsResultsController = self.appDelegate.dataController.getNewWords()
            self.confirmDisplay()
            showTitle = "从文件中添加单词的结果"
            showMsg = msg
        }else{
            showTitle = "操作失败"
            showMsg = "文件不存在或导入失败"
        }
        let alertController = UIAlertController(title: showTitle, message: showMsg, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let defaultAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
        }
        alertController.addAction(defaultAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func refreshButton(sender: UIBarButtonItem) {
        toggleDictionary()
        self.tableVC.myReloadData()
    }
    
    @IBAction func addWordButtonAction(sender: UIBarButtonItem) {
        self.tableVC.addWord()
    }
    
    func addWordDependingOnView(word: String) -> Bool {
        if self.viewManager.whichView == ViewManager.Views.records {
            self.appDelegate.recordWordsGroups.addWordToCurrentGroup(word)
        }
        let addSuccess = self.tableVC.addWordBasicOperation(word)
        self.confirmDisplay()
        self.tableVC.displayYoudaoButtonDidPressed(word)
        if addSuccess{
            return true
        }else{
            return false
        }
    }
    
    func addToRecordAndDictionary(word: String) -> Bool {
        if tableVC.lookUpBuiltInDictionaryButtonDidPressed(word) {
            self.appDelegate.recordWordsGroups.addWordToCurrentGroup(word)
            self.tableVC.addWordBasicOperation(word)
            self.viewManager.whichView = ViewManager.Views.records
            self.confirmDisplay()
            return true
        }else {
           return false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setViewFrameWithXYAndHeight(vc:UIViewController, x:CGFloat, y: CGFloat, var height: CGFloat) {
        if height < 0 {
            height = UIScreen.mainScreen().bounds.height - height
        }
        let frame = CGRect(x: x, y: y, width: UIScreen.mainScreen().bounds.width-x, height: height)
        vc.view.frame = frame
        vc.view.autoresizingMask = []
    }

    
    func setViewFrameWithYAndHeight(vc:UIViewController, y: CGFloat, var height: CGFloat) {
        if height < 0 {
            height = UIScreen.mainScreen().bounds.height - height
        }
        let frame = CGRect(x: 0, y: y, width: UIScreen.mainScreen().bounds.width, height: height)
        vc.view.frame = frame
        vc.view.autoresizingMask = []
    }
    
    
    func setChildAndSetSubView(father:UIViewController, vc: UIViewController) {
        father.addChildViewController(vc)
        vc.didMoveToParentViewController(father)
        father.view.addSubview(vc.view)
    }
    
    
    func makeToBeChildAndSetSubView(vc:UIViewController) {
        setChildAndSetSubView(self,vc: vc)
    }
    
    private func removeChild(childVC: UIViewController) {
        childVC.willMoveToParentViewController(nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        webManager.initSession()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        webManager.cancelSession()
    }

    func refreshNoti() {
        if self.viewManager.earlistDueDate != nil {
            let timeInterval = self.viewManager.earlistDueDate!.timeIntervalSinceDate(NSDate())
            if timeInterval < 3 {
                let upper = max(3, self.silentTime)
                sendNoti( upper , message: "该背单词了") //当前有due没有完成,3秒后发通知
            }else {
                let upper = max(timeInterval,self.silentTime)
                sendNoti(upper,message: "该背单词了")
            }
        }
    }
    
    
    func sendNoti(timeInterval:NSTimeInterval,message:String) {
        let noti:UILocalNotification = UILocalNotification()
        
        let date = NSDate(timeIntervalSinceNow: timeInterval)
        
        noti.fireDate = date
        
        noti.timeZone = NSTimeZone.defaultTimeZone()
        
        noti.repeatInterval = NSCalendarUnit.Minute
        
        noti.alertBody = message
        
        noti.soundName = UILocalNotificationDefaultSoundName
        
        noti.applicationIconBadgeNumber = 1
        
        noti.userInfo = ["url" : "http://www.baidu.com"]
        
        let application = UIApplication.sharedApplication()
        
        application.scheduleLocalNotification(noti)
    }
    
    
    func cancelAllNoti() {
        let application = UIApplication.sharedApplication()
        application.cancelAllLocalNotifications()
    }
    
    
    

}
