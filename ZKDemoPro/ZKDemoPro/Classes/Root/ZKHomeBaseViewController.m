//
//  ZKHomeBaseViewController.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKHomeBaseViewController.h"
#import "ZKHVButton.h"
#import "ZKHomeViewController.h"
#import "ZKContactViewController.h"
#import "ZKDiscoverViewController.h"
#import "ZKMeViewController.h"

@interface ZKHomeBaseViewController ()

@property (weak, nonatomic) IBOutlet UIView *tabView;
@property (strong, nonatomic) IBOutletCollection(ZKHVButton) NSArray *tabBtns;

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray <UIViewController *> *viewControllers;
@property (nonatomic, strong) ZKHVButton *selectedBtn;

@end

@implementation ZKHomeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.hidden = true;
    [self setupTabBtns];
    [self setupPageViewController];
    [self setPageIndex:0];
}

- (void)setupPageViewController {
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@0.f}];
    _pageViewController.automaticallyAdjustsScrollViewInsets = false;
    
    [self addChildViewController:_pageViewController];
    [self.view insertSubview:_pageViewController.view belowSubview:_tabView];
    
    [_pageViewController.view makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setupTabBtns {
    NSArray *imageNames = @[@"tabbar_mainframe", @"tabbar_contacts", @"tabbar_discover", @"tabbar_me"];
    NSArray *titles = @[@"微信", @"通讯录", @"发现", @"我"];
    for (int i = 0; i < imageNames.count; i ++) {
        [self setupTabBtn:_tabBtns[i]
                    title:titles[i]
          normalImageName:imageNames[i]
        selectedImageName:[NSString stringWithFormat:@"%@HL", imageNames[i]]];
    }
}

- (void)setupTabBtn:(ZKHVButton *)btn
              title:(NSString *)title
    normalImageName:(NSString *)normalImageName
  selectedImageName:(NSString *)selectedImageName
{
    btn.backgroundColor = [UIColor clearColor];
    [btn setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:GlobalGreenColor forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
}

#pragma mark - Actions

- (IBAction)btnClick:(ZKHVButton *)btn {
    [self setPageIndex:btn.tag];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;
    NSInteger count = self.viewControllers.count;
    if (pageIndex < 0 || pageIndex >= count) {
        return;
    }
    [_pageViewController setViewControllers:@[self.viewControllers[pageIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    
    [self.tabBtns enumerateObjectsUsingBlock:^(ZKHVButton *btn, NSUInteger idx, BOOL * _Nonnull stop) {
        btn.selected = btn.tag == pageIndex;
        btn.userInteractionEnabled = !btn.isSelected;
    }];
}

- (NSArray<UIViewController *> *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = @[
                             [ZKHomeViewController new],
                             [ZKContactViewController new],
                             [ZKDiscoverViewController new],
                             [ZKMeViewController new]
                             ];
    }
    return _viewControllers;
}

@end
