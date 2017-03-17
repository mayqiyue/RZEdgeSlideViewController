//
//  ViewController.swift
//  RZEdgeSlideViewController
//
//  Created by mayqiyue on 03/17/2017.
//  Copyright (c) 2017 mayqiyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var viewTag : NSString?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(" viewWillAppear \(self.viewTag ?? "")")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear \(self.viewTag ?? "")")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(" viewWillDisappear \(self.viewTag ?? "")")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear \(self.viewTag ?? "")")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

