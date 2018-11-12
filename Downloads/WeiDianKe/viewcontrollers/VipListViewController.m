//
//  VipListViewController.m
//  WeiDianKe
//
//  Created by flappybird on 16/11/13.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "VipListViewController.h"
#import "VipTypeTableViewCell.h"
#import "PayMentSelectViewController.h"

@interface VipListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation VipListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"请选择会员类型";
    self.tableView.backgroundColor = [UIColor colorWithRed:245/255.8f green:245/255.8f blue:245/255.8f alpha:1];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datas.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"vips";
    VipTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell =[[NSBundle mainBundle] loadNibNamed:@"VipTypeTableViewCell" owner:self options:nil][0];
    }
    NSDictionary *aobj = [self.datas objectAtIndex:indexPath.section];
    cell.nameLabel.text =[aobj string_ForKey:@"value_des"];
    cell.desLabel.text = [aobj string_ForKey:@"function_des"];
    cell.desLabel.textColor = [UIColor colorWithRed:178/255.8f green:178/255.8f blue:178/255.8f alpha:1];
    switch (indexPath.section) {
        case 0:
        case 3:
        case 4:
        case 5:
        {
//            cell.nameLabel.textColor =[UIColor colorWithRed:178/255.8f green:178/255.8f blue:178/255.8f alpha:1];
            cell.nameLabel.textColor = [UIColor blackColor];
            cell.imgView.image = [UIImage imageNamed:@"super_vip_cell"];
        }
            break;
//        case 2:
//        case 3:
//        {
//            cell.nameLabel.textColor =[UIColor colorWithRed:178/255.8f green:178/255.8f blue:178/255.8f alpha:1];
//            cell.imgView.image = [UIImage imageNamed:@"hongzuan"];
//        }
//            break;

        case 1:
        case 2:
        {
//            cell.nameLabel.textColor =[UIColor colorWithRed:178/255.8f green:178/255.8f blue:178/255.8f alpha:1];
            cell.nameLabel.textColor = [UIColor blackColor];

            cell.imgView.image = [UIImage imageNamed:@"vip_cell"];
        }
            break;
            
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aobj = [self.datas objectAtIndex:indexPath.section];
    PayMentSelectViewController *vc =[[PayMentSelectViewController alloc] init];
    vc.orderDes =[aobj string_ForKey:@"value_des"];
    vc.orderPrice =[aobj string_ForKey:@"value"];
    vc.goodsId =[aobj string_ForKey:@"id"];

    vc.buyServicesType  =BuyServicesVipType;

    [self.navigationController pushViewController:vc animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 40)];
    headerView.backgroundColor = [UIColor colorWithRed:245/255.8f green:245/255.8f blue:245/255.8f alpha:1];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 2:
        case 4:
        {
            return 10;
        }
            break;
            
        default:
            return 1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==5) {
        return 2;
    }
    else
    {
        return 1;
    }
}
@end
