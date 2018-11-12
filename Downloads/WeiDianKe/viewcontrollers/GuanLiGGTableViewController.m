//
//  GuanLiGGTableViewController.m
//  WeiDianKe
//
//  Created by 龙泉舟 on 2017/7/9.
//  Copyright © 2017年 zichenfang. All rights reserved.
//
#import "GuanLiGGTableViewCell.h"
#import "TTRequestManager.h"
#import "GuangGaoXiangQingViewController.h"
#import "GuanLiGGTableViewController.h"
#import "ProgressHUD.h"
#import "AddAdvertisementViewController.h"
@interface GuanLiGGTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property (strong,nonatomic)NSMutableArray *dataArray;
@end

@implementation GuanLiGGTableViewController

- (void)viewWillAppear:(BOOL)animated{

}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"管理广告";
    [ProgressHUD show:@"加载中"];
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryWhere" Parameters:@{@"userId":[TTUserInfoManager userId]} Success:^(NSDictionary *responseJsonObject) {
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
            self.dataArray = responseJsonObject[@"result"][@"items"];
            [self.tableView reloadData];
            
        }else{
            [ProgressHUD showError:responseJsonObject[@"msg"]];
        }
        [ProgressHUD dismiss];

    } Failure:^(NSError *error) {
        [ProgressHUD dismiss];
        [ProgressHUD showError:@"网络错误"];
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identi = @"222";
    GuanLiGGTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"GuanLiGGTableViewCell" owner:self options:nil][0];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"userImg"]]];
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius = 30;

//    cell.contentLab.attributedText = [self setHtmlStr:dic[@"content"]];
    cell.contentLab.text = [self filterImage:dic[@"content"]][0];
    cell.contentLab.textColor = [UIColor colorWithRed:222/255.8f green:224/255.8f blue:224/255.8f alpha:1];
    cell.contentLab.numberOfLines = 2;
    [cell.contentLab sizeToFit];
    cell.contentLab.font = [UIFont systemFontOfSize:13];
//    NSString *timeStr = dic[@"time"];
    cell.titleLab.text = dic[@"title"];
//    timeStr = [timeStr substringToIndex:10];
//    cell.timeLab.text = timeStr;
//    cell.timeLab.adjustsFontSizeToFitWidth = YES;
    return cell;

}


- (NSArray *)filterImage:(NSString *)html
{
    
    NSArray *array = [html componentsSeparatedByString:@"<p>"];
    
    return array;
}

- (NSMutableAttributedString *)setHtmlStr:(NSString *)html
{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:222/255.8f green:224/255.8f blue:224/255.8f alpha:1]}  range:NSMakeRange(0, attr.length)];
    //    [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor clearColor]}  range:NSMakeRange(10,attr.length - 10)];
    //    [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} range:NSMakeRange(0, attr.string.length)];
    
    return attr;
    
}

- (void)xiugaiGuangGao:(UIButton *)sender{

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GuangGaoXiangQingViewController *vc = [[GuangGaoXiangQingViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.dataDic = self.dataArray[indexPath.row];
    vc.xiuGai = [NSString stringWithFormat:@"%ld",indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
