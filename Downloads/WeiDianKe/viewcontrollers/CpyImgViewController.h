//
//  CpyImgViewController.h
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/12.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CpyImgViewController : UIViewController
- (IBAction)savePicBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@end
