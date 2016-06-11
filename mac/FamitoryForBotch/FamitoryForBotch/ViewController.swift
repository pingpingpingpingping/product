//
//  ViewController.swift
//  FamitoryForBotch
//
//  Created by sugimon on 2016/06/11.
//  Copyright © 2016年 ping. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var sub1View: sub1ViewController!
    var sub2View: sub2ViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sub1View = sub1ViewController()
        self.sub2View = sub2ViewController()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

