//
//  QrCodeViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/10.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "QrCodeViewController.h"
#import "QrcodeCell.h"
#import "UIColor+MyColor.h"
#import "SendQrCodeViewController.h"
#import <MJRefresh.h>
#import "PersonCardDetailViewController.h"
#import "BookManager.h"

@interface QrCodeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSArray* zzDatas;
@property (strong,nonatomic) NSMutableArray* vipDatas;
@property (strong,nonatomic) NSArray *hzDatas;
@property (strong,nonatomic) NSMutableArray* commDatas;

@property (strong,nonatomic) NSString* nowIndex;

@end

@implementation QrCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"二维码平台";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.nowIndex = @"1";

    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataWithType:self.nowIndex];
    }];
    self.tableView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self pullUpDataWithType:self.nowIndex];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QrcodeCell class]) bundle:nil] forCellReuseIdentifier:@"QrcodeCell"];
    
 
    [self.tableView.header beginRefreshing];
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if ([self.nowIndex isEqualToString:@"1"] && self.commDatas.count != 0) {
            [self.tableView reloadData];
        }
    }];
}

-(void)getDataWithType:(NSString*)type{
    
    [TTRequestManager POST:@"http://weike.qb1611.cn/index.php?r=api/Qrcode/getInfo" Parameters:@{@"token":[TTUserInfoManager token], @"type":type} Success:^(NSDictionary *responseJsonObject) {
        if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
            self.vipDatas = [NSMutableArray array];
            self.zzDatas = responseJsonObject[@"result"][@"common1"];
            NSArray *vipArray = responseJsonObject[@"result"][@"common3"];
            self.hzDatas = responseJsonObject[@"result"][@"common2"];
            self.commDatas = [NSMutableArray arrayWithArray:responseJsonObject[@"result"][@"common4"]];
            
            for (NSDictionary *dic in vipArray) {
                if ([dic[@"gzh_red_expiration"] intValue] - [[NSDate date] timeIntervalSince1970] > 0){
                    [self.vipDatas insertObject:dic atIndex:0];
                }else{
                    [self.vipDatas addObject:dic];
                }
            }
            
            [self.tableView reloadData];
        }else{
            [ProgressHUD showError:responseJsonObject[@"msg"]];
        }
        [self.tableView.header endRefreshing];
                    } Failure:^(NSError *error) {
                        [self.tableView.header endRefreshing];
                         }];
    
}



