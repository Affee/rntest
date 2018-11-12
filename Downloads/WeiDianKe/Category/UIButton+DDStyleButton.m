//
//  UIButton+DDStyleButton.m
//  DressIn3D_0218
//
//  Created by zichenfang on 16/2/19.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "UIButton+DDStyleButton.h"
#import "UIImage+MyCustomImage.h"
#import "UIColor+MyColor.h"

@implementation UIButton (DDStyleButton)
- (void)myRoundCornerStrongStyle
{
    self.layer.masksToBounds =YES;
    self.layer.cornerRadius =4.0f;
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor stylePinkColor]] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
}
- (void)myRoundCornerLightStyle
{
//    self.layer.masksToBounds =YES;
//    self.layer.cornerRadius =4.0f;
//    [self setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//    [self setBackgroundImage:[UIImage imageWithColor:kStyleNoEnableGrayColor] forState:UIControlStateDisabled];
//    [self setTitleColor:kStylePinkColor forState:UIControlStateNormal];
//    self.titleLabel.font = [UIFont systemFontOfSize:15.0f];
//    self.layer.borderWidth =1;
//    self.layer.borderColor = kStylePinkColor.CGColor;
}
@end
