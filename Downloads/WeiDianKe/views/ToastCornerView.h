//
//  ToastCornerView.h
//  weishang_vip
//
//  Created by flappybird on 16/10/26.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToastCornerView : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;

@end
