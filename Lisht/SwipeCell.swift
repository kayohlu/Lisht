//
//  SwipeViewCell.m
//  SwipeCell
//
//  Created by Karl Grogan on 09/07/2016.
//  Copyright (c) 2016 Karl Grogan. All rights reserved.
//

import UIKit

enum SwipeDirection: Int {
  case None
  case LeftToRight
  case RightToLeft
}

class SwipeCell: UITableViewCell {
  var swipeContentView: UIView!
  var panRecognizer: UIPanGestureRecognizer!
  var numberView: UILabel!
  var amount: Int32!
  var textField: UITextField!
  var delegate: SwipeCellDelegate?
  var swipeDirection: SwipeDirection!
  
  init(style: UITableViewCellStyle, reuseIdentifier: String?, disableSwipe: Bool? = false, cellHeight: CGFloat?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    // The cell height may be passed in because the table row height may not be the default on and I want the cell to occupy the full height of the row as well.
    if (cellHeight != nil) { self.frame.size.height = cellHeight! }
    
    // Add a subView to hold our content that will be swiped.
    // Create a UIView that is the same width, height, and origin as the cell's content view
    self.swipeContentView = UIView(frame: self.contentView.superview!.frame)
    self.swipeContentView.backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 250/255, alpha: 1)
    self.contentView.addSubview(self.swipeContentView)
    
