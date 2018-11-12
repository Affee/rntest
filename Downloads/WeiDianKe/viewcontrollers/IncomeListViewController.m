//
//  IncomeListViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/25.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "IncomeListViewController.h"
#import "IncomeTableViewCell.h"
#import "NSDate+MyDate.h"
#import "AliCashViewController.h"

@interface IncomeListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *incomes_history;
@property (strong, nonatomic) NSArray *cash_history;

@property (strong, nonatomic) IBOutlet UILabel *yuElabel;
@property (strong, nonatomic) IBOutlet UILabel *allIncomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *caschLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *sengControl;
@end

@implementation IncomeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"收支明细";
    [self.sengControl setTintColor:[UIColor redColor]];
    self.sengControl.transform = CGAffineTransformMakeScale(1.15, 1.15);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    [self refresh];


}
- (void)refresh
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/getBalance" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];

    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        self.incomes_history = [result array_ForKey:@"incomes_history"];
        self.cash_history = [result array_ForKey:@"cash_history"];

        if ([code isEqualToString:@"1"])//
        {
            self.yuElabel.text = [result string_ForKey:@"remains"];
            self.allIncomeLabel.text = [result string_ForKey:@"incomes"];
            self.caschLabel.text = [result string_ForKey:@"casched"];
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
#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.sengControl.selectedSegmentIndex ==0) {
        return self.incomes_history.count;
    }
    else
    {
        return self.cash_history.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"111";
    IncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"IncomeTableViewCell" owner:self options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *aobj;
    if (self.sengControl.selectedSegmentIndex ==0) {
        aobj = [self.incomes_history objectAtIndex:indexPath.row];
    }
    else
    {
        aobj = [self.cash_history objectAtIndex:indexPath.row];
    }
    cell.titleL.text = [aobj string_ForKey:@"des "];
    cell.detailL.text =[aobj string_ForKey:@"time"];
    if (self.sengControl.selectedSegmentIndex ==0) {
        cell.noLabel.text = [NSString stringWithFormat:@"+%@元",[aobj string_ForKey:@"value"]];
    }
    else
    {
        cell.noLabel.text = [NSString stringWithFormat:@"-%@元",[aobj string_ForKey:@"value"]];
    }
    return cell;
}
- (IBAction)switchType:(UISegmentedControl *)sender {
    [self.tableView reloadData];
}

- (IBAction)aliCasch:(id)sender {
    AliCashViewController *vc = [[AliCashViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
