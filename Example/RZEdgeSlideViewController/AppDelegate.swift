//
//  AppDelegate.swift
//  RZEdgeSlideViewController
//
//  Created by mayqiyue on 03/17/2017.
//  Copyright (c) 2017 mayqiyue. All rights reserved.
//

import UIKit
import RZEdgeSlideViewController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RZEdgeSlideViewControllerDelegate {

    var window: UIWindow?
    var drawVC: RZEdgeSlideViewController?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let drawerController  = RZEdgeSlideViewController()
        drawerController.delegate = self
        
        let mainViewController  = ViewController()
        mainViewController.viewTag = "main"
        
        let leftVC = ViewController()
        leftVC.view.backgroundColor = UIColor.red
        leftVC.viewTag = "left"
        
        let rightVC = ViewController()
        rightVC.view.backgroundColor = UIColor.blue
        rightVC.viewTag = "right"
        
        drawerController.mainViewController = mainViewController
        drawerController.leftViewController = leftVC
        drawerController.rightViewController = rightVC
        
        let leftButotn  = UIButton.init(frame: CGRect(x: 0, y: 100, width: 44, height: 44))
        leftButotn.setTitle("left", for: UIControlState.normal)
        leftButotn.backgroundColor = UIColor.red;
        leftButotn.addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        mainViewController.view.addSubview(leftButotn)
        
        let centerButton  = UIButton.init(frame: CGRect(x: 50, y: 100, width: 44, height: 44))
        centerButton.setTitle("center", for: UIControlState.normal)
        centerButton.backgroundColor = UIColor.red;
        centerButton.addTarget(self, action: #selector(centerAction(_:)), for: .touchUpInside)
        mainViewController.view.addSubview(centerButton)
        
        let rightButton  = UIButton.init(frame: CGRect(x: 100, y: 100, width: 44, height: 44))
        rightButton.setTitle("right", for: UIControlState.normal)
        rightButton.backgroundColor = UIColor.red;
        rightButton.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        mainViewController.view.addSubview(rightButton)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = drawerController
        window?.makeKeyAndVisible()
        
        self.drawVC = drawerController
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    @objc private func leftAction(_ sender: UIButton) {
        self.drawVC?.setDrawerState(.left, animated: true)
    }
    
    @objc private func centerAction(_ sender: UIButton) {
        self.drawVC?.setDrawerState(.center, animated: true)
        
    }

    @objc private func rightAction(_ sender: UIButton) {
        self.drawVC?.setDrawerState(.right, animated: true)
    }
    
    public func edgeSlideViewController(_ viewController: RZEdgeSlideViewController, currentState state: RZEdgeSlideViewController.DrawerState, percent: CGFloat) {
        print(" edgeSlideViewController currentState is: \(state.rawValue) percnet is \(percent)")
    }
    
    public func edgeSlideViewController(_ viewController: RZEdgeSlideViewController, willChange state: RZEdgeSlideViewController.DrawerState) {
        print(" edgeSlideViewController will change to state \(state.rawValue)")
    }
    
    public func edgeSlideViewController(_ viewController: RZEdgeSlideViewController, didChange state: RZEdgeSlideViewController.DrawerState) {
        print(" edgeSlideViewController did change to state \(state.rawValue)")
    }
}

