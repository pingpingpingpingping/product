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
    //    NSLog(@"mat rows:%", mat.rows);
    
//    cv::Mat test(mat.cols, mat.rows, mat.type());
    
    //このサイズにオベジェクトがある想定。トリミング
    
    int margin_x = 10;
    int margin_y = 10;
    int size_x = 300;
    int size_y = 300;
    
    cv::Rect obj_rect = cv::Rect(margin_x, margin_y, size_x,  size_y);
    cv::Mat cut_img(size_x, size_y, mat.type());
    
    for(int y=0; y<cut_img.rows; y++){
        for(int x=0; x<cut_img.cols; x++){
            cut_img.at<cv::Vec3b>(y,x) = mat.at<cv::Vec3b>(margin_y + y, margin_x + x);
        }
    }
    
    //グレースケール
    cv::Mat grayImage,binImage;
    cv::cvtColor(cut_img, grayImage, CV_BGR2GRAY);
    
    //cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY_INV | CV_THRESH_OTSU);
    cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY | CV_THRESH_OTSU);
    
    //輪郭の座標リスト
    std::vector< std::vector< cv::Point > > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    //輪郭取得
//    cv::findContours(binImage, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
    cv::findContours(binImage, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
//    cv::findContours(binImage, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_NONE);
    
    // 検出された輪郭線を緑で描画
    /*
     for (auto contour = contours.begin(); contour != contours.end(); contour++){
     cv::polylines(cut_img, *contour, true, cv::Scalar(0, 255, 0), 2);
     }
     */
    
    //輪郭の数
    int roiCnt = 0;
    
    //輪郭のカウント
    
    //roi配列の用意
    cv::Mat roi[100];
    
    for (int i = 0; i < contours.size(); i++){
        
        //if(hierarchy[i][3]< 0)continue;
        
        std::vector< cv::Point > approx;
        
        //輪郭を直線近似する
        cv::approxPolyDP(cv::Mat(contours[i]), approx, 0.01 * cv::arcLength(contours[i], true), true);
        
        // 近似の面積が一定以上なら取得
        double area = cv::contourArea(approx);
        
        if (area > 1000.0){
            //     if (area > 1000.0 && area < 8000.0){
            //青で囲む場合
            //cv::polylines(cut_img, approx, true, cv::Scalar(255, 0, 0), 2);
            std::stringstream sst;
            sst << "area : " << area;
            cv::putText(cut_img, sst.str(), approx[0], CV_FONT_HERSHEY_PLAIN, 1.0, cv::Scalar(0, 128, 0));
            
            //輪郭に隣接する矩形の取得
            cv::Rect brect = cv::boundingRect(cv::Mat(approx).reshape(2));
            roi[roiCnt] = cv::Mat(cut_img, brect);
            
            //入力画像に表示する場合
            cv::drawContours(cut_img, contours, i, CV_RGB(0, 0, 255), 4);
            
            //表示
            //cv::imshow("label" + std::to_string(roiCnt+1), roi[roiCnt]);
            
            roiCnt++;
            
            //念のため輪郭をカウント
            if (roiCnt == 99)
            {
                break;
            }
        }
        
        i++;
    }
    
    //全体を表示する場合
    //cv::imshow("coun", cut_img);
    
    //    imgMatWrite = cut_img;
    
    //UIImage *resultImage = MatToUIImage(cut_img);
    
    //    cv::Mat dst_img2(mat.rows, mat.cols, cut_img.type());
    //    cv::resize(cut_img, dst_img2, dst_img2.size(), cv::INTER_CUBIC);
    /*
    for (int i = 0; i < roiCnt; i++){
        std::cout << "i: " << i << "roi.row: "<<roi[i].rows << std::endl;
    }
     */
    
    cv::Mat addFace_img = addFace(cut_img);
    
    std::cout<< "image " << grayImage.cols << " " << grayImage.rows << std::endl;
    
    cv::Mat test(grayImage.cols, grayImage.rows, grayImage.type());
    test = grayImage;
    UIImage *resultImage = MatToUIImage(test);
    
    std::cout << resultImage.size.width;
    return resultImage;
    
}


