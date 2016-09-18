//
//  ReminderViewController.swift
//  Lisht
//
//  Created by Karl Grogan on 07/08/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import UIKit
import Timepiece

class ReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var didSelectReminder: () -> () = {} // Empty block instance variable so when the instance is created it is provided then.
  var didDismissReminder: () -> () = {} // Empty block instance variable so when the instance is created it is provided then.
  var containerView: UIView!
  var tableView: UITableView!
  var reminderTimes: [String] = [
    "Later Today",
    "Tomorrow",
    "At The Weekend",
    "A Specific Time"
  ]
  
  init() {
    super.init(nibName: nil, bundle: nil)
    view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        
    createBlurView()
    createContainerViewAndLayoutContraints()
    createTableViewAndLayoutContraints()
    addGestureRecognisers()
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
  }
  
  func createBlurView() {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let beView = UIVisualEffectView(effect: blurEffect)
    beView.frame = self.view.bounds;
    self.view.insertSubview(beView, atIndex: 0)
  }
  
  func createContainerViewAndLayoutContraints() {
    containerView = UIView(frame: self.view.frame)
    containerView.layer.cornerRadius = 5;
    containerView.layer.masksToBounds = true;
    self.view.addSubview(containerView)
    
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.CenterX , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.CenterY , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0).active = true
    
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 100.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Bottom , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -100.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 20.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Trailing , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -20.0).active = true
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func createTableViewAndLayoutContraints() {
    tableView = UITableView(frame: containerView.frame, style: UITableViewStyle.Plain)
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 56.0
    tableView.scrollEnabled = false
    tableView.reloadData()
    
    let tableHeaderView = UIView(frame: CGRectMake(0, 0, containerView.frame.size.width, 40))
    // WARNING: Figure out why I have to add 15 points to the x coordinate to align the header with the labels in the table view cells.
    let headerLabel = UILabel(frame: CGRectMake(15, 0, tableHeaderView.frame.size.width, tableHeaderView.frame.size.height))
    let textLabelFont = UIFont(name: "Roboto-Regular", size: UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize)
    headerLabel.text = "Remind Me"
    headerLabel.font = textLabelFont
    headerLabel.textColor = UIColor.whiteColor()
    tableHeaderView.addSubview(headerLabel)
    tableView.tableHeaderView = tableHeaderView
    
    tableView.tableHeaderView!.backgroundColor = UIColor(red: 111.0/255.0, green: 115/255.0, blue: 210/255.0, alpha: 1.0)
    
    containerView.addSubview(tableView)
    
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.CenterX , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.CenterY , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0).active = true
    
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Bottom , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Leading , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Trailing , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0).active = true
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  func addGestureRecognisers() {
    let swallowGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReminderViewController.swallowTouch))
    // WARNING: Why do I have to do this?
    swallowGestureRecogniser.cancelsTouchesInView = false
    containerView.addGestureRecognizer(swallowGestureRecogniser)
    
    let dismissGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReminderViewController.dismissVC))
    self.view.addGestureRecognizer(dismissGestureRecogniser)
    
  }
  
  func dismissVC(sender: AnyObject)  {
    self.dismissViewControllerAnimated(true, completion: nil)
    didDismissReminder()
  }
  
  func swallowTouch(sender: AnyObject) {
    // Swallowing touches.
  }
  
  // MARK: tableview delegate methods
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return reminderTimes.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let dates = [
      NSDate() + 6.hours, // Later today - 6 hours later
      NSDate.tomorrow() // Same time tomorrow
    ]
    
    let cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "ReminderTableViewCell")
    
    let textLabelFont = UIFont(name: "Roboto-Light", size: UIFont.preferredFontForTextStyle(UIFontTextStyleBody).pointSize)
    cell.textLabel?.font = textLabelFont
    cell.textLabel?.textColor = UIColor.init(red: 87/255, green: 85/255, blue: 91/255, alpha: 1)
    cell.textLabel?.text = reminderTimes[indexPath.row]
    
    let detailTextLabelFont = UIFont(name: "Roboto-Light", size: UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1).pointSize)
    cell.detailTextLabel?.font = detailTextLabelFont
    cell.detailTextLabel?.text = NSDate().stringFromFormat("EEE MMM d, h:mm a")
    cell.detailTextLabel?.textColor = UIColor.init(red: 87/255, green: 85/255, blue: 91/255, alpha: 0.5)
    
    print("Cell recursive description:\n\n\(self.tableView.performSelector(Selector("recursiveDescription")))\n\n")
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    didSelectReminder()
  }
  
}