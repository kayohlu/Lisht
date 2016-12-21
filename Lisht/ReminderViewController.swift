//
//  ReminderViewController.swift
//  Lisht
//
//  Created by Karl Grogan on 07/08/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import UIKit
import Timepiece
import CNPGridMenu

class ReminderViewController: UIViewController, CNPGridMenuDelegate {
  var didSelectReminder: () -> () = {} // Empty block instance variable so when the instance is created it is provided then.
  var didDismissReminder: () -> () = {} // Empty block instance variable so when the instance is created it is provided then.
  var containerView: UIView!
  var tableView: UITableView!
  var collectionView: UICollectionView!
  var blurView: UIView!
  
  
  override func viewDidLoad() {
    let laterToday = CNPGridMenuItem()
    laterToday.icon = UIImage(named: "LaterToday")
    laterToday.title = "Later Today";
    
    let gridMenu = CNPGridMenu(menuItems: [laterToday])
    gridMenu.delegate = self
    self.presentGridMenu(gridMenu, animated: true, completion: nil)

  
    // Do any additional setup after loading the view, typically from a nib.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidAppear(animated: Bool) {
  }
  
  override func viewDidDisappear(animated: Bool) {
  }
}