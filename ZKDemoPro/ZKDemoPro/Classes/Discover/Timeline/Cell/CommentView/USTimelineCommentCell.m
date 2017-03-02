//
//  USTimelineCommentCell.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/28.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "USTimelineCommentCell.h"
#import "USTimelineCommentCellLayout.h"

@interface USTimelineCommentCell()

@property (nonatomic, strong) YYLabel *commentLabel;

@end

#define HighlightColor    HexColor(0xe8e8e8)

@implementation USTimelineCommentCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"USTimelineCommentCell";
    USTimelineCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[USTimelineCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // [super setHighlighted:highlighted animated:animated];
    self.backgroundColor = (highlighted || self.isFirstResponder) ? HighlightColor : [UIColor clearColor];
}

- (void)setup {
    self.backgroundColor = [UIColor clearColor];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self addGestureRecognizer:longPress];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidhideMenuNoti) name:UIMenuControllerDidHideMenuNotification object:nil];
    
    _commentLabel = [YYLabel new];
    [self.contentView addSubview:_commentLabel];
    _commentLabel.text = @"测试测试测试测试测试";
    [_commentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(5);
    }];
}

// 点击 menu 的按钮之后 系统会发送 menu 消失的通知, 做相应处理
- (void)handleDidhideMenuNoti {
    [UIView animateWithDuration:.08 animations:^{
        self.backgroundColor = [UIColor clearColor];
    }];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer {
    // 不加判断的话, menu 弹出会很频繁
    if (recognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    [recognizer.view becomeFirstResponder];
    
    UIMenuController *copyMenu = [UIMenuController sharedMenuController];
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(copyAction:)];
    [copyMenu setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
    [copyMenu setTargetRect:recognizer.view.bounds inView:recognizer.view];
    [copyMenu setMenuVisible:YES animated:YES];
    
    [UIView animateWithDuration:.08 animations:^{
        self.backgroundColor = HighlightColor;
    }];
}

#pragma mark - UIResponder

// 是否可以成为第一响应者
- (BOOL)canBecomeFirstResponder {
    return true;
}

// 是否可以响应一些事件
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyAction:)){
        return YES;
    }
    return NO;
}

- (void)copyAction:(id)sender {
    [[UIPasteboard generalPasteboard] setString:_commentLabel.text];
}

#pragma mark - Update UI

- (void)updateWithLayout:(USTimelineCommentCellLayout *)layout {
    _commentLabel.textLayout = layout.textLayout;
    [_commentLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(layout.totalHeight);
    }];
}

@end
