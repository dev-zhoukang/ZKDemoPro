//
//  ZKDiscoverViewController.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKDiscoverViewController.h"
#import "ZKTimelineViewController.h"

@interface ZKDiscoverViewController () <UITableViewDelegate>

@end

@implementation ZKDiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发现";
    [self requestData];
}

- (void)requestData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data_discover" ofType:@"plist"];
        self.dataSource = [NSArray arrayWithContentsOfFile:filePath];
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
       });
    });
}

#pragma mark - Override

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    [self judgeVCToJumpWithIndexPath:indexPath callback:^(UIViewController *vc){
        [self.navigationController pushViewController:vc animated:true];
    }];
}

- (void)judgeVCToJumpWithIndexPath:(NSIndexPath *)indexPath callback:(void(^)(UIViewController *vc))callback {
    
    UIViewController *targetVC = nil;
    
    NSString *title = self.dataSource[indexPath.section][indexPath.item][@"title"];
    if ([title isEqualToString:@"朋友圈"]) {
        targetVC = [ZKTimelineViewController new];
    }
    !callback?:callback(targetVC);
}

@end
