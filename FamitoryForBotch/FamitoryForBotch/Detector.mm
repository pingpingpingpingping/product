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

@implementation Detector: NSObject


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