//
//- (UIImage *)trimObject:(UIImage *)image{
//    
//    cv::Mat mat;
//    UIImageToMat(image, mat);
//    
//    //このサイズにオベジェクトがある想定。トリミング
//    cv::Rect obj_rect = cv::Rect(int(mat.cols/4), int(mat.rows/4), int(mat.cols)/ 4,  int(mat.rows)/4);
//    //cv::Rect obj_rect = cv::Rect(int(cut_img.cols/4), int(cut_img.rows/4), int(cut_img.cols)/ 4,  int(cut_img.rows)/4);
//    cv::Mat cut_img(mat, obj_rect);
//    
//    //グレースケール
//    cv::Mat grayImage, binImage;
//    cv::cvtColor(cut_img, grayImage, CV_BGR2GRAY);
//    
//    //    //2値化（※反転で結果が変わる、基本は背景が黒で物体が白）
//    //    BOOL bInv = checkInv(hWnd);
//    //    if (bInv){
//    //        cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY_INV | CV_THRESH_OTSU);
//    //    }
//    //    else{
//    //        cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY | CV_THRESH_OTSU);
//    //    }
//    //    cv::imshow("bin", binImage);
//    
//    cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY_INV | CV_THRESH_OTSU);
////    cv::threshold(grayImage, binImage, 0.0, 255.0, CV_THRESH_BINARY | CV_THRESH_OTSU);
//    
//    //輪郭の座標リスト
//    std::vector< std::vector< cv::Point > > contours;
//
//    //輪郭取得
//    ////cv::findContours(binImage, contours, CV_RETR_EXTERNAL, CV_CHAIN_APPROX_NONE);
//    cv::findContours(binImage, contours, CV_RETR_LIST, CV_CHAIN_APPROX_NONE);
//    
//    // 検出された輪郭線を緑で描画
//    for (auto contour = contours.begin(); contour != contours.end(); contour++){
//        cv::polylines(cut_img, *contour, true, cv::Scalar(0, 255, 0), 2);
//    }
//    
//    //輪郭の数
//    int roiCnt = 0;
//    
//    //輪郭のカウント
//    int i = 0;
//    
//    //roi配列の用意
//    cv::Mat roi[100];
//    
//    for (auto contour = contours.begin(); contour != contours.end(); contour++){
//        
//        std::vector< cv::Point > approx;
//        
//        //輪郭を直線近似する
//        cv::approxPolyDP(cv::Mat(*contour), approx, 0.01 * cv::arcLength(*contour, true), true);
//        
//        // 近似の面積が一定以上なら取得
//        double area = cv::contourArea(approx);
//        
//        if (area > 1000.0){
//            //青で囲む場合
//            cv::polylines(cut_img, approx, true, cv::Scalar(255, 0, 0), 2);
//            std::stringstream sst;
//            sst << "area : " << area;
//            cv::putText(cut_img, sst.str(), approx[0], CV_FONT_HERSHEY_PLAIN, 1.0, cv::Scalar(0, 128, 0));
//            
//            //輪郭に隣接する矩形の取得
//            cv::Rect brect = cv::boundingRect(cv::Mat(approx).reshape(2));
//            roi[roiCnt] = cv::Mat(cut_img, brect);
//            
//            //入力画像に表示する場合
//            //cv::drawContours(imgIn, contours, i, CV_RGB(0, 0, 255), 4);
//            
//            roiCnt++;
//            
//            //念のため輪郭をカウント
//            if (roiCnt == 99)
//            {
//                break;
//            }
//        }
//        
//        i++;
//    }
//    
//    
//    UIImage *resultImage = MatToUIImage(mat);
//    return resultImage;
//    
//}







