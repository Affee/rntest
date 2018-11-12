//
//  FitPhoneViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/23.
//  Copyright © 2016年 zichenfang. All rights reserved.
//


#import "FitPhoneViewController.h"
#import "FMDB.h"
#import "HZAreaPickerView.h"
#import "SelectOtherViewController.h"
#import "BookManager.h"


@interface FitPhoneViewController ()<UITableViewDelegate,UITableViewDataSource,HZAreaPickerDelegate, HZAreaPickerDatasource,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *menus;

@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) NSString *areaValue, *cityValue;
@property (strong, nonatomic) HZAreaPickerView *locatePicker;
@property (assign, nonatomic) BOOL isShowPicker;
@property (strong, nonatomic) NSMutableArray *books;

@end

@implementation FitPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"筛选加粉";
    self.menus = [NSMutableArray arrayWithArray:@[@"选择地区",@"选择行业",@"选择性别"]];
    self.books = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"xinbiao" ofType:@"sqlite"];
    self.db = [FMDatabase databaseWithPath:path];
    [self.db open];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.menus.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"111";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.menus[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            if (self.isShowPicker ==NO) {
                if (self.locatePicker==nil) {
                    self.locatePicker = [[HZAreaPickerView alloc] initWithStyle:HZAreaPickerWithStateAndCity
                                                                   withDelegate:self
                                                                  andDatasource:self];
                }
                [self.locatePicker showInView:self.view];
                self.isShowPicker =YES;
                tableView.userInteractionEnabled =NO;
            }
        }
            break;
        case 1:
        {
            SelectOtherViewController *vc = [[SelectOtherViewController alloc] init];
            vc.menus = @[@"人力",@"销售",@"市场",@"行政",@"客服",@"广告业",@"生产行业",@"汽车服务",@"物流运输",@"法律",@"医疗",@"金融",@"建筑",@"装修",@"酒店/旅游",@"运动健身",@"其他行业"];
            vc.selectIndex = [vc.menus indexOfObject:self.menus[1]];
            vc.block = ^(NSString *str){
                self.menus[1] = str;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            SelectOtherViewController *vc = [[SelectOtherViewController alloc] init];
            vc.menus = @[@"不限",@"男",@"女"];
            vc.selectIndex = [vc.menus indexOfObject:self.menus[2]];
            vc.block = ^(NSString *str){
                self.menus[2] = str;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark - 地区选择
#pragma mark - HZAreaPicker delegate
-(void)pickerDidChaneStatus:(HZAreaPickerView *)picker
{
    if([picker.locate.state isEqualToString:@"北京"]||[picker.locate.state isEqualToString:@"上海"]||[picker.locate.state isEqualToString:@"天津"]||[picker.locate.state isEqualToString:@"重庆"]||[picker.locate.state isEqualToString:@"澳门"])
    {
        self.cityValue = picker.locate.state;
    }
    else
    {
        self.cityValue = [NSString stringWithFormat:@"%@ %@", picker.locate.state, picker.locate.city];
    }
    self.menus[0] = self.cityValue;
    [self.tableView reloadData];
    
}

-(NSArray *)areaPickerData:(HZAreaPickerView *)picker
{
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    return data;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.locatePicker) {
        [self.locatePicker cancelPicker];
        self.isShowPicker =NO;
        self.tableView.userInteractionEnabled =YES;
    }
}
- (IBAction)okNow:(id)sender {
    if ([self.menus[0] isEqualToString:@"选择地区"]) {
        [ProgressHUD showError:@"请选择地区"];
        return;
    }
    [self phonesOnLine];
//    [self phonesLocal];

}
//从服务器获取
- (void)phonesOnLine
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    [para setObject:@"api/user/jiafen" forKey:@"r"];
    [para setObject:[TTUserInfoManager token] forKey:@"token"];
    
    [TTRequestManager GET:kHTTP Parameters:para Success:^(NSDictionary *responseJsonObject) {
        //
        NSString *code = [responseJsonObject string_ForKey:@"code"];
        NSString *msg = [responseJsonObject string_ForKey:@"msg"];
        NSDictionary *result = [responseJsonObject dictionary_ForKey:@"result"];
        NSArray *items = [result array_ForKey:@"items"];
        if ([code isEqualToString:@"1"])//
        {
            [self.books removeAllObjects];
            for (int i=0; i<items.count; i++) {
                NSString *phone = [[items objectAtIndex:i] string_ForKey:@"phone"];
                [self.books addObject:phone];
            }
            if (self.books.count<=0) {
                [ProgressHUD showError:@"加粉失败"];
            }
            else
            {
                [BookManager writeBooksInVC:self Books:self.books];
            }
            //刷新用户信息
            if ([[TTUserInfoManager userInfo] string_ForKey:@"user_lv"].intValue==0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
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
//本地生成
- (void)phonesLocal
{
    self.view.userInteractionEnabled = NO;
    [self performSelector:@selector(making) withObject:nil afterDelay:0.5];
}
- (void)making
{
    [self.books removeAllObjects];
    NSMutableArray *headers = [NSMutableArray array];
    if ([self.db open]) {
        NSString * sql = [NSString stringWithFormat:
                          @"SELECT MobileNumber FROM %@ WHERE MobileArea LIKE '%@%%'",@"mobile",self.cityValue];
        FMResultSet * rs = [self.db executeQuery:sql];
        int count =0;
        while ([rs next]) {
            NSString * MobileNumber = [rs stringForColumn:@"MobileNumber"];
            [headers addObject:MobileNumber];
            count++;
//            NSLog(@"%@--%d ",MobileNumber,count);
        }
        [self.db close];
    }
    if (headers.count<=0) {
        [ProgressHUD showError:@"未查询到相关资源"];
        return;
    }
    for (int i=0; i<200; i++) {
        int tail = arc4random()%10000;
        NSString *tailNO = [[NSString stringWithFormat:@"%.4f",tail*0.0001] stringByReplacingOccurrencesOfString:@"0." withString:@""];
        NSString *phone = [NSString stringWithFormat:@"%@%@",[headers objectAtIndex:arc4random()%(headers.count -1)],tailNO];
//        NSLog(@"%d --%@",i,phone);
        [self.books addObject:phone];

        
    }
//    NSLog(@"%@",self.books);
    
    [ProgressHUD dismiss];
    UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"完成" message:@"已筛选到符合条件的200个手机号" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"导入", nil];
    [ale show];
    self.view.userInteractionEnabled = YES;
    
}
#pragma mark -alert
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==1) {
        [ProgressHUD show:nil];
        [self performSelector:@selector(writeBooks) withObject:nil afterDelay:0.2];
    }
}
- (void)writeBooks
{
    [BookManager writeBooksInVC:self Books:self.books];
}
@end
