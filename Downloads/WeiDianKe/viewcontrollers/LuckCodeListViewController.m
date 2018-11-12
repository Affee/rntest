//
//  LuckCodeListViewController.m
//  WeiDianKe
//
//  Created by 殷玉秋 on 2016/11/18.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "LuckCodeListViewController.h"
#import "PayMentSelectViewController.h"

@interface LuckCodeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;

@end

@implementation LuckCodeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  =@"购买幸运码";
    [self loadData];
}
- (void)loadData
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/common/getChoujiangList" forKey:@"r"];
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        self.datas = [responseJsonObject array_ForKey:@"result"];
        if (self.datas.count>0)//
        {
            
            [self.tableView reloadData];
        }
        else
        {
            [ProgressHUD showError:msg];
        }
    } Failure:^(NSError *error) {
        //
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi =@"bonus";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    NSDictionary *aobj = [self.datas objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@个幸运码【￥%@】",[aobj string_ForKey:@"lucky_code_count"],[aobj string_ForKey:@"lucky_code_price"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aobj = [self.datas objectAtIndex:indexPath.row];
    PayMentSelectViewController *vc =[[PayMentSelectViewController alloc] init];
    vc.orderDes =[NSString stringWithFormat:@"%@个幸运码【￥%@】",[aobj string_ForKey:@"lucky_code_count"],[aobj string_ForKey:@"lucky_code_price"]];
    vc.orderPrice =[aobj string_ForKey:@"lucky_code_price"];
    vc.goodsId =[aobj string_ForKey:@"lucky_code_id"];
    
    vc.buyServicesType  =BuyServicesLuckyCodeType;
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
