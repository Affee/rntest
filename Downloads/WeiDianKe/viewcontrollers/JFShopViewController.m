//
//  JFShopViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/11.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "JFShopViewController.h"
#import "VipServiceCell.h"
#import <MJRefresh.h>

@interface JFShopViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSArray* datas;
@property (strong, nonatomic) IBOutlet UIButton *mingpianBtn;
@property (strong, nonatomic) IBOutlet UIButton *weChatBtn;
@property (strong, nonatomic) IBOutlet UIButton *gzhBtn;
@property(strong,nonatomic)NSMutableArray *btnArray;

@end

@implementation JFShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.mingpianBtn setTitleColor:[UIColor colorWithRed:226/255.8f green:47/255.8f blue:39/255.8f alpha:1] forState:UIControlStateNormal];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mingpianBtn.bounds.size.height - 1, self.mingpianBtn.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:226/255.8f green:47/255.8f blue:39/255.8f alpha:1];
    lineView.tag = 111;
    [self.mingpianBtn addSubview:lineView];
    self.btnArray = [NSMutableArray arrayWithObjects:self.mingpianBtn,self.weChatBtn,self.gzhBtn, nil];
    self.title = @"积分商城";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([VipServiceCell class]) bundle:nil] forCellReuseIdentifier:@"VipServiceCell"];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshData];
    }];
    
    
    [self.tableView.header beginRefreshing];
}
- (IBAction)touchBtn:(UIButton *)sender {
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
                                             @"payType":@"2",
                                             @"vip_typeid":[NSString stringWithFormat:@"%ld",sender.tag]}
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

-(void)refreshData{
    [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getService",
                                             @"token":[TTUserInfoManager token],
                                             @"payType":@"2",
                                             @"vip_typeid":[TTUserInfoManager vip_typeid]}
                  Success:^(NSDictionary *responseJsonObject) {
                      if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                          [self.jfCountL setText:[NSString stringWithFormat:@"剩余积分：%@积分",responseJsonObject[@"msg"]]];
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
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"确定要兑换%@?",dict[@"serviceName"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [TTRequestManager POST:kHTTP Parameters:@{@"r":@"api/user/openQrcodeMember",
                                                  @"token":[TTUserInfoManager token],
                                                  @"serviceId":dict[@"id"]
                                                  ,@"typeid":@"1"}
                       Success:^(NSDictionary *responseJsonObject) {
                           if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                               [ProgressHUD showSuccess:@"兑换成功"];
                               [self refreshData];
                           }else{
                               [ProgressHUD showError:responseJsonObject[@"result"]];
                           }
                       } Failure:^(NSError *error) {                      
                       }];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:okAction];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
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
    [cell setupWithDict:self.datas[indexPath.row] isShop:YES forRow:indexPath.row];
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
