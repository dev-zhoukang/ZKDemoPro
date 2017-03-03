//
//  ZKTimelineViewController.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKTimelineViewController.h"
#import "ZKTimelineCell.h"
#import "ZKTimelineCellLayout.h"
#import "MJRefresh.h"

@interface ZKTimelineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray <ZKTimelineCellLayout *> *dataSource;
@property (nonatomic, assign) NSUInteger currentPage;

@end

@implementation ZKTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self initData];
    
    [self setupRefresh];
}

- (void)setupRefresh {
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPage = 0;
        [self requestDataPullDown:true];
    }];
    [_tableView.mj_header beginRefreshing];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _currentPage ++;
        [self requestDataPullDown:false];
    }];
}

- (void)requestDataPullDown:(BOOL)isPullDown {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *pathStr = [NSString stringWithFormat:@"data_%zd", _currentPage];
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:pathStr ofType:@"plist"];
        NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        NSArray *dynamicArray = fileDict[@"dynamic"];
        
        NSArray <ZKTimeline *> *oriModels = [NSArray modelArrayWithClass:[ZKTimeline class] json:dynamicArray];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        for (ZKTimeline *model in oriModels) {
            ZKTimelineCellLayout *layout = [[ZKTimelineCellLayout alloc] initWithTimelineModel:model];
            [tempArray addObject:layout];
        }
        
        isPullDown && (_dataSource = [[NSMutableArray alloc] init]);
        [_dataSource addObjectsFromArray:tempArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            
            [_tableView.mj_header endRefreshing];
            
            if (!dynamicArray.count) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else {
                [_tableView.mj_footer endRefreshing];
            }
        });
    });
}

- (void)setupUI {
    self.title = @"朋友圈";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,topInset, SCREEN_WIDTH, SCREEN_HEIGHT-topInset} style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)initData {
    _dataSource = [[NSMutableArray alloc] init];
    _currentPage = 0;
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTimelineCell *cell = [ZKTimelineCell cellWithTableView:tableView];
    [cell updateWithModelLayout:_dataSource[indexPath.item]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_dataSource[indexPath.item] totalHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DidClickHideTimelineBottomBar object:nil];
}

// 监听右滑事件
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [KeyWindow endEditing:true];
}

@end
