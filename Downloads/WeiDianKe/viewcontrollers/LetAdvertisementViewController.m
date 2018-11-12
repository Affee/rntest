//
//  LetAdvertisementViewController.m
//  WeiDianKe
//
//  Created by lqz on 2017/7/1.
//  Copyright © 2017年 zichenfang. All rights reserved.
//
#import "GuanLiGGTableViewController.h"
#import "AdvertisementPayViewController.h"
#import "LetAdvertisementViewController.h"
#import "AdvertisementExplainViewController.h"
@interface LetAdvertisementViewController ()
@property (strong, nonatomic) IBOutlet UILabel *guangGaoNumLab;
@property (strong, nonatomic) IBOutlet UIControl *guangGaoGuanLiView;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;

@end

@implementation LetAdvertisementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"广告位租出";
    
    NSString*userId = [TTUserInfoManager userId];
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryWhere" Parameters:@{@"userId":userId} Success:^(NSDictionary *responseJsonObject) {
        NSLog(@"%@",responseJsonObject);
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
//            self.dataArray = responseJsonObject[@"result"][@"items"];
//            [self.tableView reloadData];
            NSArray *array = responseJsonObject[@"result"][@"items"];
             self.guangGaoNumLab.text = [NSString stringWithFormat:@"%ld个",(unsigned long)array.count];
            [self.userImg sd_setImageWithURL:[NSURL URLWithString:array[0][@"userImg"]]];
            self.userImg.layer.masksToBounds = YES;
            self.userImg.layer.cornerRadius = 15;
        }
        else if ([responseJsonObject[@"code"] isEqualToString:@"2"]){
            self.guangGaoGuanLiView.hidden = YES;
        }
        else{
            [ProgressHUD showError:responseJsonObject[@"msg"]];
        }
    } Failure:^(NSError *error) {
        [ProgressHUD showError:@"网络错误"];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 广告位详细说明
- (IBAction)guangGaoXiangQing:(UIControl *)sender {
    AdvertisementExplainViewController *vc = [[AdvertisementExplainViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    //    vc.urlStr = @"https://www.baidu.com";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 广告位管理

- (IBAction)guangGaoGuanLi:(UIControl *)sender {
    GuanLiGGTableViewController *vc = [[GuanLiGGTableViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 发布广告 
- (IBAction)IssueAdvertisement:(UIButton *)sender {
    AdvertisementPayViewController *vc = [[AdvertisementPayViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
