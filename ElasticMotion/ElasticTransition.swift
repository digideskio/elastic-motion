//
//  ElasticTransition.swift
//  ElasticMotion
//
//  Created by jongwon woo on 2016. 3. 25..
//  Copyright © 2016년 jongwonwoo. All rights reserved.
//

import Foundation
import UIKit

public class ElasticTransition : NSObject, ElasticMotionStateMachineDelegate {

    let presentedViewController: UIViewController
    let presentingViewWidth: Float
    
    let stateMachine:ElasticMotionStateMachine
    let threshold: Float
    
    init(presentedViewController: UIViewController, presentingViewWidth: Float, direction: ElasticMotionDirection) {
        self.presentedViewController = presentedViewController
        self.presentingViewWidth = presentingViewWidth
        
        self.threshold = presentingViewWidth / 2
        self.stateMachine = ElasticMotionStateMachine(direction, threshold: threshold, vibrationSec: 0.5)
        
        super.init()
        
        self.stateMachine.delegate = self
    }
    
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let currentPoint = recognizer.translationInView(presentedViewController.view)
        
        switch recognizer.state {
        case .Began, .Changed:
            stateMachine.keepMoving(currentPoint)
        default:
            stateMachine.stopMoving()
        }
    }
    
    func elasticMotionStateMachine(stateMachine: ElasticMotionStateMachine, didChangeState state: ElasticMotionState, deltaPoint: CGPoint) {
        switch stateMachine.direction {
        case .Right:
            self.handleRightDirection(state, deltaPoint: deltaPoint)
        case .Left:
            self.handleLeftDirection(state, deltaPoint: deltaPoint)
        case .Bottom:
            self.handleBottomDirection(state, deltaPoint: deltaPoint)
        case .Top:
            self.handleTopDirection(state, deltaPoint: deltaPoint)
        }
    }
    
    // TODO: make subclass
    func handleRightDirection(state: ElasticMotionState, deltaPoint: CGPoint) {
        let fullOpenedWidth = CGFloat(presentingViewWidth)
        switch state {
        case .MayOpen:
            let newOriginX = presentedViewController.view.frame.origin.x + deltaPoint.x
            if newOriginX >= 0 && newOriginX < CGFloat(threshold) {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x + deltaPoint.x, presentedViewController.view.center.y)
            }
        case .WillOpen:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2 + CGFloat(threshold), presentedViewController.view.center.y)
        case .Opened:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2 + fullOpenedWidth, presentedViewController.view.center.y)
        case .MayClose:
            let newOriginX = presentedViewController.view.frame.origin.x + deltaPoint.x
            if newOriginX >= 0 && newOriginX < fullOpenedWidth {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x + deltaPoint.x, presentedViewController.view.center.y)
            }
        case .WillClose:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2 + CGFloat(threshold), presentedViewController.view.center.y)
        case .Closed:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2, presentedViewController.view.center.y)
        }
    }
    
    func handleLeftDirection(state: ElasticMotionState, deltaPoint: CGPoint) {
        let fullOpenedWidth = CGFloat(presentingViewWidth)
        switch state {
        case .MayOpen:
            let newOriginX = presentedViewController.view.frame.origin.x + deltaPoint.x
            if newOriginX <= 0 && -(newOriginX) < CGFloat(threshold) {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x + deltaPoint.x, presentedViewController.view.center.y)
            }
        case .WillOpen:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2 - CGFloat(threshold), presentedViewController.view.center.y)
        case .Opened:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2 - fullOpenedWidth, presentedViewController.view.center.y)
        case .MayClose:
            let newOriginX = presentedViewController.view.frame.origin.x + deltaPoint.x
            if newOriginX <= 0 && -(newOriginX) < fullOpenedWidth {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x + deltaPoint.x, presentedViewController.view.center.y)
            }
        case .WillClose:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2 - CGFloat(threshold), presentedViewController.view.center.y)
        case .Closed:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.frame.width / 2, presentedViewController.view.center.y)
        }
    }
    
    func handleBottomDirection(state: ElasticMotionState, deltaPoint: CGPoint) {
        let fullOpenedWidth = CGFloat(presentingViewWidth)
        switch state {
        case .MayOpen:
            let newOriginY = presentedViewController.view.frame.origin.y + deltaPoint.y
            if newOriginY >= 0 && newOriginY < CGFloat(threshold) {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.center.y + deltaPoint.y)
            }
        case .WillOpen:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2 + CGFloat(threshold))
        case .Opened:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2 + fullOpenedWidth)
        case .MayClose:
            let newOriginY = presentedViewController.view.frame.origin.y + deltaPoint.y
            if newOriginY >= 0 && newOriginY < fullOpenedWidth {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.center.y + deltaPoint.y)
            }
        case .WillClose:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2 + CGFloat(threshold))
        case .Closed:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2)
        }
    }
    
    func handleTopDirection(state: ElasticMotionState, deltaPoint: CGPoint) {
        let fullOpenedWidth = CGFloat(presentingViewWidth)
        switch state {
        case .MayOpen:
            let newOriginY = presentedViewController.view.frame.origin.y + deltaPoint.y
            if newOriginY <= 0 && -(newOriginY) < CGFloat(threshold) {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.center.y + deltaPoint.y)
            }
        case .WillOpen:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2 - CGFloat(threshold))
        case .Opened:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2 - fullOpenedWidth)
        case .MayClose:
            let newOriginY = presentedViewController.view.frame.origin.y + deltaPoint.y
            if newOriginY <= 0 && -(newOriginY) < fullOpenedWidth {
                presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.center.y + deltaPoint.y)
            }
        case .WillClose:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2 - CGFloat(threshold))
        case .Closed:
            presentedViewController.view.center = CGPointMake(presentedViewController.view.center.x, presentedViewController.view.frame.height / 2)
        }
    }
}