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
    
    
    var tapLocation: CGPoint = CGPoint()
    var tapLocation2: CGPoint = CGPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.characterView.multipleTouchEnabled = YES
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // タッチイベントを取得する
        let touch = touches.first
        // タップした座標を取得する
        tapLocation = touch!.locationInView(self.view)
    }
    
}

