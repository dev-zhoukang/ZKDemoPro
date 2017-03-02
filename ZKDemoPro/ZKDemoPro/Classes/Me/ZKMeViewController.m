//
//  ZKMeViewController.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKMeViewController.h"
#import "ZKCommonItemCell.h"

#define LineColor   HexColor(0xdcdcdc)

@interface ZKMeViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ZKMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我";
    [self setupTableView];
    [self requestData];
}

- (void)requestData {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data_me" ofType:@"plist"];
        _dataSource = [[NSArray alloc] initWithContentsOfFile:filePath];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
        });
    });
}

- (void)setupTableView {
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){CGPointZero, SCREEN_WIDTH, SCREEN_HEIGHT} style:UITableViewStylePlain];
    [self.view insertSubview:_tableView belowSubview:self.navigationBar];
    _tableView.contentInset = UIEdgeInsetsMake(topInset + 15.f, 0, 0, 0);
    _tableView.backgroundColor = GlobalBGColor;
    _tableView.separatorColor = LineColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 44.f;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource[section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [UIView new];
    footer.us_size = (CGSize){SCREEN_WIDTH, 22.f};
    
    UIView *topLine = [UIView new];
    [footer addSubview:topLine];
    topLine.us_size = (CGSize){SCREEN_WIDTH, 1.f/MainScale()};
    topLine.us_top = 0;
    topLine.backgroundColor = LineColor;
    
    UIView *bottomLine = [UIView new];
    [footer addSubview:bottomLine];
    bottomLine.us_size = topLine.us_size;
    bottomLine.us_bottom = footer.us_bottom;
    bottomLine.backgroundColor = section == self.dataSource.count-1 ? [UIColor clearColor] : LineColor;
    
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 22.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKCommonItemCell *cell = [ZKCommonItemCell cellWithTableView:tableView];
    return cell;
}

@end
