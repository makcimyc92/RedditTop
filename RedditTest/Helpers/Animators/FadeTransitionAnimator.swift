//
//  FadeTransitionAnimator.swift
//  RedditTest
//
//  Created by Max Vasilevsky on 4/3/20.
//  Copyright © 2020 Max Vasilevsky. All rights reserved.
//

import UIKit

class FadeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let animationDuration = 0.25

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to),
            let fromVC = transitionContext.viewController(forKey: .from) else {
                return
        }
        toVC.view.alpha = 0.0
        transitionContext.containerView.addSubview(fromVC.view)
        transitionContext.containerView.addSubview(toVC.view)

        UIView.animate(withDuration: animationDuration, animations: {
            toVC.view.alpha = 1.0
        }) { (completed) in
            fromVC.view.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
