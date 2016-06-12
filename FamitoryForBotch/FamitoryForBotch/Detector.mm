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

- (UIImage *)trimObject:(UIImage *)image aiueo:(int)eye_type{
    
    int eye = 0;
    if(eye_type == 1){
        eye = 1;
    }else if(eye_type == 2){
        eye = 2;
    }else if(eye_type == 3){
        eye = 3;
    }else if(eye_type == 4){
        eye = 4;
    }else if(eye_type == 5){
        eye = 5;
    }
    
    cv::Mat mat;
    UIImageToMat(image, mat);
    
    //このサイズにオベジェクトがある想定。トリミング
    cv::Mat grayscale, binImg;
    int thresh = 130;
    cv::cvtColor(mat, grayscale, CV_BGR2GRAY);
    cv::threshold(grayscale, binImg, thresh, 255, CV_THRESH_BINARY);
    
    cv::Mat cut_img(mat.cols, mat.rows, mat.type());
    cv::Mat cut_tmp(binImg.cols, binImg.rows, binImg.type());
    
    for(int y = 50; y<binImg.rows-100; y++){
        for(int x=70; x<binImg.cols-70; x++){
            cut_img.at<cv::Vec3b>(x,y) = mat.at<cv::Vec3b>(x,y);
            cut_tmp.at<uchar>(x,y) = binImg.at<uchar>(x,y);
        }
    }
    
    //輪郭の座標リスト
    std::vector< std::vector< cv::Point > > contours;
    std::vector<cv::Vec4i> hierarchy;
    
    //輪郭取得
    cv::findContours(cut_tmp, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_NONE);
    cv::Mat cut_tmp2(cut_tmp.cols, cut_tmp.rows, cut_tmp.type());
    double max_area = 0.0;
    int contour_num = -1;
    UIImage *resultImage;
    
    for (int i = 0; i < contours.size(); i++){
        
        //if(hierarchy[i][3]< 0)continue;
        
        std::vector< cv::Point > approx;
        
        //輪郭を直線近似する
        cv::approxPolyDP(cv::Mat(contours[i]), approx, 0.005 * cv::arcLength(contours[i], true), true);
        
        // 近似の面積が一定以上なら取得
        double area = cv::contourArea(approx);
        
        if (area > 1000.0 && area > max_area){
            
            //cv::drawContours(cut_img, contours,i,cv::Scalar(0,255,0));
            contour_num = i;
            max_area = area;
        }
    }
    cv::drawContours(cut_tmp2, contours,contour_num,cv::Scalar(255), CV_FILLED);
    if (contour_num != -1){
    cv::Rect bRect = cv::boundingRect(contours[contour_num]);
    /*
     for(int y=0; y<cut_tmp2.rows; y++){
     for(int x=0; x<cut_tmp2.cols; x++){
     if(cut_tmp2.at<uchar>(y,x) == 255){
     cut_img.at<cv::Vec3b>(y,x) = mat.at<cv::Vec3b>(y,x);
     }
     }
     }
     */
    
    //cv::Mat addFace_img = [self addFace:cut_img];
    cv::Mat addFace_img = [self addFace2:mat:bRect:eye];
    
    resultImage = MatToUIImage(addFace_img);

    std::cout << resultImage.size.width;
    }else {
            resultImage = MatToUIImage(mat);
    }
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
    cv::Mat input = mat.clone();
    cv::resize(input, input, cv::Size(200,300));
    
    cv::Mat output = mat.clone();
    
    //import filename
    NSString *file_lefteye = @"./parts/lefteye.png";
    NSString *file_righteye = @"./parts/righteye.png";
    NSString *file_nose = @"./parts/nose.png";
    NSString *file_mouse = @"./parts/mouse.png";
    NSString *file_lefthand = @"./parts/lefthand.png";
    NSString *file_righthand = @"./parts/righthand.png";
    NSString *file_leftfoot = @"./parts/leftfoot.png";
    NSString *file_rightfoot = @"./parts/rightfoot.png";
    NSString *file_face =@"./parts/face.png";
    
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
    
    //face
    cv::Mat face = [self loadMatFromFile:file_face];
    cv::resize(face, face, cv::Size(260,160));
    
    //position of all parts
    cv::Point pos_face(70,0);
    cv::Point pos_lefteye(110,20);
    cv::Point pos_righteye(250,20);
    cv::Point pos_nose(180,60);
    cv::Point pos_mouse(150,110);
    cv::Point pos_lefthand(90,170);
    cv::Point pos_leftfoot(90,280);
    cv::Point pos_righthand(250,170);
    cv::Point pos_rightfoot(250, 280);
    
    //place all parts
    
    //face
    for(int y=0; y<face.rows; y++){
        for(int x=0; x<face.cols; x++){
            if(face.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(y+pos_face.y, x+pos_face.x) = face.at<cv::Vec3b>(y,x);
            }
        }
    }
    
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

- (cv::Mat)addFace2:(cv::Mat)mat: (cv::Rect)rect: (int)eye_type{
    
    //output image
    cv::Mat input = mat.clone();
    cv::resize(input, input, cv::Size(200,300));
    
    cv::Mat output = mat.clone();
    
    //import filename
    NSString *file_eye1 = @"./parts/eye1.png";
    NSString *file_eye2 = @"./parts/eye2.png";
    NSString *file_eye3 = @"./parts/eye3.png";
    NSString *file_eye4 = @"./parts/eye4.png";
    NSString *file_eye5 = @"./parts/eye7.png";
    NSString *file_eye6 = @"./parts/eye8.png";
    NSString *file_eye78 = @"./parts/eye9.png";
    NSString *file_eye10 = @"./parts/eye11.png";
    NSString *file_eye9 = @"./parts/eye12.png";
    
    //eye1
    cv::Mat eye1 = [self loadMatFromFile:file_eye1];
    cv::resize(eye1, eye1, cv::Size(100,100));
    
    //eye2
    cv::Mat eye2 = [self loadMatFromFile:file_eye2];
    cv::resize(eye2, eye2, cv::Size(100,100));
    
    //eye3
    cv::Mat eye3 = [self loadMatFromFile:file_eye3];
    cv::resize(eye3, eye3, cv::Size(100,100));
    
    //eye4
    cv::Mat eye4 = [self loadMatFromFile:file_eye4];
    cv::resize(eye4, eye4, cv::Size(100,100));
    
    //eye5
    cv::Mat eye5 = [self loadMatFromFile:file_eye5];
    cv::resize(eye5, eye5, cv::Size(100,100));
    
    //eye6
    cv::Mat eye6 = [self loadMatFromFile:file_eye6];
    cv::resize(eye6, eye6, cv::Size(100,100));
    
    //eye78
    cv::Mat eye78 = [self loadMatFromFile:file_eye78];
    cv::resize(eye78, eye78, cv::Size(100,100));
    
    //eye9
    cv::Mat eye9 = [self loadMatFromFile:file_eye9];
    cv::resize(eye9, eye9, cv::Size(100,100));
    
    //eye10
    cv::Mat eye10 = [self loadMatFromFile:file_eye10];
    cv::resize(eye10, eye10, cv::Size(100,100));
    
    
    //place all parts
    cv::Point lefteye_pos(rect.x, rect.y);
    cv::Point righteye_pos(rect.width - rect.x, rect.y);
    
    //EYE
    cv::Mat lefteye, righteye;
    if(eye_type == 1){
        lefteye = eye1;
        righteye = eye2;
    }else if(eye_type == 2){
        lefteye = eye3;
        righteye = eye4;
    }else if (eye_type == 3){
        lefteye = eye5;
        righteye = eye6;
    }else if(eye_type == 4){
        lefteye = eye78;
        righteye = eye78;
    }else if(eye_type == 5){
        lefteye = eye9;
        righteye = eye10;
    }
    
    //left eye
    for(int y=0; y<lefteye.rows; y++){
        for(int x=0; x<lefteye.cols; x++){
            if(lefteye.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(lefteye_pos.y + y, lefteye_pos.x + x) = lefteye.at<cv::Vec3b>(y,x);
            }
        }
    }
    
    //right eye
    for(int y=0; y<righteye.rows; y++){
        for(int x=0; x<righteye.cols; x++){
            if(righteye.at<cv::Vec3b>(y,x) != cv::Vec3b(0,0,0)){
                output.at<cv::Vec3b>(righteye_pos.y + y, righteye_pos.x + x) = righteye.at<cv::Vec3b>(y,x);
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