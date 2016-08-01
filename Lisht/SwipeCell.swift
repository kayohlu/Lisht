//
//  SwipeViewCell.m
//  SwipeCell
//
//  Created by Karl Grogan on 09/07/2016.
//  Copyright (c) 2016 Karl Grogan. All rights reserved.
//

import UIKit

class SwipeCell: UITableViewCell {
  var swipeContentView: UIView!
  var panRecognizer: UIPanGestureRecognizer!
  var numberView: UILabel!
  var amount: Int32!
  var textField: UITextField!
  var delegate: SwipeCellDelegate?
  
  init(style: UITableViewCellStyle, reuseIdentifier: String?, disableSwipe: Bool? = false, cellHeight: CGFloat?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    if (cellHeight != nil) {
      self.frame.size.height = cellHeight!
    }
        
        
    // Add a subView to hold our content that will be swiped.
    // Create a UIView that is the same width, height, and origin as the cell's content view
    self.swipeContentView = UIView(frame: self.contentView.superview!.frame)
    self.swipeContentView.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 250/255, alpha: 1)
    self.contentView.addSubview(self.swipeContentView)
    // Adding color to the content view to make the layers distinguishable.
    self.contentView.backgroundColor = UIColor(red: 122.0/255.0, green: 223.0/255.0, blue: 187.0/255.0, alpha: 1.0)
    // Add color to the swipe content view.
    /*
     *  Initialize the pan gesture recognizer.
     *  This initializes a UIPanGestureRecognizer where the target is this cell instance where
     *  the panning action is handled with the panThisCell method
     */
    
