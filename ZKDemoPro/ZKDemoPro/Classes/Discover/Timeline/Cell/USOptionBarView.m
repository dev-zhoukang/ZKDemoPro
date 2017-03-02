//
//  USOptionBarView.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/23.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "USOptionBarView.h"
#import "USCommentBarView.h"

@interface USOptionBarView()

@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UIView *optionBar;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *commentBtn;

@end

@implementation USOptionBarView

- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _showBtn = [[UIButton alloc] init];
    [self addSubview:_showBtn];
    [_showBtn setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
    _showBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _showBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [_showBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(self.mas_height);
        make.width.mas_equalTo(40);
        make.top.mas_equalTo(0);
    }];
    [_showBtn addTarget:self action:@selector(showBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _optionBar = [UIView new];
    [self addSubview:_optionBar];
    _optionBar.backgroundColor = HexColor(0x4c5154);
    [_optionBar makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(40);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.mas_equalTo(_showBtn.mas_left);
    }];
    _optionBar.layer.cornerRadius = 5.f;
    _optionBar.clipsToBounds = true;
    
    _commentBtn = [self subBtnWithTitle:@"评论"];
    [_commentBtn makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_optionBar.mas_width).dividedBy(2);
        make.height.mas_equalTo(_optionBar.mas_height);
        make.right.mas_equalTo(_optionBar.mas_right);
        make.top.mas_equalTo(_optionBar.mas_top);
    }];
    [_commentBtn addTarget:self action:@selector(commentBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _praiseBtn = [self subBtnWithTitle:@"赞"];
    [_praiseBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_commentBtn.mas_left);
        make.top.mas_equalTo(_optionBar.mas_top);
        make.width.mas_equalTo(_optionBar.mas_width).dividedBy(2);
        make.height.mas_equalTo(_optionBar.mas_height);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHideBarNoti) name:Notification_DidClickHideTimelineBottomBar object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)note {
    
    if (!_commentBtn.selected) {
        return;
    }
    
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UITableView *tableView = [self tableView];
    
    if (frame.origin.y == SCREEN_HEIGHT && frame.size.height != 0) {
        return;
    }
    tableView.contentInset = UIEdgeInsetsMake(0, 0, frame.size.height+45, 0);
    [tableView layoutIfNeeded];
    NSIndexPath *indexPath = [tableView indexPathForCell:[self tableViewCell]];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:true];
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    if (!_commentBtn.selected) {
        return;
    }
    [[self tableView] setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    _commentBtn.selected = false;
}

- (UIButton *)subBtnWithTitle:(NSString *)title {
    UIButton *btn = [[UIButton alloc] init];
    [_optionBar addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"circle"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    return btn;
}

- (void)handleHideBarNoti {
    if (!_showBtn.selected) {
        return;
    }
    _showBtn.selected = false;
    [self showBar:false];
}

- (void)showBtnClick {
    
    _showBtn.selected = !_showBtn.selected;
    
    [self showBar:_showBtn.selected];
}

- (void)showBar:(BOOL)show {
    if (show) {
        [_optionBar updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(160);
        }];
    }
    else {
        [_optionBar updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
    }
    
    [UIView animateWithDuration:0.25
                          delay:0
         usingSpringWithDamping:0.8
          initialSpringVelocity:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         [self layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - 获取控制器

- (UIViewController *)viewController
{
    UIViewController *viewController = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UIViewController class]]) {
            viewController = (UIViewController *)next;
            break;
        }
        next = next.nextResponder;
    }
    return viewController;
}

- (UITableView *)tableView
{
    __block UITableView *tableView = nil;
    
    [self.viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITableView class]]) {
            tableView = obj;
            *stop = YES;
        }
    }];
    return tableView;
}

- (UITableViewCell *)tableViewCell
{
    UITableViewCell *cell = nil;
    UIResponder *next = self.nextResponder;
    while (next) {
        if ([next isKindOfClass:[UITableViewCell class]]) {
            cell = (UITableViewCell *)next;
            break;
        }
        next = next.nextResponder;
    }
    return cell;
}

#pragma mark - Action

- (void)commentBtnClick {
    [USCommentBarView show];
    [self showBar:false];
    
    _commentBtn.selected = true;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
