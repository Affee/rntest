//
//  UIView+Shake.h
//  DressIn3D
//
//  Created by Timo on 15/11/9.
//  Copyright © 2015年 Timo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shake)
//震动，你难以想象的频率
- (void)shake;
- (void)addShakeAnimationForView:(UIView *)view withDuration:(NSTimeInterval)duration;

@end
