//
//  MyBonusListViewController.m
//  WeiDianKe
//
//  Created by 殷玉秋 on 2016/11/18.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "MyBonusListViewController.h"
#import "NSDate+MyDate.h"

@interface MyBonusListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;
@property (strong, nonatomic) NSDictionary *bonnusWithKeys;

@end

@implementation MyBonusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title  =@"我的奖品";
    NSString *path = [[NSBundle mainBundle] pathForResource:@"BonusWithKeysPlist" ofType:@"plist"];
    self.bonnusWithKeys = [NSDictionary dictionaryWithContentsOfURL:[NSURL fileURLWithPath:path]];
    [self loadData];
}
- (void)loadData
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/getChouRecord" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        self.datas = [responseJsonObject array_ForKey:@"result"];
        if ([code isEqualToString:@"1"])//
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi =@"bonus";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identi];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
    }
    NSDictionary *aobj = self.datas[indexPath.row];
    NSString *key = [aobj string_ForKey:@"bonus_type"];
    cell.textLabel.text = [self.bonnusWithKeys string_ForKey:key];
    NSTimeInterval timerInter = [[aobj string_ForKey:@"add_time"] doubleValue];
    cell.detailTextLabel.text = [[NSDate dateWithTimeIntervalSince1970:timerInter] formatTimeInyyyyMMdd];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
