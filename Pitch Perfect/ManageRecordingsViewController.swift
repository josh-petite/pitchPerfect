//
//  ManageRecordingsViewController.swift
//  Pitch Perfect
//
//  Created by Josh Petite on 5/13/15.
//  Copyright (c) 2015 Josh Petite. All rights reserved.
//

import Foundation
import UIKit

class ManageRecordingsViewController : UITableViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!

    var files : NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dirPath = getDocumentsPath()
        files = getFilesAtPath(dirPath)
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func getDocumentsPath() -> String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        var documentPath = getDocumentsPath()
        var fileName = files!.objectAtIndex(indexPath.row) as! String
        var fileSize : UInt64 = 0
        var defaultManager = NSFileManager.defaultManager()
        
        if let attributes : NSDictionary = defaultManager.attributesOfItemAtPath(documentPath.stringByAppendingPathComponent(fileName), error: nil) {
            fileSize += attributes.fileSize()
        }
        
        cell.textLabel!.text = determineCellLabel(fileName, fileSize: fileSize)
        return cell
    }
    
    func determineCellLabel(fileName: String, fileSize: UInt64) -> String {
        if (fileSize > 1024 * 1024 * 1024) {
          return "\(fileName) (\(fileSize/(1024*1024*1024))GB)"
        } else if (fileSize > 1024 * 1024) {
             return "\(fileName) (\(fileSize/(1024*1024))MB)"
        } else {
            return "\(fileName) (\(fileSize/1024)KB)"
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var documentPath = getDocumentsPath()
            var fileName = files![indexPath.row] as! String
            var filePath = documentPath.stringByAppendingPathComponent(fileName)
            NSFileManager.defaultManager().removeItemAtPath(filePath, error: nil)
            
            files!.removeObjectAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func getFilesAtPath(path: String) -> NSMutableArray {
        var directoryContent = NSFileManager.defaultManager().contentsOfDirectoryAtPath(path, error: nil) as NSArray?
        return directoryContent?.mutableCopy() as! NSMutableArray
    }
}