//
//  SSNoNavaBarViewController.m
//  WeiDianKe
//
//  Created by 殷玉秋 on 2016/11/18.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "SSNoNavaBarViewController.h"

@interface SSNoNavaBarViewController ()

@end

@implementation SSNoNavaBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

@end
