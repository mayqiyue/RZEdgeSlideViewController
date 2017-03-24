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
    var button : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Title"
        self.view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.white
        self.navigationController?.hidesBarsOnSwipe = true;
        
        button = UIButton.init(frame: CGRect(x: 0, y: 100, width: 40, height: 40))
        button?.setTitle("push", for: UIControlState.normal)
        button?.backgroundColor = UIColor.blue;
        button?.addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        self.view.addSubview(button!)
        
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
    
    @objc private func leftAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(ViewController.init(), animated: true)
    }
}

