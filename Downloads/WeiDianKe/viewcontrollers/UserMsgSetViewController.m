//
//  UserMsgSetViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/16.
//  Copyright © 2017年 zichenfang. All rights reserved.
//



#import "UserMsgSetViewController.h"
#import "UIViewController+BackButtonHandler.h"
#import <QiniuSDK.h>

@interface UserMsgSetViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>

@end

@implementation UserMsgSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"%@",self.data);
    
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getUserInfo",
                                             @"token":[TTUserInfoManager token]}
                  Success:^(NSDictionary *responseJsonObject) {
                      if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                          self.data = responseJsonObject[@"result"];
                          [self.headIV sd_setImageWithURL:[NSURL URLWithString:self.data[@"userImg"]]];
                          self.nickNameTF.text = self.data[@"nickname"];
                      }
                  } Failure:^(NSError *error) {
                      
                  }];

    
    self.title = @"头像昵称修改";
    
    self.nickNameTF.delegate = self;
    [self.nickNameTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImgPicker)];
    [self.headView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidChange:(UITextField*)textField{
    if (textField.text.length > 15) {
        textField.text = [textField.text substringToIndex:15];
    }
}

-(BOOL)navigationShouldPopOnBackButton{
    if (self.isFromSendCode) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        return NO;
    }
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* img = info[UIImagePickerControllerOriginalImage];
    self.headIV.image = img;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UINavigationControllerDelegate
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSDictionary *attributes_nulltitle = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                           
                                           NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    [viewController.navigationItem.rightBarButtonItem setTitleTextAttributes:attributes_nulltitle forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}


- (IBAction)submitBtnClick:(id)sender {
    if (self.headIV.image == nil){
        [ProgressHUD showError:@"请选择头像"];
    }else if (self.nickNameTF.text.length ==0){
        [ProgressHUD showError:@"请填写昵称"];
    }else{
        [ProgressHUD show:@"提交中..."];
//        [TTRequestManager GET:@"http://119.23.66.37/zhuanfa_jiafen/admin.php?r=api/Qrcode/GetImgCode" Parameters:@{@"token":[TTUserInfoManager token]} Success:^(NSDictionary *responseJsonObject) {
//            if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
//                NSString* keyToken = responseJsonObject[@"result"];
//                QNConfiguration* config = [QNConfiguration build:^(QNConfigurationBuilder* builder){
//                    builder.zone = [QNZone zone0];
//                }];
//                
//                QNUploadManager* uploadManager = [[QNUploadManager alloc]initWithConfiguration:config];
//                NSData* imgData = UIImageJPEGRepresentation(self.headIV.image,0.5);
//                
//                [uploadManager putData:imgData key:[NSString stringWithFormat:@"%@_%.0f",[TTUserInfoManager token],[[NSDate date] timeIntervalSince1970]*1000*1000] token:keyToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                    
//                    NSLog(@"info ===%@",info);
//                    NSLog(@"resp ===%@",resp);
//                    
//                    NSString* url = [NSString stringWithFormat:@"http://oqwhwbs1c.bkt.clouddn.com/%@",key];
        
        NSData *imgData = UIImageJPEGRepresentation(self.headIV.image, 1);
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        // 设置请求参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        params[@"key"] = @"picture";
        params[@"codeType"] = @"5004";
        [ProgressHUD show:@"正在加载"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                             @"text/html",
                                                             @"image/jpeg",
                                                             @"image/png",
                                                             @"application/octet-stream",
                                                             @"text/json",
                                                             nil];
        
        [manager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/uploadImage" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // 获取图片数据
            
            // 设置上传图片的名字
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            
            [formData appendPartWithFileData:imgData name:@"image" fileName:fileName mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 返回结果

            NSString *url = responseObject[@"result"][@"picture"];
                    [TTRequestManager POST:kHTTP Parameters:@{@"r":@"api/qrcode/updateUserInfo",
                                                              @"token":[TTUserInfoManager token],
                                                              @"userImg":url,
                                                              @"nickname":self.nickNameTF.text}
                                   Success:^(NSDictionary *responseJsonObject) {
                                       if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                                           [ProgressHUD showSuccess:@"修改成功"];
                                           [self.navigationController popViewControllerAnimated:YES];
                                       }else{
                                           [ProgressHUD showError:responseJsonObject[@"msg"]];
                                       }
                                   } Failure:^(NSError *error) {
                                       [ProgressHUD dismiss];
                                   }];
        }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [ProgressHUD dismiss];
            [ProgressHUD showError:@"加载失败"];
        }];
    }
//                } option:nil];
//            }else{
//                [ProgressHUD showError:responseJsonObject[@"msg"]];
//            }
//        } Failure:^(NSError *error) {
//            [ProgressHUD dismiss];
//        }];
//    }
}

-(void)showImgPicker{
    UIImagePickerController* vc = [[UIImagePickerController alloc]init];
    vc.navigationBar.tintColor = [UIColor redColor];
    vc.navigationBar.barTintColor = [UIColor redColor];
    
    vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
