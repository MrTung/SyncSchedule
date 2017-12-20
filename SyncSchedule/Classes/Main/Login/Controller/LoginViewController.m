//
//  LoginViewController.m
//  SyncSchedule
//
//  Created by 董徐维 on 15/8/12.
//  Copyright (c) 2015年 董徐维. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountText;

@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

#pragma mark -- 生命周期方法 --
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置登录按钮外观
    self.loginBtn.layer.cornerRadius = 5.0f;
    self.loginBtn.layer.masksToBounds = YES;
}


#pragma mark -- 事件方法 --
/**
 *  单击背景取消键盘
 */
- (IBAction)sigleTapBackgrouned:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark 登录、注册、取回密码
/**
 *  登录
 */
- (IBAction)loginNow:(id)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (!([SharedAppUtil defaultCommonUtil].silentDeviceToken.length > 0) || !([SharedAppUtil defaultCommonUtil].commonDeviceToke.length > 0)) {
        return [NoticeHelper AlertShow:@"您的设备未允许接收推送消息，请在设置中修改"];
    }
    
    [CommonRemoteHelper RemoteWithUrl:URL_Login
                           parameters: @{@"userName" : self.accountText.text,
                                         @"password" : [SecurityUtil encryptMD5String:self.passwordText.text],
                                         @"jmDeviceToken" : [SharedAppUtil defaultCommonUtil].silentDeviceToken,
                                         @"commonDeviceToke" : [SharedAppUtil defaultCommonUtil].commonDeviceToke}
                                 type:CommonRemoteTypeGet success:^(NSDictionary *dict, id responseObject) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     
                                     if ([[dict valueForKey:@"code"] integerValue] != 200) {
                                       return [NoticeHelper AlertShow:[dict valueForKey:@"responseMsg"]];
                                     }
                                     
                                     UserModel *model = [UserModel mj_objectWithKeyValues:dict];
                                     
                                     [SharedAppUtil defaultCommonUtil].usermodel = model;
                                     
                                     [ArchiverCacheHelper saveObjectToLoacl:model key:User_Archiver_Key filePath:User_Archiver_Path];
                                     
                                     [MTControllerChooseTool setMainViewController];
                                     
                                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                 }];
}


@end
