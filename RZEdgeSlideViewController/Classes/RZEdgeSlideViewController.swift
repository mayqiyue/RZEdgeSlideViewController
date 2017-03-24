//
//  RZEdgeSlideViewController.swift
//  RZEgeSlideViewController
//
//  Created by Mayqiyue on 17/03/2017.
//  Copyright © 2017 mayqiyue. All rights reserved.
//

import UIKit

@objc public protocol RZEdgeSlideViewControllerDelegate {
    @objc optional func edgeSlideViewController(_ viewController: RZEdgeSlideViewController, willChangeTo state: RZEdgeSlideViewController.DrawerState)
    @objc optional func edgeSlideViewController(_ viewController: RZEdgeSlideViewController, didChangeTo state: RZEdgeSlideViewController.DrawerState)
   
    // changedePercent: {-1.0 ~ 1.0}; -1.0 means switch to DrawerState.left, 0.0 means .center 1.0 means .right
    @objc optional func edgeSlideViewController(_ viewController: RZEdgeSlideViewController, changedePercent: CGFloat); 
}

open class RZEdgeSlideViewController : UIViewController, UIGestureRecognizerDelegate {
    
    /**************************************************************************/
    // MARK: - Types
    /**************************************************************************/
    
    @objc public enum DrawerState: Int {
        case left, center, right
    }
    
    /**************************************************************************/
    // MARK: - Properties
    /**************************************************************************/
    
    @IBInspectable public var containerViewMaxAlpha: CGFloat = 0.2
    
    @IBInspectable public var drawerAnimationDuration: TimeInterval = 0.25
    
    private var _leftWidthConstraint: NSLayoutConstraint!
    
    private var _rightWidthConstraint: NSLayoutConstraint!
    
    private var _leftTrailingConstraint: NSLayoutConstraint!
    
    private var _panStartLocation = CGPoint.zero
    
    private var _constraitStartConstant : CGFloat = 0.0
    
    private var _panDelta: CGFloat = 0
    
    private var _state: DrawerState = .center
    
    private lazy var leftContaienrView : UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var rightContainerView : UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var swipeEnabled = true
    
    public private(set) lazy var screenEdgePanGesture: UIScreenEdgePanGestureRecognizer = {
        let gesture = UIScreenEdgePanGestureRecognizer(
            target: self,
            action: #selector(RZEdgeSlideViewController.handlePanGesture(_:))
        )
        gesture.delegate = self
        gesture.edges = UIRectEdge.init(rawValue: UIRectEdge.left.rawValue | UIRectEdge.right.rawValue)
        return gesture
    }()
    
