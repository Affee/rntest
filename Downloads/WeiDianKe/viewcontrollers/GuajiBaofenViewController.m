//
//  GuajiBaofenViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/23.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "GuajiBaofenViewController.h"

@interface GuajiBaofenViewController ()<UIWebViewDelegate>

@end

@implementation GuajiBaofenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"挂机爆粉";
    self.webView.scalesPageToFit = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [self refresh];

}
- (void)refresh
{
    if (kAPPDelegate.isReadyForSale ==NO) {
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"baofendoc" ofType:@"doc"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
    }
    else
    {
        NSString *url = [[TTUserInfoManager userInfo] string_ForKey:@"weichat_contacts_url"];
        
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    NSLog(@"shouldStartLoadWithRequest =%@",request.URL.absoluteString);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //    [ProgressHUD dismiss];
//    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
//{
//    //    [ProgressHUD dismiss];
//    //    [[[UIAlertView alloc] initWithTitle:@"网络链接错误" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil] show];
//}

@end
