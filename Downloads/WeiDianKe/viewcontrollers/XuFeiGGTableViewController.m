//
//  XuFeiGGTableViewController.m
//  WeiDianKe
//
//  Created by 龙泉舟 on 2017/7/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//
#import "PayMentSelectViewController.h"
#import "XuFeiGGTableViewController.h"
#import "AddAdvertisementViewController.h"
@interface XuFeiGGTableViewController ()<meDelegateViewController>
@property (strong, nonatomic) IBOutlet UITableView *theTableView;
@property(strong,nonatomic)NSMutableDictionary *seleDic;
@end

@implementation XuFeiGGTableViewController

-(void)delegateClick:(NSString *)meStr{

    [ProgressHUD showSuccess:@"续费成功!"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    //    self.theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"续费广告";
    [ProgressHUD show:@"加载中，请稍后"];
    
        [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Advert/queryWhere" Parameters:@{@"userId":[TTUserInfoManager userId]} Success:^(NSDictionary *responseJsonObject) {
            if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                self.DataArray = responseJsonObject[@"result"][@"items"];
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
    return self.DataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    
    NSDictionary *dataDic = self.DataArray[indexPath.row];
    
    UIImageView *cellImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 64.5, 64.5)];
    [cellImg sd_setImageWithURL:[NSURL URLWithString:dataDic[@"userImg"]]];
    
    [cell addSubview:cellImg];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(cellImg.frame.origin.x + cellImg.bounds.size.width + 20, 10, self.tableView.bounds.size.width - cellImg.frame.origin.x - cellImg.bounds.size.width - 15 - 80, 17)];
//    titleLab.font = [UIFont systemFontOfSize:13];
    titleLab.text = dataDic[@"title"];
    [cell addSubview:titleLab];
    
    UILabel *introduceLab = [[UILabel alloc]initWithFrame:CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y + titleLab.bounds.size.height + 5, self.tableView.bounds.size.width - titleLab.frame.origin.x - 80,85 - titleLab.frame.origin.y - titleLab.bounds.size.height - 15)];
//    introduceLab.text = dataDic[@"content"];
//    introduceLab.attributedText = [self setHtmlStr:dataDic[@"content"]];
    
    introduceLab.text = [self filterImage:dataDic[@"content"]][0];
    introduceLab.textColor = [UIColor colorWithRed:222/255.8f green:224/255.8f blue:224/255.8f alpha:1];
    introduceLab.numberOfLines = 2;
    [introduceLab sizeToFit];
    introduceLab.font = [UIFont systemFontOfSize:13];
    
    [cell addSubview:introduceLab];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.tableView.bounds.size.width - 85, 20, 75, 40)];
    [btn setBackgroundColor:[UIColor redColor]];
    
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn setTintColor:[UIColor whiteColor]];
    btn.tag = indexPath.row;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    [btn addTarget:self action:@selector(selectTable:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSArray *)filterImage:(NSString *)html
{
    
    NSArray *array = [html componentsSeparatedByString:@"<p>"];
    
    return array;
}


-(void)selectTable:(UIButton *)sender{
    self.seleDic = self.DataArray[sender.tag];
    PayMentSelectViewController *vc = [[PayMentSelectViewController alloc]init];
    vc.delegate = self;
    NSDictionary *dataDic = self.DataArray[sender.tag];
    vc.orderDes = [NSString stringWithFormat:@"购买广告:%@天",self.payDic[@"day"]];
    vc.day = self.payDic[@"day"];
    vc.orderPrice = self.payDic[@"money"];
    vc.buyServicesType = BuyXuFeiGuangGao;
    vc.guanggao = dataDic[@"id"];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

- (NSMutableAttributedString *)setHtmlStr:(NSString *)html
{
    NSAttributedString *briefAttrStr = [[NSAttributedString alloc] initWithData:[html dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:briefAttrStr];
    [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor colorWithRed:222/255.8f green:224/255.8f blue:224/255.8f alpha:1]}  range:NSMakeRange(0, attr.length)];
    //    [attr setAttributes:@{NSForegroundColorAttributeName :[UIColor clearColor]}  range:NSMakeRange(10,attr.length - 10)];
        [attr addAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} range:NSMakeRange(0, attr.string.length)];
    
    return attr;
    
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
