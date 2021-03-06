//
//  ViewController.m
//  ZhiWenTest
//
//  Created by ** on 2016/11/23.
//  Copyright © 2016年 Test. All rights reserved.
//


/*
 操作系统最低为iOS8.0
 
 做iOS8.0下版本适配时，务必进行API验证，避免调用相关API引起崩溃。
 
 引入依赖框架：#import <LocalAuthentication/LocalAuthentication.h>
 
 */



#import "ViewController.h"
#import <Masonry.h>
#import <LocalAuthentication/LocalAuthentication.h>



@interface ViewController ()

@property (nonatomic ,strong) UIButton *touchBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:self.touchBtn];
    
    __weak typeof (self) weakSelf = self;
    
    [self.touchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
        make.size.mas_equalTo(CGSizeMake(80, 80));
        
    }];
}
- (UIButton *)touchBtn{
    if (!_touchBtn) {
        _touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_touchBtn setTitle:@"指纹验证" forState:UIControlStateNormal];
        [_touchBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_touchBtn setBackgroundColor:[UIColor yellowColor]];
        [_touchBtn addTarget:self action:@selector(setLocalAuthentication) forControlEvents:UIControlEventTouchUpInside];
    }
    return _touchBtn;
}
-(void)setLocalAuthentication
{
    LAContext * context = [[LAContext alloc] init];
    NSError * error = nil;
    NSString * result = @"通过home键验证已有手机指纹";
    
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error])
    {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success){
                //验证成功
                NSLog(@"-----------验证成功");
                [self setAlertViewWithTitle:@"验证成功"];
            }else{
                NSLog(@"%@",error.localizedDescription);
                switch (error.code){
                    case LAErrorSystemCancel:{
                        NSLog(@"切换到其他APP，系统取消验证Touch ID");
                        [self setAlertViewWithTitle:@"系统取消"];
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                        [self setAlertViewWithTitle:@"用户取消验证"];
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        NSLog(@"用户选择其他验证方式，切换主线程处理");
                        [self setAlertViewWithTitle:@"用户选择其他验证方式"];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                        }];
                        break;
                    }
                    default:
                    {
                        NSLog(@"其他情况，切换主线程处理");
                        [self setAlertViewWithTitle:@"其他情况"];
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            
                        }];
                        break;
                    }
                }
            }
        }];
    }
    else
    {
        //不支持指纹识别，LOG出错误详情
        
        switch (error.code)
        {
            case LAErrorTouchIDNotEnrolled:
            {
                NSLog(@"TouchID is not enrolled");
                break;
            }
            case LAErrorPasscodeNotSet:
            {
                NSLog(@"A passcode has not been set");
                break;
            }
            default:
            {
                NSLog(@"TouchID not available");
                break;
            }
        }
        
        NSLog(@"不支持指纹识别");
        [self setAlertViewWithTitle:@"不支持指纹识别"];
    }
    
}
-(void)setAlertViewWithTitle:(NSString *)title
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >=9.0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:title preferredStyle:  UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alert animated:true completion:nil];
        
    }else{
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alt show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
