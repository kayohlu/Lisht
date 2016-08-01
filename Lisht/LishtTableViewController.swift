//
//  LishtTableViewController.swift
//  Lisht
//
//  Created by Karl Grogan on 10/07/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import UIKit

class LishtTableViewController: UITableViewController, UITextFieldDelegate, SwipeCellDelegate {
  
  var items = [Item]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.tableView.rowHeight = 66.0
    
    // Initialize the first table cell as an empty Item.
    self.items.append(Item(text: nil))
    
    // Register the SwipeViewCell as the Cell class/type we want to use to represent our Swipeable cells.
    self.tableView.registerClass(SwipeCell.self, forCellReuseIdentifier: "SwipeCell")
    
    
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
    let cell: SwipeCell
    
    // If the item at the index path has no text then I'm assuming it's the first cell at the top with just the placeholder.
    // I want this cell to not be swipeable. This means it won't be deleted from the able view if someone tries to swipe on it.
    // All the other cells should be swipeable.
    if self.items[indexPath.row].text == nil {
      cell = SwipeCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil, disableSwipe: true, cellHeight: self.tableView.rowHeight)
    } else {
      cell = SwipeCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil, cellHeight: self.tableView.rowHeight)
    }
    
    
    cell.textField.text = self.items[indexPath.row].text    
    cell.textField.delegate = self
    let preferredDescriptor = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    let font = UIFont(name: "Roboto-Light", size: preferredDescriptor.pointSize)
    cell.textField.font = font
    cell.tag = indexPath.row
    cell.delegate = self
    return cell
  }
  
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
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
  
  // MARK: - SwipeCell delegate method.
  func cellDidCompleteSwipe(cell: SwipeCell) {
    let indexPath = self.tableView.indexPathForCell(cell)
    self.items.removeAtIndex(indexPath!.row)
    self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
    UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut, animations: {
      var newFrame = cell.frame
      newFrame.origin.y -= self.tableView.rowHeight
      cell.frame = newFrame
      }, completion: nil)
    
  }
}
