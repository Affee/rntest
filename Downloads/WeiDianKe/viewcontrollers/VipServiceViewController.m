//
//  VipServiceViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/11.
//  Copyright © 2017年 zichenfang. All rights reserved.
//



#import "VipServiceViewController.h"
#import "VipServiceCell.h"
#import "PayMentSelectViewController.h"
#import <MJRefresh.h>

@interface VipServiceViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSArray* datas;
@property (strong, nonatomic) IBOutlet UIButton *mingpianBtn;
@property (strong, nonatomic) IBOutlet UIButton *weChatBtn;
@property (strong, nonatomic) IBOutlet UIButton *gzhBtn;
@property (strong,nonatomic) NSMutableArray *btnArray;

@end

@implementation VipServiceViewController

-(void)viewDidAppear:(BOOL)animated{
    self.title = @"会员服务";
    if (![[TTUserInfoManager vip_typeid]  isEqualToString: @"1"] && ![[TTUserInfoManager vip_typeid] isEqualToString:@"2"] && ![[TTUserInfoManager vip_typeid] isEqualToString:@"3"]) {
        [TTUserInfoManager setVip_typeid:@"1"];
    }
    self.btnArray = [NSMutableArray arrayWithObjects:self.mingpianBtn,self.weChatBtn,self.gzhBtn, nil];
    UIButton *btn = [[UIButton alloc]init];
    btn.tag = [[TTUserInfoManager vip_typeid] integerValue];
    [self touchBtn:btn];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VipServiceCell class]) bundle:nil] forCellReuseIdentifier:@"VipServiceCell"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getService",
                                                 @"token":[TTUserInfoManager token],
                                                 @"payType":@"1",
                                                 @"vip_typeid":[TTUserInfoManager vip_typeid]}
                      Success:^(NSDictionary *responseJsonObject) {
                          if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                              self.datas = responseJsonObject[@"result"];
                              [self.tableView reloadData];
                          }else{
                              [ProgressHUD showError:responseJsonObject[@"msg"]];
                          }
                          [self.tableView.header endRefreshing];
                      } Failure:^(NSError *error) {
                          [self.tableView.header endRefreshing];
                      }];
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    
}
- (IBAction)touchBtn:(UIButton *)sender {
    [TTUserInfoManager setVip_typeid:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    for (UIButton *btn in self.btnArray) {
        if (btn.tag == sender.tag) {
            [btn setTitleColor:[UIColor colorWithRed:226/255.8f green:47/255.8f blue:39/255.8f alpha:1] forState:UIControlStateNormal];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, btn.bounds.size.height - 1, btn.bounds.size.width, 1)];
            lineView.backgroundColor = [UIColor colorWithRed:226/255.8f green:47/255.8f blue:39/255.8f alpha:1];
            lineView.tag = 111;
            [btn addSubview:lineView];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            for (UIView *theView in btn.subviews) {
                if (theView.tag == 111) {
                    [theView removeFromSuperview];
                }
            }
        }
    }
    
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getService",
                                             @"token":[TTUserInfoManager token],
                                             @"payType":@"1",
                                             @"vip_typeid":[NSString stringWithFormat:@"%ld",(long)sender.tag]}
                  Success:^(NSDictionary *responseJsonObject) {
                      if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                          self.datas = responseJsonObject[@"result"];
                          [self.tableView reloadData];
                      }else{
                          [ProgressHUD showError:responseJsonObject[@"msg"]];
                      }
                      [self.tableView.header endRefreshing];
                  } Failure:^(NSError *error) {
                      [self.tableView.header endRefreshing];
                  }];
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

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dict = self.datas[indexPath.row];
    PayMentSelectViewController *vc =[[PayMentSelectViewController alloc] init];
    vc.buyServicesType = BuyZizuan;
    vc.orderDes = dict[@"serviceName"];
    vc.orderPrice = dict[@"price"];
    vc.goodsId = dict[@"id"];
    vc.hidesBottomBarWhenPushed = YES;

    
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VipServiceCell* cell = [tableView dequeueReusableCellWithIdentifier:@"VipServiceCell"];
    [cell setupWithDict:self.datas[indexPath.row] isShop:NO forRow:indexPath.row];
    BOOL haveLine = NO;
    for (UIView *view in cell.subviews) {
        if (view.tag == 888) {
            haveLine = YES;
        }
    }
    if (haveLine == NO) {
        switch (indexPath.row) {
            case 1:
            case 3:
            {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.bounds.size.height - 2, self.tableView.bounds.size.width, 2)];
                lineView.tag = 888;
                lineView.backgroundColor = [UIColor colorWithRed:245/255.8f green:245/255.8f blue:245/255.8f alpha:1];
                [cell addSubview:lineView];
                
            }
                break;
                
            default:
            {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.bounds.size.height - 2, self.tableView.bounds.size.width, 2)];
                lineView.tag = 888;
                lineView.backgroundColor = [UIColor colorWithRed:245/255.8f green:245/255.8f blue:245/255.8f alpha:1];
                [cell addSubview:lineView];
            }
                break;
        }
    }

    return cell;
}


@end
