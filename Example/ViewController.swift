//
//  ViewController.swift
//  Traduki
//
//  Created by Vergil Choi on 2017/7/25.
//  Copyright © 2017年 Vergil Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let littles = [labelMake(__("label.little.1")), labelMake(__("label.little.2")), labelMake(__("label.little.3"))]
        let big = labelMake(__("label.big"))
        let middle = labelMake(__("label.middle"))
        let littleOne = labelMake(__("label.little", "test", ["who": "Tom"]))
        
        for (index, little) in littles.enumerated() {
            little.frame.origin.x = 20
            little.frame.origin.y = CGFloat(20 + index * 30)
            self.view.addSubview(little)
        }
        
        big.frame.origin.x = 20
        big.frame.origin.y = 120
        middle.frame.origin.x = 20
        middle.frame.origin.y = 150
        littleOne.frame.origin.x = 20
        littleOne.frame.origin.y = 200
        
        self.view.addSubview(big)
        self.view.addSubview(middle)
        self.view.addSubview(littleOne)
        
//        __("button.test.cool")
//        __("button.test.great")
//        __("button.test.gorgeous")
        
    }
    
    func labelMake(_ text: String) -> UILabel {
        let label = UILabel.init()
        label.text = text
        label.sizeToFit()
        return label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