    // Functionality to turn on and off swiping.
    // We disable swiping by not adding the gesture recogniser for the cell.
    if disableSwipe! == false {
      /*
       *  Initialize the pan gesture recognizer.
       *  This initializes a UIPanGestureRecognizer where the target is this cell instance where
       *  the panning action is handled with the panThisCell method
       */
      self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(SwipeCell.panThisCell(_:)))
      // Set the recognizer delegate to this cell's instance
      self.panRecognizer.delegate = self
      // Adding the recognizer to our swipeContentView
      self.swipeContentView.addGestureRecognizer(self.panRecognizer)
    }
    
    self.textField = UITextField(frame: CGRectMake(16, self.swipeContentView.frame.origin.y, self.swipeContentView.frame.size.width, self.swipeContentView.frame.size.height))
    
    self.swipeContentView.addSubview(self.textField)
    
    //Init amount
    self.amount = 0
    
    self.swipeDirection = .None
  }
    
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  // This method is the handler for the pan gesture we added to the swipeContentView.
  // It takes, as a parameter, the instance of the pan gesture recognizer.
  func panThisCell(recognizer: UIPanGestureRecognizer) {
    // This point represents where the position of the user's finger is relative to where the pan began.
    let panPoint: CGPoint = recognizer.translationInView(self.swipeContentView)
    print("Pan position relative to it's start point: \(NSStringFromCGPoint(panPoint))", terminator: "")
    
    let translation: CGPoint = recognizer.translationInView(self.swipeContentView)
    
    // Here we handle the three states we are looking for.
    switch recognizer.state {
    case UIGestureRecognizerState.Began:
      setContentViewBackgroundColor(translation)
      print("Pan Gesture began.", terminator: "")
      print("Cell recursive description:\n\n\(self.performSelector(Selector("recursiveDescription")))\n\n")
      translate(recognizer, translation: translation)
    case UIGestureRecognizerState.Changed:
      // WARNING Need to change the backgroundcolor only when the edge is back to its original prositoin.
      setContentViewBackgroundColor(translation)
      print("Pan Gesture changed.", terminator: "")
      translate(recognizer, translation: translation)
    case UIGestureRecognizerState.Ended:
      print("Pan gesture ended.", terminator: "")
      print("Cell recursive description:\n\n\(self.performSelector(Selector("recursiveDescription")))\n\n")
      calculateTrigger() // Check for trigger point to complete the swipe or return to the beginning.
    default:
      break
    }
  }
  
  // Set the background color of the contentView depending on the direction.
  // The swipe is going from left to right if the value is positive, and negative if the swipe is going from right to left.
  func setContentViewBackgroundColor(translation: CGPoint) {
    if translation.x >= 0.0 {
      self.contentView.backgroundColor = UIColor(red: 122.0/255.0, green: 223.0/255.0, blue: 187.0/255.0, alpha: 1.0)
      self.swipeDirection = .LeftToRight
    } else {
      self.contentView.backgroundColor = UIColor(red: 111.0/255.0, green: 115/255.0, blue: 210/255.0, alpha: 1.0)
      self.swipeDirection = .RightToLeft
    }
  }
  
  
  func translate(recognizer: UIPanGestureRecognizer, translation: CGPoint) {
    // Since we have added the recognizer to the swipContentView above, we can access the view from the recognizer
    // via it's view property.
    recognizer.view!.center = CGPointMake(recognizer.view!.center.x+translation.x, recognizer.view!.center.y)
    // This line resets the translation of the recognizer every time the Began state is triggered.
    recognizer.setTranslation(CGPointMake(0, 0), inView: self.swipeContentView)
  }
  
  func calculateTrigger() {
    print("Calculating trigger point.", terminator: "")
    // Formula for caluclating the percentages is: current x coordinate of the view's origin divided by the width.
    let currentSwipPercentage: CGFloat = (((self.panRecognizer.view!.frame.origin.x/(self.panRecognizer.view!.frame.size.width))*100))
    print("Current swipe percentage: \(currentSwipPercentage)", terminator: "")
    // Logic to decide what the trigger points are.
    // If the swipe is not greater than or equal to the a 40% this will allow the user to cancel what they want to do.
    if fabs(currentSwipPercentage) <= 40.0 {
      print("Cancel trigger point.", terminator: "")
      /*
       *  The below animation logic chains the animations we want to do when the user 'cancels' their swipe.
       *  The first animations slides the view aback to its original position.
       *  The second animation(inside the first animation's completion block) gives the return animation a little bounce by sliding it in the opposite direction 1 point.
       The third (inside the seconf animation's completion block) animation does the same thing as the first and animates the view back to its original position.
       */
      
      UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
        //UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationCurve.EaseInOut, .CurveEaseInOut, animations: {
        print("Returning animation", terminator: "")
        // Use the frame of the super view because its frame contains the original position we want
        // to set the final position of the swipeContentView
        self.panRecognizer.view!.frame = self.panRecognizer.view!.superview!.frame
        
        }, completion: { (finished: Bool) in
          // Completion block of the first animation
          UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
            print("Returning animation", terminator: "")
            // This will be the final destination of the bounce animation. It's the same as its original postioin plus one point on hte x-axis.
            if self.swipeDirection == .LeftToRight {
              self.panRecognizer.view!.frame = CGRectMake(self.panRecognizer.view!.superview!.frame.origin.x+1, self.panRecognizer.view!.superview!.frame.origin.y, self.panRecognizer.view!.frame.size.width, self.panRecognizer.view!.frame.size.height)
            } else if self.swipeDirection == .RightToLeft {
              self.panRecognizer.view!.frame = CGRectMake(self.panRecognizer.view!.superview!.frame.origin.x-1, self.panRecognizer.view!.superview!.frame.origin.y, self.panRecognizer.view!.frame.size.width, self.panRecognizer.view!.frame.size.height)
            }
            
            }, completion: { (finished: Bool) in
              // Completion block of the second animation.
              print("Returning animation", terminator: "")
              
              UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
                // Use the frame of the super view because it's frame contains the original position we want
                // to set the final position of the swipeContentView
                self.panRecognizer.view!.frame = self.panRecognizer.view!.superview!.frame
                }, completion: nil)
              
              self.swipeDirection = .None // Reset swipe direction.
              
          })
          
      })
    } else {
      print("Apply swipe action trigger point.", terminator: "")
      UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
        if self.swipeDirection == .LeftToRight {
          self.panRecognizer.view!.frame = CGRectMake(self.panRecognizer.view!.superview!.frame.size.width, self.panRecognizer.view!.superview!.frame.origin.y, self.panRecognizer.view!.frame.size.width, self.panRecognizer.view!.frame.size.height)
        } else if self.swipeDirection == .RightToLeft {
          self.panRecognizer.view!.frame = CGRectMake(-self.panRecognizer.view!.superview!.frame.size.width, -self.panRecognizer.view!.superview!.frame.origin.y, self.panRecognizer.view!.frame.size.width, self.panRecognizer.view!.frame.size.height)
        }
        
        
        }, completion: { _ in
          self.delegate?.cellDidCompleteSwipe(self)
      })
      
    }
  }
  
  func closeCell() {
    UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: {
      self.panRecognizer.view!.frame = self.panRecognizer.view!.superview!.frame
    }, completion: nil)
  }
  
  /*
   UIPanGestureRecognizer can sometimes interfere with the one which handles the scroll action on the UITableView. Since you’ve already set up the cell to be the pan gesture recognizer’s UIGestureRecognizerDelegate, you only have to implement one (comically verbosely named) delegate method to make this work.
   */
  override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    if gestureRecognizer.state == .Began || gestureRecognizer.state == .Changed {
      return false
    }
    return true
  }
}

