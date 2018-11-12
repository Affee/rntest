//
//  SelectOtherViewController.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/24.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "SelectOtherViewController.h"

@interface SelectOtherViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SelectOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

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
    }
    cell.textLabel.text = self.menus[indexPath.row];
    if (self.selectIndex ==indexPath.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectIndex = indexPath.row;
    [self.tableView reloadData];
}
- (IBAction)ok:(id)sender {
    
    if (self.selectIndex == NSNotFound) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (self.block) {
            self.block(self.menus[self.selectIndex]);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }

}

@end
