//
//  InviteListViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/25.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "InviteListViewController.h"

@interface InviteListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *datas;

@end

@implementation InviteListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"邀请记录";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [self refresh];

}
- (void)refresh
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/inviteList" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    [para setObject:@"1" forKey:@"page"];

    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        self.datas = [result array_ForKey:@"items"];
        
        if ([code isEqualToString:@"1"])//
        {
            [self.tableView reloadData];
            if (self.datas.count ==0) {
                [ProgressHUD showError:@"暂无邀请记录"];
            }
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

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"111";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identi];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *aobj = [self.datas objectAtIndex:indexPath.row];
    cell.textLabel.text = [aobj string_ForKey:@"mobile"];
    cell.detailTextLabel.text = [aobj string_ForKey:@"addtime"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
@end
