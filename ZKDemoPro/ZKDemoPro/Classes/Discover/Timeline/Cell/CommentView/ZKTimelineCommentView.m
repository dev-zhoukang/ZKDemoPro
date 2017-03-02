//
//  ZKTimelineCommentView.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/27.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKTimelineCommentView.h"
#import "ZKTimelineCommentCell.h"
#import "ZKTimelineCommentCellLayout.h"

@interface ZKTimelineCommentView() <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <ZKTimelineCommentCellLayout *> *dataSource;

@end

@implementation ZKTimelineCommentView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _dataSource = [[NSArray alloc] init];
    
    [self setupBgImage];
    [self setupSubViews];
}

- (void)setupBgImage {
    UIImage *bgImage = [UIImage imageNamed:@"Album_likes_comments_background"];
    CGSize imageSize = bgImage.size;
    CGFloat insetsTopBottom = imageSize.height * 0.5;
    CGFloat insetsLeftRight = imageSize.width * 0.5;
    
    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsMake(insetsTopBottom, insetsLeftRight, insetsTopBottom, insetsLeftRight)];
    
    _bgImageView = [UIImageView new];
    [self addSubview:_bgImageView];
    _bgImageView.image = bgImage;
    
    [_bgImageView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
}

- (void)setupSubViews {
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,self.us_width, self.us_height} style:UITableViewStylePlain];
    [self addSubview:_tableView];
    [_tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _tableView.scrollEnabled = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.contentInset = UIEdgeInsetsMake(8, 0, 0, 0);
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
}

#pragma mark - Calculate height

+ (CGFloat)calculateHeightWithCommentList:(NSArray<ZKComment *> *)commentList {
    if (commentList.count == 0) {
        return 0;
    }
    
    CGFloat height = 0;
    for (ZKComment *comment in commentList) {
        ZKTimelineCommentCellLayout *layout = [[ZKTimelineCommentCellLayout alloc] initWithComment:comment];
        height += layout.totalHeight;
    }
    height += 10;
    return height;
}

#pragma mark -  Update UI

- (void)updateWithCommentList:(NSArray <ZKComment *> *)commentList {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (ZKComment *comment in commentList) {
        ZKTimelineCommentCellLayout *layout = [[ZKTimelineCommentCellLayout alloc] initWithComment:comment];
        [tempArray addObject:layout];
    }
    _dataSource = tempArray.copy;
    [_tableView reloadData];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTimelineCommentCell *cell = [ZKTimelineCommentCell cellWithTableView:tableView];
    [cell updateWithLayout:_dataSource[indexPath.item]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZKTimelineCommentCellLayout *layout = _dataSource[indexPath.item];
    return layout.totalHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
