//
//  UIView+MyView.m
//  ttdoctor
//
//  Created by zichenfang on 16/3/16.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "UIView+MyView.h"

@implementation UIView (MyView)
- (void)setAnchorPoint:(CGPoint)anchorPoint
{
    CGPoint oldOrigin = self.frame.origin;
    self.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = self.frame.origin;
    
    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;
    
    self.center = CGPointMake (self.center.x - transition.x, self.center.y - transition.y);
}
@end
