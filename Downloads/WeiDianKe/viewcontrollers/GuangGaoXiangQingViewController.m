//
//  GuangGaoXiangQingViewController.m
//  WeiDianKe
//
//  Created by 龙泉舟 on 2017/7/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "GuangGaoXiangQingViewController.h"
#import "AddAdvertisementViewController.h"
@interface GuangGaoXiangQingViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UILabel *biaotiLab;
@property (strong, nonatomic) IBOutlet UILabel *shijianLab;
@property (strong, nonatomic) IBOutlet UILabel *yonghuLab;
@property (strong, nonatomic) IBOutlet UITextView *neirongText;

@end

@implementation GuangGaoXiangQingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    self.webView.backgroundColor = [UIColor clearColor];
    [self.webView setOpaque:NO];
    [[[self.webView subviews] objectAtIndex:0] setBounces:NO];
    

    if (self.theId) {
        self.navigationItem.title = @"公告详情";
        self.biaotiLab.text = self.dataDic[@"title"];
        [self.webView loadHTMLString:self.dataDic[@"content"] baseURL:nil];

        self.shijianLab.text = self.dataDic[@"time"];
    }else if (self.xiuGai){
        self.navigationItem.title = @"广告详情";
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 23)];
        view.backgroundColor = [UIColor clearColor];
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 23)];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [rightBtn addTarget:self action:@selector(xiugai) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:@"修改" forState:UIControlStateNormal];
        [rightBtn setTintColor:[UIColor whiteColor]];
        rightBtn.backgroundColor = [UIColor clearColor];
        self.biaotiLab.text = self.dataDic[@"title"];
        self.shijianLab.text  = self.dataDic[@"time"];
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = anotherButton;
        [self.webView loadHTMLString:self.dataDic[@"content"] baseURL:nil];

    }else{
        self.navigationItem.title = @"广告详情";
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryAllAdver" Parameters:@{} Success:^(NSDictionary *responseJsonObject) {
        NSLog(@"%@",responseJsonObject[@"result"]);
        NSMutableDictionary *dic = responseJsonObject[@"result"][@"items"][self.theTag];
        self.biaotiLab.text = dic[@"title"];
        self.shijianLab.text  = dic[@"time"];

        [self.webView loadHTMLString:dic[@"content"] baseURL:nil];

    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    img.style.maxWidth = %f;   \
    } \
    }";
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"imgAutoFit()"];
}

-(void)xiugai{
    AddAdvertisementViewController *vc = [[AddAdvertisementViewController alloc]init];
//    vc.hidesBottomBarWhenPushed = YES;
    vc.dataDic = self.dataDic;
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSMutableAttributedString *)setHtmlStr:(NSString *)html
{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} range:NSMakeRange(0, attr.string.length)];
    
    return attr;
    
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
