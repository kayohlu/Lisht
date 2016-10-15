//
//  ReminderViewController.swift
//  Lisht
//
//  Created by Karl Grogan on 07/08/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import UIKit
import Timepiece

class ReminderViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  var didSelectReminder: () -> () = {} // Empty block instance variable so when the instance is created it is provided then.
  var didDismissReminder: () -> () = {} // Empty block instance variable so when the instance is created it is provided then.
  var containerView: UIView!
  var tableView: UITableView!
  var collectionView: UICollectionView!
  var blurView: UIView!
  var reminderTimes: [String] = [
    "Later Today",
    "Tomorrow",
    "At The Weekend",
    "A Specific Time"
  ]
  
  override func viewDidLoad() {
    self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    
    self.view.backgroundColor = UIColor.clearColor()
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 210, left: 60, bottom: 10, right: 60)
    layout.itemSize = CGSize(width: 90, height: 120)
    
    self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    self.collectionView.backgroundColor = UIColor.clearColor()
    self.view.addSubview(collectionView)
    
    setupBlurView()
    addGestureRecognisers()
    
    // Do any additional setup after loading the view, typically from a nib.
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }

    override func viewDidAppear(animated: Bool) {
      print(self.blurView.alpha, terminator: "")
      UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
        print("animation", terminator: "")
        self.blurView.alpha = 1.0
        }, completion: { (finished: Bool) in
          print(self.blurView.alpha, terminator: "")
      })
    }
  
  override func viewDidDisappear(animated: Bool) {
    print(self.blurView.alpha, terminator: "")
    UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
      print("animation", terminator: "")
      self.blurView.alpha = 0.0
      }, completion: { (finished: Bool) in
        print(self.blurView.alpha, terminator: "")
    })
  }
  
  func setupBlurView() {
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    
    self.blurView = UIVisualEffectView(effect: blurEffect)
    self.blurView.frame = self.view.bounds;
    self.blurView.alpha = 0.0
    self.blurView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
    
    self.collectionView.backgroundView = self.blurView
  }
  
  func addGestureRecognisers() {
    let swallowGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReminderViewController.swallowTouch))
    // WARNING: Why do I have to do this?
    swallowGestureRecogniser.cancelsTouchesInView = false
    self.collectionView.addGestureRecognizer(swallowGestureRecogniser)
    
    let dismissGestureRecogniser: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ReminderViewController.dismissVC))
    self.collectionView.backgroundView!.addGestureRecognizer(dismissGestureRecogniser)
    
  }
  
  func dismissVC(sender: AnyObject)  {
    self.dismissViewControllerAnimated(false, completion: nil)
    didDismissReminder()
  }
  
  func swallowTouch(sender: AnyObject) {
    // Swallowing touches.
  }
  
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
    cell.backgroundColor = UIColor.clearColor()
    cell.contentView.backgroundColor = UIColor.clearColor()
    
    let vibrancyEffect = UIVibrancyEffect(forBlurEffect: UIBlurEffect(style: UIBlurEffectStyle.Light))
    
    let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
    vibrancyView.frame = cell.contentView.bounds
    
    
    cell.contentView.addSubview(vibrancyView)
    
    let circleBUttonFrame = CGRectMake(10, 0, cell.contentView.bounds.size.width-20, cell.contentView.bounds.size.width-20)
    let circleButton = UIButton(frame: circleBUttonFrame)
    circleButton.backgroundColor = UIColor.clearColor()
    circleButton.layer.borderColor = UIColor.redColor().CGColor
    circleButton.layer.cornerRadius = circleButton.bounds.size.width / 2
    
    circleButton.layer.borderWidth = 1.0

    
    vibrancyView.contentView.addSubview(circleButton)
    
    
//    let iconView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
//    iconView.tintColor = UIColor.whiteColor()// UIColor.darkGrayColor()
//    iconView.contentMode = UIViewContentMode.ScaleAspectFit
//    iconView.center = circleButton.center
//    
//    vibrancyView.contentView.addSubview(iconView)
//    
//    
//    let titleLabelFrame = CGRectMake(0, CGRectGetMaxY(circleButton.bounds), cell.contentView.bounds.size.width, cell.contentView.bounds.size.height - CGRectGetMaxY(circleButton.bounds))
//    let titleLabel = UILabel(frame: titleLabelFrame)
//    titleLabel.textColor = UIColor.whiteColor()// UIColor.darkGrayColor()
//    titleLabel.numberOfLines = 2
//    titleLabel.textAlignment = NSTextAlignment.Center
//    
//    vibrancyView.contentView.addSubview(titleLabel)
    

    return cell
  }
}