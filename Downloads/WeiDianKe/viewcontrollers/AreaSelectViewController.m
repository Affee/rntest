//
//  AreaSelectViewController.m
//  WeiDianKe
//
//  Created by 陈必锋 on 2017/5/12.
//  Copyright © 2017年 zichenfang. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "TitleCell.h"

@interface AreaSelectViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) NSArray* originDatas;
@property (strong,nonatomic) NSArray* showDatas;


@property (nonatomic) NSInteger nowSelectIndex;
@end

@implementation AreaSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = @"地址选择";
    
    self.nowSelectIndex = -1;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TitleCell class]) bundle:nil] forCellReuseIdentifier:@"TitleCell"];
    
    self.originDatas = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]];
    
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(-10, 0, 15, 20)];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back_navi"] forState:UIControlStateNormal];
    
    UIBarButtonItem* negSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negSpace.width = -8;
    
    self.navigationItem.leftBarButtonItems = @[negSpace,[[UIBarButtonItem alloc]initWithCustomView:backBtn]];
    
}

-(void)backBtnClick{
    if (self.nowSelectIndex == -1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.nowSelectIndex = -1;
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.nowSelectIndex == -1) {
        self.nowSelectIndex = indexPath.row;
        [self.tableView reloadData];
    }else{
        self.finishSelect([NSString stringWithFormat:@"%@-%@",self.originDatas[self.nowSelectIndex][@"state"],self.originDatas[self.nowSelectIndex][@"cities"][indexPath.row]]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nowSelectIndex == -1?self.originDatas.count:[self.originDatas[self.nowSelectIndex][@"cities"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TitleCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TitleCell"];
    if (self.nowSelectIndex == -1) {
        cell.titleL.text = self.originDatas[indexPath.row][@"state"];
    }else{
        cell.titleL.text = self.originDatas[self.nowSelectIndex][@"cities"][indexPath.row];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
