//
//  ViewController+TransitionDelegate.swift
//  AnimationDemo
//
//  Created by mac-0009 on 04/08/21.
//


import UIKit

// 1
extension ViewController: UIViewControllerTransitioningDelegate {

	// 2
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		// 16
		guard let firstViewController = presenting as? ViewController,
			let secondViewController = presented as? MapViewController
			else {
			return nil
		}
		animator = Animator(type: .present, firstViewController: firstViewController, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot ?? UIView())
		return animator
	}

	// 3
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		// 17
		guard let secondViewController = dismissed as? MapViewController
			else { return nil }

		animator = Animator(type: .dismiss, firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot ?? UIView())
		return animator
	}
}