    public private(set) lazy var panGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(RZEdgeSlideViewController.handlePanGesture(_:))
        )
        gesture.delegate = self
        return gesture
    }()
    
    public weak var delegate: RZEdgeSlideViewControllerDelegate?
    
    public var drawerState: DrawerState {
        get {return _state}
        set {setDrawerState(newValue, animated: true) }
    }
    
    @IBInspectable public var drawerWidth: CGFloat = UIScreen.main.bounds.size.width {
        didSet {
            _leftWidthConstraint?.constant = drawerWidth
            _rightWidthConstraint?.constant = drawerWidth
        }
    }
    
    public var displayingViewController: UIViewController? {
        switch drawerState {
        case .left:
            return leftViewController
        case .center:
            return mainViewController
        case .right:
            return rightViewController
        }
    }
    
    public var mainViewController: UIViewController! {
        didSet {
            if let oldController = oldValue {
                oldController.willMove(toParentViewController: nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParentViewController()
            }
            
            guard let mainViewController = mainViewController else { return }
            addChildViewController(mainViewController)
            mainViewController.didMove(toParentViewController: self)
            
            mainViewController.view.translatesAutoresizingMaskIntoConstraints = false
            view.insertSubview(mainViewController.view, at: 0)
            
            let viewDictionary = ["mainView" : mainViewController.view!]
            view.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[mainView]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            view.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-0-[mainView]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            
            mainViewController.didMove(toParentViewController: self)
        }
    }
    
    public var leftViewController : UIViewController? {
        didSet {
            if let oldController = oldValue {
                oldController.willMove(toParentViewController: nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParentViewController()
            }
            
            guard let leftViewController = leftViewController else { return }
            addChildViewController(leftViewController)
            leftViewController.didMove(toParentViewController: self)
            
            
            leftViewController.view.translatesAutoresizingMaskIntoConstraints = false
            leftContaienrView.addSubview(leftViewController.view)
            
            let viewDictionary = ["view" : leftViewController.view!]
            leftContaienrView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[view]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            
            leftContaienrView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-0-[view]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            leftContaienrView.updateConstraints()
            leftViewController.didMove(toParentViewController: self)
        }
    }
    
    public var rightViewController : UIViewController? {
        didSet {
            if let oldController = oldValue {
                oldController.willMove(toParentViewController: nil)
                oldController.view.removeFromSuperview()
                oldController.removeFromParentViewController()
            }
            
            guard let rightViewController = rightViewController else { return }
            addChildViewController(rightViewController)
            rightViewController.didMove(toParentViewController: self)
            
            rightViewController.view.translatesAutoresizingMaskIntoConstraints = false
            rightContainerView.addSubview(rightViewController.view)
            
            let viewDictionary = ["view" : rightViewController.view!]
            rightContainerView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "V:|-0-[view]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            
            rightContainerView.addConstraints(
                NSLayoutConstraint.constraints(
                    withVisualFormat: "H:|-0-[view]-0-|",
                    options: [],
                    metrics: nil,
                    views: viewDictionary
                )
            )
            rightContainerView.updateConstraints()
            rightViewController.didMove(toParentViewController: self)
        }
    }
    
    /**************************************************************************/
    // MARK: - initialize
    /**************************************************************************/
    
    /**************************************************************************/
    // MARK: - Life Cycle
    /**************************************************************************/
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(self.screenEdgePanGesture)
        self.view.addGestureRecognizer(self.panGesture)
        self.view.addSubview(self.leftContaienrView)
        self.view.addSubview(self.rightContainerView)
        
        // Concigure left container view
        var viewDictionary = ["view" : self.leftContaienrView]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
        )
        self.view.addConstraint(
            NSLayoutConstraint(
                item: self.leftContaienrView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.width,
                multiplier: 1.0,
                constant:0.0
            )
        )
        _leftTrailingConstraint = NSLayoutConstraint(
            item: self.leftContaienrView,
            attribute: NSLayoutAttribute.trailing,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.view,
            attribute: NSLayoutAttribute.leading,
            multiplier: 1.0,
            constant:0.0
        )
        self.view.addConstraint(_leftTrailingConstraint)
        
        // Configure right container view
        viewDictionary = ["view" : self.rightContainerView]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[view]-0-|",
                options: [],
                metrics: nil,
                views: viewDictionary
            )
        )
        self.view.addConstraint (
            NSLayoutConstraint(
                item: self.rightContainerView,
                attribute: NSLayoutAttribute.width,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.width,
                multiplier: 1.0,
                constant:0.0
            )
        )
        
        let horizaontalConstraint = NSLayoutConstraint (
            item: self.rightContainerView,
            attribute: NSLayoutAttribute.leading,
            relatedBy: NSLayoutRelation.equal,
            toItem: self.leftContaienrView,
            attribute: NSLayoutAttribute.trailing,
            multiplier: 1.0,
            constant:self.view.bounds.size.width
        )
        self.view.addConstraint(horizaontalConstraint)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        displayingViewController?.beginAppearanceTransition(true, animated: animated)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayingViewController?.endAppearanceTransition()
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayingViewController?.beginAppearanceTransition(false, animated: animated)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        displayingViewController?.endAppearanceTransition()
    }
    
    override open var shouldAutomaticallyForwardAppearanceMethods: Bool {
        get {
            return false
        }
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        switch self._state {
        case .left:
            return self.leftViewController
        case .center:
            return self.mainViewController
        case .right:
            return self.rightViewController
        }
    }
    
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        switch self._state {
        case .left:
            return self.leftViewController
        case .center:
            return self.mainViewController
        case .right:
            return self.rightViewController
        }
    }
    
    
    /**************************************************************************/
    // MARK: - Public Method
    /**************************************************************************/
    
    public func setDrawerState(_ state: DrawerState, animated: Bool) {
        let duration: TimeInterval = animated ? drawerAnimationDuration : 0
        
        let needCallEndAppearanceVCs: NSMutableArray =  NSMutableArray()
        
        if _state != state {
            switch state {
            case .left:
                leftViewController?.beginAppearanceTransition(true, animated: animated)
                needCallEndAppearanceVCs.add(leftViewController!)
                if isViewVisiable(mainViewController.view) {
                    mainViewController?.beginAppearanceTransition(false, animated: animated)
                    needCallEndAppearanceVCs.add(mainViewController)
                }
                if isViewVisiable(rightContainerView) {
                    rightViewController?.beginAppearanceTransition(false, animated: animated)
                    needCallEndAppearanceVCs.add(rightViewController!)
                }
            case .center:
                mainViewController?.beginAppearanceTransition(true, animated: animated)
                needCallEndAppearanceVCs.add(mainViewController)
                if isViewVisiable(leftContaienrView) {
                    leftViewController?.beginAppearanceTransition(false, animated: animated)
                    needCallEndAppearanceVCs.add(leftViewController!)
                }
                if isViewVisiable(rightContainerView) {
                    rightViewController?.beginAppearanceTransition(false, animated: animated)
                    needCallEndAppearanceVCs.add(rightViewController!)
                }
            case .right:
                rightViewController?.beginAppearanceTransition(true, animated: animated)
                needCallEndAppearanceVCs.add(rightViewController!)
                if isViewVisiable(mainViewController.view) {
                    mainViewController?.beginAppearanceTransition(false, animated: animated)
                    needCallEndAppearanceVCs.add(mainViewController)
                }
                if isViewVisiable(leftContaienrView) {
                    leftViewController?.beginAppearanceTransition(false, animated: animated)
                    needCallEndAppearanceVCs.add(leftViewController!)
                }
            }
        }
        
        self.delegate?.edgeSlideViewController?(self, willChangeTo: state);
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: { () -> Void in
                        switch state {
                        case .left:
                            self._leftTrailingConstraint.constant  = self.view.bounds.size.width
                        case .center:
                            self._leftTrailingConstraint.constant  = 0.0
                        case .right:
                            self._leftTrailingConstraint.constant  = -self.view.bounds.size.width
                        }
                        self.view.layoutIfNeeded()
        }) { (finished: Bool) -> Void in
            for obj in needCallEndAppearanceVCs {
                let vc : UIViewController = obj as! UIViewController
                vc.endAppearanceTransition()
            }
            self.delegate?.edgeSlideViewController?(self, didChangeTo: state)
            self._state = state;
        }
    }
    
    /**************************************************************************/
    // MARK: - Private Method
    /**************************************************************************/
    
    final func handlePanGesture(_ sender: UIPanGestureRecognizer) {
       if sender.state == .began {
            _panStartLocation = sender.location(in: view)
            _constraitStartConstant = _leftTrailingConstraint.constant
        }
        
        let delta           = CGFloat(sender.location(in: view).x - _panStartLocation.x)
        let threshold       = CGFloat(0.5)
        var constant        : CGFloat
        let drawerState     : DrawerState
        let viewWidth       = self.view.bounds.size.width
        let velocity        = sender.velocity(in: view)
        let velocityThres   = CGFloat(400.0)
        
        constant = min(max(_constraitStartConstant + delta, -viewWidth), viewWidth)
        _leftTrailingConstraint.constant = constant
        
        if constant >= viewWidth && delta < 0 {
            return;
        }
        else if constant <= -viewWidth && delta > 0 {
            return;
        }
        
        if velocity.x < -velocityThres {
            constant -= viewWidth*threshold;
        }
        else if velocity.x > velocityThres {
            constant += viewWidth*threshold;
        }
        
        drawerState = constant < -viewWidth * threshold ? .right : constant > viewWidth*threshold ? .left : .center
        
        switch sender.state {
        case .changed:
            let percent = CGFloat(round(-_leftTrailingConstraint.constant/viewWidth * 100.0) / 100)
            self.delegate?.edgeSlideViewController!(self, changedePercent: percent)
        case .ended, .cancelled:
            setDrawerState(drawerState, animated: true)
        default:
            break
        }
    }
    
    private func isViewVisiable(_ view: UIView) -> Bool {
        func isVisible(view: UIView, inView: UIView?) -> Bool {
            guard let inView = inView else { return true }
            let viewFrame = inView.convert(view.bounds, from: view)
            if viewFrame.intersects(inView.bounds) {
                return isVisible(view: view, inView: inView.superview)
            }
            return false
        }
        return isVisible(view: view, inView: view.superview)
    }
    
    /**************************************************************************/
    // MARK: - UIGestureRecognizerDelegate
    /**************************************************************************/
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if self.displayingViewController is UINavigationController {
            let vc = self.displayingViewController as! UINavigationController
            if vc.viewControllers.count > 1 {
                return false
            }
        }
        
        return self.swipeEnabled;
    }
}
