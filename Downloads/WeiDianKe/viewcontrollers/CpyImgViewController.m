//
//  CpyImgViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/12.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "CpyImgViewController.h"

@interface CpyImgViewController ()

@end

@implementation CpyImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"复制图片";
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://weike.qb1611.cn/index.php?r=api/Qrcode/getShareImg&token=%@",[TTUserInfoManager token]]] placeholderImage:nil options:SDWebImageCacheMemoryOnly];
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

- (IBAction)savePicBtnClick:(id)sender {
    if (self.imgV.image != nil) {
        UIImageWriteToSavedPhotosAlbum(self.imgV.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    }else{
        [ProgressHUD showError:@"图片下载中...请稍等"];
    }
}
@end
