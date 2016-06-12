//
//  ViewController.swift
//  FamitoryForBotch
//
//  Created by sugimon on 2016/06/11.
//  Copyright © 2016年 ping. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var b1: UIButton?;
    @IBOutlet weak var b2: UIButton?;
    @IBOutlet weak var b3: UIButton?;
    
    // セッション
    var mySession : AVCaptureSession!
    // カメラデバイス
    var myDevice : AVCaptureDevice!
    // 出力先
    var myOutput : AVCaptureVideoDataOutput!
    //画像の保存先
    var image2 : UIImage?
    
    let detector = Detector()
    
    func tapingB1(sender: AnyObject) {
        //ボタンが押された時の処理
        //画像をDetector.mmに送り、物体を検出し顔を描画する。
//        let characterImage : UIImage?
        self.image2 = self.detector.trimObject(self.image2, aiueo:0);
    }
    func tapingB2(sender: AnyObject) {
        self.image2 = self.detector.trimObject(self.image2, aiueo:0);
    }
    func tapingB3(sender: AnyObject) {
        self.image2 = self.detector.trimObject(self.image2, aiueo:0);
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // カメラを準備
        if initCamera() {
            // 撮影開始
            mySession.startRunning()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // カメラの準備処理
    func initCamera() -> Bool {
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // 解像度の指定.
        mySession.sessionPreset = AVCaptureSessionPresetMedium
        
        
        // デバイス一覧の取得.
        if let device = findCamera(AVCaptureDevicePosition.Back) {
            myDevice = device
        } else {
            print("カメラが見つかりませんでした")
            return false
        }
        
        do {
            // バックカメラからVideoInputを取得.
            let myInput: AVCaptureDeviceInput?
            try myInput = AVCaptureDeviceInput(device: myDevice)
            
            // セッションに追加.
            if mySession.canAddInput(myInput) {
                mySession.addInput(myInput)
            } else {
                return false
            }
            
            // 出力先を設定
            myOutput = AVCaptureVideoDataOutput()
            myOutput.videoSettings = [ kCVPixelBufferPixelFormatTypeKey: Int(kCVPixelFormatType_32BGRA) ]
            
            // FPSを設定
            try myDevice.lockForConfiguration()
            myDevice.activeVideoMinFrameDuration = CMTimeMake(1, 15)
            myDevice.unlockForConfiguration()
            
            // デリゲートを設定
            let queue: dispatch_queue_t = dispatch_queue_create("myqueue",  nil)
            myOutput.setSampleBufferDelegate(self, queue: queue)
            
            // 遅れてきたフレームは無視する
            myOutput.alwaysDiscardsLateVideoFrames = true
            
        } catch let error as NSError {
            print(error)
            return false
        }
        
        
        // セッションに追加.
        if mySession.canAddOutput(myOutput) {
            mySession.addOutput(myOutput)
        } else {
            return false
        }
        
        // カメラの向きを合わせる
        for connection in myOutput.connections {
            if let conn = connection as? AVCaptureConnection {
                if conn.supportsVideoOrientation {
                    conn.videoOrientation = AVCaptureVideoOrientation.Portrait
                }
            }
        }
        
        return true
    }
    
    // 指定位置のカメラを探します
    func findCamera(position: AVCaptureDevicePosition) -> AVCaptureDevice? {
        for device in AVCaptureDevice.devices() {
            if(device.position == position){
                return device as? AVCaptureDevice
            }
        }
        return nil
    }
    
    
    // 毎フレーム実行される処理
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!)
    {
        
        var tag: Int32 = 0
        
        if(b1!.touchInside){
            tag = 1;
        }else if(b2!.touchInside){
            tag = 2;
        }else if((b3?.touchInside) != nil){
            tag = 3;
        }
        
        dispatch_sync(dispatch_get_main_queue(), {
            let image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            let obj_img :UIImage = self.detector.trimObject(image, aiueo: tag)
            //trimObject(image:image, aiueo:tag)
            self.imageView.image = obj_img
            print("a")
        })
    }
    
    //TalkViewControllerに画像を渡すために、Sequeのやつをオーバーライド
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let convCon = segue.destinationViewController as! Conversation
//        convCon.charaImage = self.image2
    }



}

