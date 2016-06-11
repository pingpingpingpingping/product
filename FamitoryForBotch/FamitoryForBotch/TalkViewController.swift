//
//  TalkViewController.swift
//  FamitoryForBotch
//
//  Created by matsubara on 2016/06/11.
//  Copyright © 2016年 ping. All rights reserved.


import UIKit
import AVFoundation


class TalkViewController: UIViewController {
    
    //キャラクターの画像を入れる用の変数
    @IBOutlet weak var charaImage:UIImage?
    
    
    @IBOutlet weak var characterView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

