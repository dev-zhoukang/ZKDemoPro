//
//  ZKViewController.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKViewController.h"

@implementation ZKNavigationBar

@end

// ==== 

@interface ZKViewController ()

@end

@implementation ZKViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *vcs = self.navigationController.childViewControllers;
    if (vcs.count > 1) {
        [self setNavigationBackButtonDefault];
    }
    self.view.clipsToBounds = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.navigationBar.clipsToBounds = YES;
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor clearColor];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [NSShadow new];
    [shadow setShadowColor: [UIColor clearColor]];
    NSDictionary *dict = @{NSShadowAttributeName:shadow,
                           NSFontAttributeName:[UIFont systemFontOfSize:18],
                           NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.titleTextAttributes = dict;
    
    if (self.navigationController) {
        self.navigationController.navigationBar.clipsToBounds = YES;
        self.navigationController.navigationBar.translucent = NO;
        self.navigationController.navigationBar.titleTextAttributes = dict;
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:-2 forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.view addSubview:self.navigationBar];
    [self.navigationBar pushNavigationItem:self.myNavigationItem animated:NO];
    [self.navigationBar makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(topInset);
    }];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)setTitle:(NSString *)title {
    self.myNavigationItem.title = title;
    
    [super setTitle:title];
}

- (void)setup {
    self.navigationBar = [ZKNavigationBar new];
    self.myNavigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    [self.navigationBar setTitleVerticalPositionAdjustment:-2.f forBarMetrics:UIBarMetricsDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

const CGFloat topInset = 64.f;
