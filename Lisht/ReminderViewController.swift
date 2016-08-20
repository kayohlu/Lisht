//
//  ReminderViewController.swift
//  Lisht
//
//  Created by Karl Grogan on 07/08/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import UIKit

class ReminderViewController: UIViewController {

  override func viewDidLoad() {
    self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    
    
        
    let containerView: UIView = UIView(frame: self.view.frame)    
    containerView.layer.cornerRadius = 5;
    containerView.layer.masksToBounds = true;
    self.view.addSubview(containerView)
    
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.CenterX , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.CenterY , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0).active = true
    
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 100.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Bottom , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -100.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Leading , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 40.0).active = true
    NSLayoutConstraint(item: containerView, attribute: NSLayoutAttribute.Trailing , relatedBy: .Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -40.0).active = true
    
    containerView.translatesAutoresizingMaskIntoConstraints = false
    
    
    let tableView: UITableView = UITableView(frame: containerView.frame)
    containerView.addSubview(tableView)
    
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.CenterX , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.CenterY , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0).active = true
    
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Top , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Bottom , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Leading , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0.0).active = true
    NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.Trailing , relatedBy: .Equal, toItem: containerView, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0.0).active = true
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    
    let dismissGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReminderViewController.dismissVC))
    self.view.addGestureRecognizer(dismissGestureRecogniser)
    
    let swallowGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReminderViewController.swallowTouch))
    containerView.addGestureRecognizer(swallowGestureRecogniser)
    
  }
  
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.7)
  }
  
  func dismissVC()  {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  func swallowTouch() {}
}