//
//  ViewController.m
//  人脸识别
//
//  Created by 梦想 on 2016/11/27.
//  Copyright © 2016年 lin_tong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [self presentViewController:picker animated:YES completion:nil];
    picker.delegate = self;
    picker.allowsEditing = YES;
}


- (void)faceTest{
    
    UIImage *aImage = [UIImage imageNamed:@"1.jpg"];
    CIImage* image = [CIImage imageWithCGImage:aImage.CGImage];
    
    NSDictionary  *opts = [NSDictionary dictionaryWithObject:CIDetectorAccuracyHigh
                                                      forKey:CIDetectorAccuracy];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:opts];
    //得到面部数据
    NSArray* features = [detector featuresInImage:image];
    
    for (CIFaceFeature *f in features){
        CGRect aRect = f.bounds;
        NSLog(@"%f, %f, %f, %f", aRect.origin.x, aRect.origin.y, aRect.size.width, aRect.size.height);
        //眼睛和嘴的位置
        if(f.hasLeftEyePosition) NSLog(@"Left eye %g %g\n", f.leftEyePosition.x, f.leftEyePosition.y);
        if(f.hasRightEyePosition) NSLog(@"Right eye %g %g\n", f.rightEyePosition.x, f.rightEyePosition.y);
        if(f.hasMouthPosition) NSLog(@"Mouth %g %g\n", f.mouthPosition.x, f.mouthPosition.y);
        
        NSLog(@"%@", f);
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 400, 400)];
    imageView.image = aImage;
    [self.view addSubview:imageView];
    
    /*
     检测到的位置是脸部数据在图片上的坐标（在uiimage上的，不是uiimageview上的），如果需要在视图上绘制范围，则需要进行坐标转换（y轴方向相反），并且也要注意图片在视图上的缩放等。
     */

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
