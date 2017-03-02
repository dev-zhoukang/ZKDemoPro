//
//  ZKDiscoverViewController.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKDiscoverViewController.h"

@interface ZKDiscoverViewController ()

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

@end