-(void)pullUpDataWithType:(NSString*)type{
    if (self.commDatas.count != 0) {
        [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/getInfoPage",
                                                 @"token":[TTUserInfoManager token],
                                                 @"type":type,
                                                 @"id":self.commDatas.lastObject[@"id"]}
                      Success:^(NSDictionary *responseJsonObject) {
                          if ([responseJsonObject[@"code"] isEqualToString:@"1"]) {
                              if (self.commDatas != nil) {
                                  [self.commDatas addObjectsFromArray:responseJsonObject[@"result"]];
                              }
                          }else{
                              [ProgressHUD showError:responseJsonObject[@"msg"]];
                          }
                          [self.tableView.footer endRefreshing];
                      } Failure:^(NSError *error) {
                          [self.tableView.footer endRefreshing];
                      }];
    }else{
        [self.tableView.footer endRefreshing];
    }
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
    PersonCardDetailViewController* vc = [[PersonCardDetailViewController alloc]init];
    if (indexPath.row < self.zzDatas.count) {
        vc.dataDict = self.zzDatas[indexPath.row];
    }else if(indexPath.row < self.zzDatas.count+self.vipDatas.count){
        vc.dataDict = self.vipDatas[indexPath.row - self.zzDatas.count];
    }else if (indexPath.row < self.zzDatas.count + self.vipDatas.count + self.hzDatas.count){
        vc.dataDict = self.hzDatas[indexPath.row - self.zzDatas.count - self.vipDatas.count];
    }else{
        vc.dataDict = self.commDatas[indexPath.row - self.vipDatas.count - self.zzDatas.count - self.hzDatas.count];
    }
    
    if ([self.nowIndex isEqualToString:@"1"]) {
        vc.isPerson = YES;
    }else{
        vc.isPerson = NO;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.zzDatas.count + self.vipDatas.count + self.commDatas.count +self.hzDatas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QrcodeCell* cell = [tableView dequeueReusableCellWithIdentifier:@"QrcodeCell"];
    cell.zhonglei = self.nowIndex;
    if (indexPath.row < self.zzDatas.count) {
        [cell setupWithDictionary:self.zzDatas[indexPath.row] andType:1];
    }else if (indexPath.row < self.zzDatas.count + self.vipDatas.count) {
        [cell setupWithDictionary:self.vipDatas[indexPath.row - self.zzDatas.count] andType:4];
    }else if(indexPath.row < self.zzDatas.count + self.vipDatas.count + self.hzDatas.count){
        [cell setupWithDictionary:self.hzDatas[indexPath.row - self.zzDatas.count - self.vipDatas.count] andType:2];
    }else{
        [cell setupWithDictionary:self.commDatas[indexPath.row - self.vipDatas.count - self.zzDatas.count - self.hzDatas.count] andType:3];
    }
    
    [cell setClickAddBtn:^(NSDictionary *dict) {
        [TTRequestManager GET:kHTTP Parameters:@{@"r":@"api/qrcode/addFans",
                                                 @"token":[TTUserInfoManager token],
                                                 @"fansType":self.nowIndex,
                                                 @"mainId":dict[@"userId"]}
                      Success:^(NSDictionary *responseJsonObject) {
                          
                      } Failure:^(NSError *error) {
                          
                      }];
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"请选择要操作的项" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction* qrAction = [UIAlertAction actionWithTitle:@"保存二维码到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:dict[@"qrcode"]] options:SDWebImageLowPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                if (finished) {
                    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
                }else{
                    [ProgressHUD showError:@"二维码下载失败，请重试"];
                }
            }];
        }];
        
        UIAlertAction* impAction = [UIAlertAction actionWithTitle:@"添加到通讯录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [BookManager writeBooksInVC:self Books:@[dict[@"mobile"]]];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:qrAction];
        
        if ([self.nowIndex isEqualToString:@"1"]) {
            [alert addAction:impAction];
        }
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    return cell;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error == nil) {
        [ProgressHUD showSuccess:@"保存成功"];
    }else{
        [ProgressHUD showError:@"保存失败"];
    }
}

- (IBAction)personCarBtnClick:(id)sender {
    [self.personCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.personCarBtn setTitleColor:[UIColor colorWithHexString:@"ef5350"] forState:UIControlStateNormal];
    
    [self.nowIndexTipL setFrame:CGRectMake(CGRectGetMinX(self.personCarBtn.frame), CGRectGetMaxY(self.personCarBtn.bounds) - 2, CGRectGetWidth(self.personCarBtn.bounds), 2)];
    
    self.nowIndex = @"1";
    [self.tableView.header beginRefreshing];
}

- (IBAction)wechatBtnClick:(id)sender {
    [self.personCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor colorWithHexString:@"ef5350"] forState:UIControlStateNormal];
    [self.nowIndexTipL setFrame:CGRectMake(CGRectGetMinX(self.wechatBtn.frame), CGRectGetMaxY(self.personCarBtn.bounds) - 2, CGRectGetWidth(self.personCarBtn.bounds), 2)];
    
    self.nowIndex = @"2";
    [self.tableView.header beginRefreshing];
}

- (IBAction)gzhBtnClick:(id)sender {
    [self.personCarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.wechatBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.gzhBtn setTitleColor:[UIColor colorWithHexString:@"ef5350"] forState:UIControlStateNormal];
    [self.nowIndexTipL setFrame:CGRectMake(CGRectGetMinX(self.gzhBtn.frame), CGRectGetMaxY(self.personCarBtn.bounds) - 2, CGRectGetWidth(self.personCarBtn.bounds), 2)];
    
    self.nowIndex = @"3";
    [self.tableView.header beginRefreshing];
}

- (IBAction)sendQrCodeBtnClick:(id)sender {
    SendQrCodeViewController* vc = [[SendQrCodeViewController alloc]init];
    vc.beginIndex = [self.nowIndex integerValue] - 1;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)upServiceBtnClick:(id)sender {
    [self.tabBarController setSelectedIndex:1];
    [TTUserInfoManager setVip_typeid:self.nowIndex];
}
@end
