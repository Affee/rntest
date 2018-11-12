//
//  WebViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/27.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.title = @"新手指南";
    if (self.isPresent ==YES) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    }
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
    
}
- (void)goback
{
    [self dismissViewControllerAnimated:YES completion:nil];
    kAPPDelegate.isShowNotiWebVC = NO;
}
- (void)reloadUrl
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
@end
