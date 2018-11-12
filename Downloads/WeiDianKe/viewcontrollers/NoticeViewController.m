//
//  NoticeViewController.m
//  WeiDianKe
//
//  Created by lqz on 2017/7/4.
//  Copyright © 2017年 zichenfang. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "GuangGaoXiangQingViewController.h"
#import "NoticeViewController.h"
#import "NoticeTableViewCell.h"
@interface NoticeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"公告";
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NoticeTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"111"];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identi = @"111";
    NoticeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (cell ==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NoticeTableViewCell" owner:self options:nil][0];
        
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"picture"]]];
    //cell.contentLab.text = dic[@"content"];
    NSArray *contentArray = [self filterImage:dic[@"content"]];
    NSLog(@"%@",contentArray);
    cell.contentLab.attributedText = [self setHtmlStr:dic[@"content"]];
    
//    for (NSString *str in contentArray) {
//        cell.contentLab.text = [cell.contentLab.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<img src=\"%@\" alt=\"\" />",str] withString:[NSString stringWithFormat:@"%@%@",kHTTP,str]];

//    }
    NSString *timeStr = dic[@"time"];
    cell.titleLab.text = dic[@"title"];
    timeStr = [timeStr substringToIndex:10];
    cell.timeLab.text = timeStr;
    cell.timeLab.adjustsFontSizeToFitWidth = YES;
    return cell;
}

- (NSMutableAttributedString *)setHtmlStr:(NSString *)html
{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:222/255.8f green:224/255.8f blue:224/255.8f alpha:1]}  range:NSMakeRange(0, 10)];
        [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor clearColor]}  range:NSMakeRange(10,attr.length - 10)];
    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} range:NSMakeRange(0, attr.string.length)];
    
    return attr;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    GuangGaoXiangQingViewController *vc = [[GuangGaoXiangQingViewController alloc]init];
    vc.theId = dic[@"id"];
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Notice/queryInfo" Parameters:@{@"id":dic[@"id"]} Success:^(NSDictionary *responseJsonObject) {
        NSMutableDictionary *dic = responseJsonObject[@"result"][@"items"];
        vc.dataDic = dic;
        [self.navigationController pushViewController:vc animated:YES];
    } Failure:^(NSError *error) {
        
    }];
    
}

- (NSArray *)filterImage:(NSString *)html
{
    NSMutableArray *resultArray = [NSMutableArray array];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<(img|IMG)(.*?)(/>|></img>|>)" options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
    NSArray *result = [regex matchesInString:html options:NSMatchingReportCompletion range:NSMakeRange(0, html.length)];
    
    for (NSTextCheckingResult *item in result) {
        NSString *imgHtml = [html substringWithRange:[item rangeAtIndex:0]];
        
        NSArray *tmpArray = nil;
        if ([imgHtml rangeOfString:@"src=\""].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src=\""];
        } else if ([imgHtml rangeOfString:@"src="].location != NSNotFound) {
            tmpArray = [imgHtml componentsSeparatedByString:@"src="];
        }
        
        if (tmpArray.count >= 2) {
            NSString *src = tmpArray[1];
            
            NSUInteger loc = [src rangeOfString:@"\""].location;
            if (loc != NSNotFound) {
                src = [src substringToIndex:loc];
                [resultArray addObject:src];
            }
        }
    }
    
    return resultArray;
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
