//
//  PersonCardDetailViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/11.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "PersonCardDetailViewController.h"
#import "BookManager.h"

@interface PersonCardDetailViewController ()

@end

@implementation PersonCardDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!self.isPerson) {
        self.cpyBtn.hidden = YES;
        self.wechatNumL.hidden =YES;
        self.locationL.hidden = YES;
        [self.impBtn removeFromSuperview];
    }
    
    [self.cpyBtn.layer setBorderWidth:1];
    [self.cpyBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [self.cpyBtn.layer setCornerRadius:5];
    
    self.title = self.dataDict[@"nickname"];
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"userImg"]]];
    [self.nickNameL setText:self.dataDict[@"nickname"]];
    [self.wechatNumL setText:[NSString stringWithFormat:@"微信号：%@",self.dataDict[@"wechatName"]]];
    [self.locationL setText:[NSString stringWithFormat:@"%@  %@",self.dataDict[@"userArea"],self.dataDict[@"sex"]]];
    
    [self.personNumL setText:self.dataDict[@"popularity"]];
    [self.descL setText:self.dataDict[@"description"]];
    
    [self.qrcodeIV sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"qrcode"]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        [ProgressHUD showSuccess:@"保存成功"];
    }else{
        [ProgressHUD showError:@"保存失败"];
    }
}

- (IBAction)cpyBtnClick:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.dataDict[@"wechatName"];
    [ProgressHUD showSuccess:@"复制成功"];
}

- (IBAction)saveQrcodeBtnClick:(id)sender {
    if (self.qrcodeIV.image != nil) {
        UIImageWriteToSavedPhotosAlbum(self.qrcodeIV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }else{
        [ProgressHUD showError:@"二维码下载中...请稍等"];
    }
}

- (IBAction)importBookBtnClick:(id)sender {
    [BookManager writeBooksInVC:self Books:@[self.dataDict[@"mobile"]]];
}
@end
