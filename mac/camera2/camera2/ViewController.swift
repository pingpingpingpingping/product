//
//  ViewController.swift
//  camera2
//
//  Created by sugimon on 2016/06/12.
//  Copyright © 2016年 sugimon. All rights reserved.
//

import UIKit
import GLKit
import AVFoundation

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate
{
    var videoDisplayView: GLKView!
    var videoDisplayViewRect: CGRect!
    var renderContext: CIContext!
    var cpsSession: AVCaptureSession!
    var shutter: UIButton = UIButton()
    var goSecondSegue: UIStoryboardSegue!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool)
    {
        //画面の生成
        self.initDisplay()
        
        // カメラの使用準備.
        self.initCamera()
    }
    override func viewDidDisappear(animated: Bool)
    {
        // カメラの停止とメモリ解放.
        self.cpsSession.stopRunning()
        for output in self.cpsSession.outputs
        {
            self.cpsSession.removeOutput(output as! AVCaptureOutput)
        }
        for input in self.cpsSession.inputs
        {
            self.cpsSession.removeInput(input as! AVCaptureInput)
        }
        self.cpsSession = nil
    }
    func initDisplay()
    {
        var rect: CGRect = view.bounds
//        var tmprect: CGRect = CGRectMake(, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
//        tmprect. = rect.width*0.8
//        tmprect.height = rect.height*0.8
        videoDisplayView = GLKView(frame: view.bounds, context: EAGLContext(API: .OpenGLES2))
        videoDisplayView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        videoDisplayView.frame = CGRectMake(0, 0, rect.width, rect.height * 0.7)
        view.addSubview(videoDisplayView)
        
        renderContext = CIContext(EAGLContext: videoDisplayView.context)
        videoDisplayView.bindDrawable()
        videoDisplayViewRect = CGRect(x: 0, y: 0, width: videoDisplayView.drawableWidth, height: videoDisplayView.drawableHeight)
        
        shutter.setTitle("shutter", forState: .Normal)
        shutter.frame = CGRectMake(rect.width/2, (rect.height - videoDisplayView.frame.height)/2, rect.width/3, rect.height/10)
        shutter.addTarget(self, action: Selector("tapped:"), forControlEvents:.TouchUpInside)

        //ボタン追加
        self.view.addSubview(shutter)
    }
    func initCamera()
    {
        //カメラからの入力を作成
        let devices = AVCaptureDevice.devices()

//        let device: AVCaptureDevice = AVCaptureDevice()
        var device: AVCaptureDevice?
        //背面カメラの検索
        for dev in devices {
            // Make sure this particular device supports video
            if (dev.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(dev.position == AVCaptureDevicePosition.Back) {
                    device = (dev as? AVCaptureDevice)!
                }
            }
        }
    
        
        //入力データの取得
        var deviceInput: AVCaptureDeviceInput?
        do{
            deviceInput = try AVCaptureDeviceInput(device: device) as AVCaptureDeviceInput
        }catch{
            deviceInput = nil
        }
        //出力データの取得
        let videoDataOutput:AVCaptureVideoDataOutput = AVCaptureVideoDataOutput()
        
        //カラーチャンネルの設定
//        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey : kCVPixelFormatType_32BGRA]
        
        //画像をキャプチャするキューを指定
        videoDataOutput.setSampleBufferDelegate(self, queue: dispatch_get_main_queue())
        
        //キューがブロックされているときに新しいフレームが来たら削除
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        
        //セッションの使用準備
        self.cpsSession = AVCaptureSession()
        
        //Input
        if(self.cpsSession.canAddInput(deviceInput))
        {
            self.cpsSession.addInput(deviceInput! as AVCaptureDeviceInput)
        }
        //Output
        if(self.cpsSession.canAddOutput(videoDataOutput))
        {
            self.cpsSession.addOutput(videoDataOutput)
        }
        //解像度の指定
        self.cpsSession.sessionPreset = AVCaptureSessionPresetMedium
        
        self.cpsSession.startRunning()
    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!)
    {
        //SampleBufferから画像を取得
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let opaqueBuffer = Unmanaged<CVImageBuffer>.passUnretained(imageBuffer!).toOpaque()
        let pixelBuffer = Unmanaged<CVPixelBuffer>.fromOpaque(opaqueBuffer).takeUnretainedValue()
        let outputImage = CIImage(CVPixelBuffer: pixelBuffer, options: nil)
        
        //補正
        var drawFrame = outputImage.extent
        let imageAR = drawFrame.width / drawFrame.height
        let viewAR = videoDisplayViewRect.width / videoDisplayViewRect.height
        if imageAR > viewAR {
            drawFrame.origin.x += (drawFrame.width - drawFrame.height * viewAR) / 2.0
            drawFrame.size.width = drawFrame.height / viewAR
        } else {
            drawFrame.origin.y += (drawFrame.height - drawFrame.width / viewAR) / 2.0
            drawFrame.size.height = drawFrame.width / viewAR
        }
        
        //出力
        videoDisplayView.bindDrawable()
        if videoDisplayView.context != EAGLContext.currentContext() {
            EAGLContext.setCurrentContext(videoDisplayView.context)
        }
        renderContext.drawImage(outputImage, inRect: videoDisplayViewRect, fromRect: drawFrame)
        videoDisplayView.display()
        
        
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let secondViewContoroller = segue.destinationViewController as! SecondViewController
        if ((sender as? UIImage) != nil){
            secondViewContoroller.capView = sender as? UIImageView
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//EOF