    // Functionality to turn on and off swiping.
    // We disable swiping bt not adding the gesture recogniser for the cell.
    if disableSwipe! == false {
      self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeCell.panThisCell(_:)))
      // Set the recognizer delegate to this cell's instance
      self.panRecognizer.delegate = self
      // Adding the recognizer to our swipeContentView
      self.swipeContentView.addGestureRecognizer(self.panRecognizer)
    }
    
    self.textField = UITextField(frame: CGRectMake(16, self.swipeContentView.frame.origin.y, self.swipeContentView.frame.size.width, self.swipeContentView.frame.size.height))
    self.textField.placeholder = "Tap to add an item."
    self.swipeContentView.addSubview(self.textField)
    //Init amount
    self.amount = 0
        
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  // This method is the handler for the pan gesture we added to the swipeContentView.
  // It takes, as a parameter, the instance of the pan gesture recognizer.
  func panThisCell(recognizer: UIPanGestureRecognizer) {
    // This point represents where the position of the user's finger is relative to where the pan began.
    let panPoint: CGPoint = recognizer.translationInView(self.swipeContentView)
    print("Pan position relative to it's start point: \(NSStringFromCGPoint(panPoint))")
    // Here we handle the three states we are looking for.
    switch recognizer.state {
      
    case UIGestureRecognizerState.Began:
      
      print("Pan Gesture began.")
      
      print("Cell recursive description:\n\n\(self.performSelector(Selector("recursiveDescription")))\n\n")
      
      let translation: CGPoint = recognizer.translationInView(self.swipeContentView)
      // Since we have added the recognizer to the swipContentView above, we can access the view from the recognizer
      // via it's view property.
      recognizer.view!.center = CGPointMake(recognizer.view!.center.x+translation.x, recognizer.view!.center.y)
      // This line resets the translation of the recognizer every time the Began state is triggered.
      recognizer.setTranslation(CGPointMake(0, 0), inView: self.swipeContentView)
      
    //break
    case UIGestureRecognizerState.Changed:
      
      print("Pan Gesture changed.")
      let translation: CGPoint = recognizer.translationInView(self.swipeContentView)
      // Since we have added the recognizer to the swipContentView above, we can access the view from the recognizer
      // via it's view property.
      recognizer.view!.center = CGPointMake(recognizer.view!.center.x+translation.x, recognizer.view!.center.y)
      // This line resets the translation of the recognizer every time the Changed state is triggered.
      recognizer.setTranslation(CGPointMake(0, 0), inView: self.swipeContentView)
      
      self.numberViewTrigger()
      
      if (self.numberView != nil) {
        self.amount = self.amount + 1
        self.numberView.text = NSNumber(int: self.amount).stringValue
      }
      
    //break
    case UIGestureRecognizerState.Ended:
      
      print("Pan gesture ended.")
      
      
      print("Cell recursive description:\n\n\(self.performSelector(Selector("recursiveDescription")))\n\n")
      
      // Check for trigger point.
      self.calculateTrigger()
    //break
    default:
      
      print("Pan gesture unknown behaviour")
      //break
    }
  }
  
  
  
  func calculateTrigger() {
    print("Calculating trigger point.")
    // Formula for caluclating the percentages is: current x coordinate of the view's origin divided by the width.
    let currentSwipPercentage: CGFloat = (((self.panRecognizer.view!.frame.origin.x/(self.panRecognizer.view!.frame.size.width))*100))
    print("Current swipe percentage: \(currentSwipPercentage)")
    // Logic to decide what the trigger points are.
    // If the swipe is not greater than or equal to the a 40% this will allow the user to cancel what they want to do.
    if currentSwipPercentage <= 40.0 {
      print("Cancel trigger point.")
      /*
       *  The below animation logic chains the animations we want to do when the user 'cancels' their swipe.
       *  The first animations slides the view aback to its original position.
       *  The second animation(inside the first animation's completion block) gives the return animation a little bounce by sliding it in the opposite direction 1 point.
       The third (inside the seconf animation's completion block) animation does the same thing as the first and animates the view back to its original position.
       */
      
      UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
        //UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationCurve.EaseInOut, .CurveEaseInOut, animations: {
        print("Returning animation")
        // Use the frame of the super view because its frame contains the original position we want
        // to set the final position of the swipeContentView
        self.panRecognizer.view!.frame = self.panRecognizer.view!.superview!.frame
        
        }, completion: { (finished: Bool) in
          // Completion block of the first animation
          UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            print("Returning animation")
            // This will be the final destination of the bounce animation. It's the same as its original postioin plus one point on hte x-axis.
            self.panRecognizer.view!.frame = CGRectMake(self.panRecognizer.view!.superview!.frame.origin.x+1, self.panRecognizer.view!.superview!.frame.origin.y, self.panRecognizer.view!.frame.size.width, self.panRecognizer.view!.frame.size.height)
            
            }, completion: { (finished: Bool) in
              // Completion block of the second animation.
              print("Returning animation")
              
              UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                // Use the frame of the super view because it's frame contains the original position we want
                // to set the final position of the swipeContentView
                self.panRecognizer.view!.frame = self.panRecognizer.view!.superview!.frame
                }, completion: nil)
              
          })
          
      })
    } else {
      print("Apply swipe action trigger point.")
      //            UIView.beginAnimations(nil, context: nil)
      //            UIView.animationDuration = 0.3
      //            UIView.animationDelay = 0
      //            UIView.animationCurve = UIViewAnimationCurveEaseInOut
      
      UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
        self.panRecognizer.view!.frame = CGRectMake(self.panRecognizer.view!.superview!.frame.size.width, self.panRecognizer.view!.superview!.frame.origin.y, self.panRecognizer.view!.frame.size.width, self.panRecognizer.view!.frame.size.height)
        //UIView.commitAnimations()
        
        }, completion: { _ in
          self.delegate?.cellDidCompleteSwipe(self)
      })
      
    }
  }
  
  func numberViewTrigger() {
    print("Calculating display view trigger point.")
    // Formula for caluclating the percentages is: current x coordinate of the view's origin divided by the width.
    let currentSwipePercentage: CGFloat = (((self.panRecognizer.view!.frame.origin.x/(self.panRecognizer.view!.frame.size.width))*100))
    print("Current swipe percentage: \(currentSwipePercentage)")
    // Logic to decide what the trigger points are.
    // If the swipe is not greater than or equal to the a 40% this will allow the user to cancel what they want to do.
    if currentSwipePercentage <= 40.0 {
      
      if self.numberView != nil {
        print("Remove number view trigger point.")
        // Remove number view from superview.
        self.numberView!.removeFromSuperview()
        // Reset the number view.
        self.numberView!.text = NSNumber(int: 0).stringValue
      }
      
    } else {
      // We only want to create the view if one doesn't already exist.
      // Since this method is being called when the pan state has changed, it would create a view each time this event is fired.
      if (self.numberView == nil) {
        self.numberView = UILabel(frame: CGRectMake(self.panRecognizer.view!.superview!.frame.origin.x, self.panRecognizer.view!.superview!.frame.origin.y, self.panRecognizer.view!.frame.size.width/3, self.panRecognizer.view!.frame.size.height))
        self.numberView.backgroundColor = UIColor.greenColor()
        // Initialize the counter with self.amount.
        self.numberView.text = NSNumber(int: self.amount).stringValue
        print("Adding numnber view as a subview to the swipeContentView")
        // Create the number view
        self.swipeContentView.superview!.addSubview(self.numberView)
      } else {
        // If an instance of the numberView already exists we just want to add as a sub view.
        // This covers the case where the user swiped passed the trigger point then went back but decide to go
        // back again.
        self.swipeContentView.superview!.addSubview(self.numberView)
        
      }
      
    }
  }
  
  /*
   UIPanGestureRecognizer can sometimes interfere with the one which handles the scroll action on the UITableView. Since you’ve already set up the cell to be the pan gesture recognizer’s UIGestureRecognizerDelegate, you only have to implement one (comically verbosely named) delegate method to make this work.
   */
  override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

