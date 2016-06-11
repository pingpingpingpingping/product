//
//  Detector.cpp
//  FamitoryForBotch
//
//  Created by Hayato Kihara on 2016/06/11.
//  Copyright © 2016年 ping. All rights reserved.
//

#import "FamitoryForBotch-Bridging-Header.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
@interface Detector(){
    
}
@end
@implementation Detector: NSObject

- (UIImage *)trimObject:(UIImage *)image{
    
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    //このサイズにオベジェクトがある想定。トリミング
    cv::Rect obj_rect = cv::Rect(int(mat.cols/4), int(mat.rows/4), int(mat.cols)/ 4,  int(mat.rows)/4);
    //cv::Rect obj_rect = cv::Rect(int(cut_img.cols/4), int(cut_img.rows/4), int(cut_img.cols)/ 4,  int(cut_img.rows)/4);
    cv::Mat cut_img(mat, obj_rect);
    
    //グレースケール
    cv::Mat grayImage, binImage;
    cv::cvtColor(cut_img, grayImage, CV_BGR2GRAY);
    
    //    //2値化（※反転で結果が変わる、基本は背景が黒で物体が白）
    //    BOOL bInv = checkInv(hWnd);
    //    if (bInv){
    //        cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY_INV | CV_THRESH_OTSU);
    //    }
    //    else{
    //        cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY | CV_THRESH_OTSU);
    //    }
    //    cv::imshow("bin", binImage);
    
    //cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY_INV | CV_THRESH_OTSU);
    cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY | CV_THRESH_OTSU);
    
    //輪郭の座標リスト
    std::vector< std::vector< cv::Point > > contours;
    
    //輪郭取得
    ////cv::findContours(binImage, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    cv::findContours(binImage, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
    
    // 検出された輪郭線を緑で描画
    for (auto contour = contours.begin(); contour != contours.end(); contour++){
        cv::polylines(cut_img, *contour, true, cv::Scalar(0, 255, 0), 2);
    }
    
    //輪郭の数
    int roiCnt = 0;
    
    //輪郭のカウント
    int i = 0;
    
    //roi配列の用意
    cv::Mat roi[100];
    
    for (auto contour = contours.begin(); contour != contours.end(); contour++){
        
        std::vector< cv::Point > approx;
        
        //輪郭を直線近似する
        cv::approxPolyDP(cv::Mat(*contour), approx, 0.01 * cv::arcLength(*contour, true), true);
        
        // 近似の面積が一定以上なら取得
        double area = cv::contourArea(approx);
        
        if (area > 1000.0){
            //青で囲む場合
            cv::polylines(cut_img, approx, true, cv::Scalar(255, 0, 0), 2);
            std::stringstream sst;
            sst << "area : " << area;
            cv::putText(cut_img, sst.str(), approx[0], CV_FONT_HERSHEY_PLAIN, 1.0, cv::Scalar(0, 128, 0));
            
            //輪郭に隣接する矩形の取得
            cv::Rect brect = cv::boundingRect(cv::Mat(approx).reshape(2));
            roi[roiCnt] = cv::Mat(cut_img, brect);
            
            //入力画像に表示する場合
            //cv::drawContours(imgIn, contours, i, CV_RGB(0, 0, 255), 4);
            
            roiCnt++;
            
            //念のため輪郭をカウント
            if (roiCnt == 99)
            {
                break;
            }
        }
        
        i++;
    }
    
    
    UIImage *resultImage = MatToUIImage(cut_img);
    return resultImage;
    
}






@end