//
//  LishtTableViewController.swift
//  Lisht
//
//  Created by Karl Grogan on 10/07/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import UIKit

class LishtTableViewController: UITableViewController, UITextFieldDelegate {
    
    var items = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize the first table cell as an empty Item.
        self.items.append(Item(text: nil))
        
        // Register the SwipeViewCell as the Cell class/type we want to use to represent our Swipeable cells.
        self.tableView.registerClass(SwipeViewCell.self, forCellReuseIdentifier: "SwipeViewCell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("SwipeViewCell", forIndexPath: indexPath) as! SwipeViewCell
        
        cell.textField.text = self.items[indexPath.row].text
        cell.textField.delegate = self
        cell.tag = indexPath.row
        
        return cell
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print(textField)
        print(textField.superview)
        print(textField.superview!.superview!.superview!.tag)
        
        let itemIndex = textField.superview!.superview!.superview!.tag
        
        if textField.text != "" {
            if itemIndex > 0 {
                let item = self.items[itemIndex]
                item.text = textField.text
            } else {
            self.items.append(Item(text: textField.text))
            }
        }
        
        self.tableView.reloadData()
        return true
    }
}
