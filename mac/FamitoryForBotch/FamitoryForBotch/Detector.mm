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
    
    int margin_x = 10;
    int margin_y = 10;
    int size_x = 300;
    int size_y = 300;
    
    cv::Mat cut_img = mat.clone();
    
    cv::Mat test(cut_img.cols, cut_img.rows, cut_img.type());
    test = cut_img.clone();
    
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
            //cv::drawContours(cut_img, contours, i, CV_RGB(0, 0, 255), 4);
            
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
    
        cv::Mat addFace_img = [self addFace:cut_img];
    
    std::cout<< "image " << grayImage.cols << " " << grayImage.rows << std::endl;
    
    //cv::Mat test(grayImage.cols, grayImage.rows, grayImage.type());
    //test = grayImage;
    UIImage *resultImage = MatToUIImage(addFace_img);
    
    std::cout << resultImage.size.width;
    return resultImage;
    
}

- (cv::Mat) loadMatFromFile:(NSString *)filename{
    NSString* resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString* path = [resourcePath stringByAppendingPathComponent:filename];
    const char* pathChars = [path UTF8String];
    return cv::imread(pathChars);
}



- (cv::Mat)addFace:(cv::Mat)mat{
    
    //output image
    int margin_x = 40;
    int margin_y = 40;
    cv::Mat output(mat.cols + margin_x, mat.rows + margin_y, mat.type());
    
    for(int y = 0; y < mat.rows; y++){
        for(int x = 0; x < mat.cols; x++){
            output.at<cv::Vec3b>(y + margin_y/2, x + margin_x/2) = mat.at<cv::Vec3b>(y,x);
        }
    }
    
    //import filename
    NSString *file_lefteye = @"./parts/lefteye.png";
    NSString *file_righteye = @"./parts/righteye.png";
    NSString *file_nose = @"./parts/nose.png";
    NSString *file_mouse = @"./parts/mouse.png";
    NSString *file_lefthand = @"./parts/lefthand.png";
    NSString *file_righthand = @"./parts/righthand.png";
    NSString *file_leftfoot = @"./parts/leftfoot.png";
    NSString *file_rightfoot = @"./parts/rightfoot.png";
    
    //left eye
    cv::Mat lefteye = [self loadMatFromFile:file_lefteye];
    std::cout << "left eye " << lefteye.cols << " " << lefteye.rows << std::endl;
    cv::resize(lefteye, lefteye, cv::Size(40,40));

    //right eye
    cv::Mat righteye = [self loadMatFromFile:file_righteye];
    cv::resize(righteye, righteye, cv::Size(40,40));
    
    //nose
    cv::Mat nose = [self loadMatFromFile:file_nose];
    cv::resize(nose, nose, cv::Size(40,40));
    
    //mouse
    cv::Mat mouse = [self loadMatFromFile:file_mouse];
    cv::resize(mouse, mouse, cv::Size(100,40));
    
    //left hand
    cv::Mat lefthand = [self loadMatFromFile:file_lefthand];
    cv::resize(lefthand, lefthand, cv::Size(40,40));
    
    //left foot
    cv::Mat leftfoot = [self loadMatFromFile:file_leftfoot];
    cv::resize(leftfoot, leftfoot, cv::Size(40,40));
    
    //right hand
    cv::Mat righthand = [self loadMatFromFile:file_righthand];
    cv::resize(righthand, righthand, cv::Size(40,40));
    
    //left foot
    cv::Mat rightfoot = [self loadMatFromFile:file_rightfoot];
    cv::resize(rightfoot, rightfoot, cv::Size(40,40));
    
    //position of all parts
    cv::Point pos_lefteye(50,0);
    cv::Point pos_righteye(130,0);
    cv::Point pos_nose(90,40);
    cv::Point pos_mouse(60,70);
    cv::Point pos_lefthand(0,120);
    cv::Point pos_leftfoot(0,250);
    cv::Point pos_righthand(175,120);
    cv::Point pos_rightfoot(175, 250);
    
    //place all parts
    
    //left eye
    for(int y=0; y<lefteye.rows; y++){
        for(int x=0; x<lefteye.cols; x++){
            if(lefteye.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_lefteye.y, x+pos_lefteye.x) = lefteye.at<cv::Vec3b>(y,x);
            }
        }
    }
    //right eye
    for(int y=0; y<righteye.rows; y++){
        for(int x=0; x<righteye.cols; x++){
            if(righteye.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_righteye.y, x+pos_righteye.x) = righteye.at<cv::Vec3b>(y,x);
            }
        }
    }
    //nose
    for(int y=0; y<nose.rows; y++){
        for(int x=0; x<nose.cols; x++){
            if(nose.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_nose.y, x+pos_nose.x) = nose.at<cv::Vec3b>(y,x);
            }
        }
    }
    //mouse
    for(int y=0; y<mouse.rows; y++){
        for(int x=0; x<mouse.cols; x++){
            if(mouse.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_mouse.y, x+pos_mouse.x) = mouse.at<cv::Vec3b>(y,x);
            }
        }
    }
    //left hand
    for(int y=0; y<lefthand.rows; y++){
        for(int x=0; x<lefthand.cols; x++){
            if(lefthand.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_lefthand.y, x+pos_lefthand.x) = lefthand.at<cv::Vec3b>(y,x);
            }
        }
    }
    //left foot
    for(int y=0; y<leftfoot.rows; y++){
        for(int x=0; x<leftfoot.cols; x++){
            if(leftfoot.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_leftfoot.y, x+pos_leftfoot.x) = leftfoot.at<cv::Vec3b>(y,x);
            }
        }
    }
    //right hand
    for(int y=0; y<righthand.rows; y++){
        for(int x=0; x<righthand.cols; x++){
            if(righthand.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_righthand.y, x+pos_righthand.x) = righthand.at<cv::Vec3b>(y,x);
            }
        }
    }
    //right foot
    for(int y=0; y<rightfoot.rows; y++){
        for(int x=0; x<rightfoot.cols; x++){
            if(rightfoot.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_rightfoot.y, x+pos_rightfoot.x) = rightfoot.at<cv::Vec3b>(y,x);
            }
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