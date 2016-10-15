  //
//  ModalAnimationController.swift
//  Lisht
//
//  Created by Karl Grogan on 17/09/2016.
//  Copyright © 2016 Karl Grogan. All rights reserved.
//

import UIKit

class ModalAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return 5.0
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
    let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
    let finalFrameForVC = transitionContext.finalFrameForViewController(toViewController)
    let containerView = transitionContext.containerView()
    let bounds = UIScreen.mainScreen().bounds
    toViewController.view.frame = CGRectOffset(finalFrameForVC, bounds.size.width, 0)
    containerView!.addSubview(toViewController.view)
    
    UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .CurveLinear, animations: {
      fromViewController.view.alpha = 0.5
      toViewController.view.frame = finalFrameForVC
      }, completion: {
        finished in
        transitionContext.completeTransition(true)
        fromViewController.view.alpha = 1.0
    })
  
  
  }
  

}
