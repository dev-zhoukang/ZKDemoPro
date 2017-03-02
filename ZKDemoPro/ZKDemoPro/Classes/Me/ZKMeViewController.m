//
//  ZKMeViewController.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKMeViewController.h"
#import "ZKCommonItemCell.h"
#import "ZKProfileHeaderCell.h"

@interface ZKMeViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ZKMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我";
    [self requestData];
}

- (void)requestData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data_me" ofType:@"plist"];
        self.dataSource = [[NSArray alloc] initWithContentsOfFile:filePath];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        tempArray = self.dataSource.mutableCopy;
        
        NSMutableArray *profileArray = [[NSMutableArray alloc] init];
        NSDictionary *dict = [NSDictionary dictionary];
        [profileArray addObject:dict];
        
        [tempArray insertObject:profileArray atIndex:0];
        self.dataSource = tempArray.copy;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Override

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    if (!indexPath.section) {
        cell = [ZKProfileHeaderCell cellWithTableView:tableView];
        return cell;
    }
    cell = [ZKCommonItemCell cellWithTableView:tableView];
    [cell updateWithDict:self.dataSource[indexPath.section][indexPath.item]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
        return 86.f;
    }
    return 44.f;
}

@end
