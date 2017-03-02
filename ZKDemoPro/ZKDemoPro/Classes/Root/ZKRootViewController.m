//
//  ZKRootViewController.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKRootViewController.h"
#import "ZKHomeBaseViewController.h"

@interface ZKRootViewController ()

@end

@implementation ZKRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = true;
    [self setupHomeVC];
}

- (void)setupHomeVC {
    ZKHomeBaseViewController *homeVC = [ZKHomeBaseViewController new];
    _rootNavigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [_rootNavigationController setNavigationBarHidden:true animated:false];
    
    [self addChildViewController:_rootNavigationController];
    [self.view insertSubview:_rootNavigationController.view atIndex:0];
    
    [_rootNavigationController.view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

@end
