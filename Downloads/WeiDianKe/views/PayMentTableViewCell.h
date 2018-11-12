//
//  PayMentTableViewCell.h
//  WeiDianKe
//
//  Created by flappybird on 16/11/14.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayMentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *logoImgView;
@property (strong, nonatomic) IBOutlet UIImageView *selectImgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *unionL;

-(void)setUnionLHidden:(BOOL)hide;

@end
