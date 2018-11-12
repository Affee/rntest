//
//  AdvertisementExplainViewController.m
//  WeiDianKe
//
//  Created by lqz on 2017/7/1.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "AdvertisementExplainViewController.h"
#import "ProgressHUD.h"
@interface AdvertisementExplainViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AdvertisementExplainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    if (self.urlStr) {
        self.navigationItem.title = @"广告详情";
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];

    }else{
        self.navigationItem.title = @"广告位详细说明";
        
        [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryAdInfo" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
            if ([responseJsonObject[@"code"]  isEqualToString:@"1"]) {
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:responseJsonObject[@"result"][@"items"][@"url"]]]];
            }else{
                [ProgressHUD showError:@"网络错误"];
            }
        } Failure:^(NSError *error) {
                [ProgressHUD showError:@"网络错误"];

        }];
    }
    // Do any additional setup after loading the view from its nib.
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

@end
