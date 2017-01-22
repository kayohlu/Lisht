//
//  CustomPushAnimationController.swift
//  Lisht
//
//  Created by Karl Grogan on 24/12/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

// This class is a custom animation controller. It implements the UIViewControllerAnimatedTransitioning protocol.
// The code cotained here in is used to perform the animation.

class CustomPushAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 2.5
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
  }
}
