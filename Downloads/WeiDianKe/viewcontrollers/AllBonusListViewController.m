//
//  AllBonusListViewController.m
//  WeiDianKe
//
//  Created by 殷玉秋 on 2016/11/18.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "AllBonusListViewController.h"

@interface AllBonusListViewController ()<UITableViewDataSource>
@property (nonatomic,strong)NSArray *allBounsList;
@end

@implementation AllBonusListViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title  =@"活动奖品";
    self.allBounsList =@[@"iPhone6",@"iPhone7",@"钻石会员1天",@"钻石会员30天",@"钻石会员永久",@"黄金会员1天",@"黄金会员永久",@"50个加粉名额",@"100个加粉名额",@"500个加粉名额",@"10000个加粉名额"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allBounsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi =@"bonus";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    cell.textLabel.text = self.allBounsList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
@end