- (cv::Mat)addFace:(cv::Mat)mat{
    
    //output image
    int margin_x = 80;
    int margin_y = 80;
    cv::Mat output(mat.cols + margin_x, mat.rows + margin_y, mat.type());
    
    for(int y = 0; y < mat.rows; y++){
        for(int x = 0; x < mat.cols; x++){
            output.at<cv::Vec3b>(y + margin_y/2, x + margin_x) = mat.at<cv::Vec3b>(y,x);
        }
    }
    
    //import filename
    std::string file_lefteye = "../images/parts/nose.png";
    std::string file_righteye = "../images/parts/righteye.png";
    std::string file_nose = "../images/parts/nose.png";
    std::string file_mouse = "../images/parts/mouse.png";
    std::string file_lefthand = "../images/parts/lefthand.png";
    std::string file_righthand = "../images/parts/righthand.png";
    std::string file_leftfoot = "../images/parts/leftfoot.png";
    std::string file_rightfoot = "../images/parts/rightfoot.png";
    
    //left eye
    cv::Mat lefteye = cv::imread(file_lefteye);
    cv::resize(lefteye, lefteye, cv::Size(20,20));

    //right eye
    cv::Mat righteye = cv::imread(file_righteye);
    cv::resize(righteye, righteye, cv::Size(20,20));
    
    //nose
    cv::Mat nose = cv::imread(file_nose);
    cv::resize(nose, nose, cv::Size(20,20));
    
    //mouse
    cv::Mat mouse = cv::imread(file_mouse);
    cv::resize(mouse, mouse, cv::Size(20,20));
    
    //left hand
    cv::Mat lefthand = cv::imread(file_lefthand);
    cv::resize(lefthand, lefthand, cv::Size(20,20));
    
    //left foot
    cv::Mat leftfoot = cv::imread(file_leftfoot);
    cv::resize(leftfoot, leftfoot, cv::Size(20,20));
    
    //right hand
    cv::Mat righthand = cv::imread(file_righthand);
    cv::resize(righthand, righthand, cv::Size(20,20));
    
    //left foot
    cv::Mat rightfoot = cv::imread(file_rightfoot);
    cv::resize(rightfoot, rightfoot, cv::Size(20,20));
    
    //position of all parts
    cv::Point pos_lefteye(200,0);
    cv::Point pos_righteye(280,0);
    cv::Point pos_nose(220,50);
    cv::Point pos_mouse(220,100);
    cv::Point pos_lefthand(0,150);
    cv::Point pos_leftfoot(200,300);
    cv::Point pos_righthand(280,150);
    cv::Point pos_rightfoot(250, 300);
    
    //place all parts
    
    //left eye
    for(int y=0; y<nose.rows; y++){
        for(int x=0; x<nose.rows; x++){
            output.at<cv::Vec3b>(y+pos_nose.y, x+pos_nose.x) = nose.at<cv::Vec3b>(y,x);
        }
    }
    //right eye
    for(int y=0; y<righteye.rows; y++){
        for(int x=0; x<righteye.rows; x++){
            output.at<cv::Vec3b>(y+pos_righteye.y, x+pos_righteye.x) = righteye.at<cv::Vec3b>(y,x);
        }
    }
    //nose
    for(int y=0; y<nose.rows; y++){
        for(int x=0; x<nose.rows; x++){
            output.at<cv::Vec3b>(y+pos_nose.y, x+pos_nose.x) = nose.at<cv::Vec3b>(y,x);
        }
    }
    //mouse
    for(int y=0; y<mouse.rows; y++){
        for(int x=0; x<mouse.rows; x++){
            output.at<cv::Vec3b>(y+pos_mouse.y, x+pos_mouse.x) = mouse.at<cv::Vec3b>(y,x);
        }
    }
    //left hand
    for(int y=0; y<lefthand.rows; y++){
        for(int x=0; x<lefthand.rows; x++){
            output.at<cv::Vec3b>(y+pos_lefthand.y, x+pos_lefthand.x) = lefthand.at<cv::Vec3b>(y,x);
        }
    }
    //left foot
    for(int y=0; y<leftfoot.rows; y++){
        for(int x=0; x<leftfoot.rows; x++){
            output.at<cv::Vec3b>(y+pos_leftfoot.y, x+pos_leftfoot.x) = leftfoot.at<cv::Vec3b>(y,x);
        }
    }
    //right hand
    for(int y=0; y<righthand.rows; y++){
        for(int x=0; x<righthand.rows; x++){
            output.at<cv::Vec3b>(y+pos_righthand.y, x+pos_righthand.x) = righthand.at<cv::Vec3b>(y,x);
        }
    }
    //right foot
    for(int y=0; y<rightfoot.rows; y++){
        for(int x=0; x<rightfoot.rows; x++){
            output.at<cv::Vec3b>(y+pos_rightfoot.y, x+pos_rightfoot.x) = rightfoot.at<cv::Vec3b>(y,x);
        }
    }
    
    return output;
}

- (cv::Mat)createCharaOnPhotoImage:(UIImage*)image :(cv::Mat)mat{
    
    //put camera image to mat
    cv::Mat input_img;
    UIImageToMat(image, input_img);
    
    //resize character
    cv::Mat chara_mat = mat.clone();
    int chara_sizex = 30;
    int chara_sizey = 30;
    cv::resize(chara_mat, chara_mat, cv::Size(chara_sizex, chara_sizey));
    
    //set start point of character position
    cv::Point endPos(400,300);
    cv::Point startPos(endPos.x - chara_sizex, endPos.y - chara_sizey);
    
    //set character image on photo image
    for(int y=0; y<chara_sizey; y++){
        for(int x=0; x<chara_sizex; x++){
            input_img.at<cv::Vec3b>(y + startPos.y, x + startPos.x) = chara_mat.at<cv::Vec3b>(y,x);
        }
    }
    
    return input_img;
}

@end