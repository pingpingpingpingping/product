//
//  ViewController.swift
//  FamitoryForBotch
//
//  Created by sugimon on 2016/06/11.
//  Copyright © 2016年 ping. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var button: UIButton?;
    
    // セッション
    var mySession : AVCaptureSession!
    // カメラデバイス
    var myDevice : AVCaptureDevice!
    // 出力先
    var myOutput : AVCaptureVideoDataOutput!
    //画像の保存先
    var image : UIImage?
    
    let detector = Detector()
    
    @IBAction func tapButton(sender: AnyObject) {
        self.detector.trimObject(image);
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
        dispatch_sync(dispatch_get_main_queue(), {
            self.image = CameraUtil.imageFromSampleBuffer(sampleBuffer)
            self.imageView.image = self.detector.trimObject(self.image);
        })
    }



}

