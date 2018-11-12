//
//  LearnViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/21.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "LearnViewController.h"
@interface LearnViewController ()<UIWebViewDelegate>

@end

@implementation LearnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新手指南";
    self.webView.scalesPageToFit = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [self refresh];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:itunesInfoUpdated object:nil];

}
- (void)refresh
{
    if (kAPPDelegate.isReadyForSale ==NO) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"learndoc" ofType:@"doc"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    }
    else
    {
        NSString *url = [[TTUserInfoManager userInfo] string_ForKey:@"instruction_url"];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [ProgressHUD dismiss];
//    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if ([webView canGoBack]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backItem"] style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}
- (void)goback
{
    [self.webView goBack];
}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
//{
//    //    [ProgressHUD dismiss];
//    //    [[[UIAlertView alloc] initWithTitle:@"网络链接错误" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
//}


@end
