//
//  USCommentBarView.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/24.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "USCommentBarView.h"

@interface USCommentBarView() <YYTextViewDelegate>

@property (nonatomic, strong) UIView *topPanel;
@property (nonatomic, strong) UIView *bottomPanel;
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UIButton *switchBtn;
@property (nonatomic, assign) BOOL emoticonViewShowing;

@end

static const CGFloat kTopPanelDefaultHeight = 45.f;
const CGFloat kBottomPanelDefaultHeight = 215.f;;

@implementation USCommentBarView

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
    [self setupUI];
    [self addObserver];
}

+ (void)show {
    USCommentBarView *barView = [[USCommentBarView alloc] init];
    [KeyWindow addSubview:barView];
    [barView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(barView.superview.mas_bottom).offset(500);
    }];
    [barView.superview layoutIfNeeded];
    [barView.textView becomeFirstResponder];
}

- (void)setupUI {
    self.backgroundColor = GlobalChatBGColor;
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    _topPanel = [UIView new];
    [self addSubview:_topPanel];
    _topPanel.backgroundColor = GlobalBGColor;
    [_topPanel makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kTopPanelDefaultHeight);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    
    UIView *topLine = [UIView new];
    [_topPanel addSubview:topLine];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [topLine makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_topPanel.mas_width);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    UIView *bottomLine = [UIView new];
    [_topPanel addSubview:bottomLine];
    bottomLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:.5];
    [bottomLine makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_topPanel.mas_bottom);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_topPanel.mas_width);
    }];
    
    _textView = [YYTextView new];
    [_topPanel addSubview:_textView];
    _textView.font = [UIFont systemFontOfSize:14];
    _textView.placeholderText = @"评论";
    _textView.textContainerInset = UIEdgeInsetsMake(7, 6, 7, 6);
    _textView.delegate = self;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.borderColor = HexColor(0xededed).CGColor;
    _textView.layer.borderWidth = .5f;
    _textView.layer.cornerRadius = 5.f;
    _textView.clipsToBounds = true;
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_topPanel.mas_top).offset(7);
        make.bottom.mas_equalTo(_topPanel.mas_bottom).offset(-7);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(_topPanel.mas_right).offset(-54);
    }];
    
    _switchBtn = [UIButton new];
    [_topPanel addSubview:_switchBtn];
    [_switchBtn setImage:[UIImage imageNamed:@"ToolViewEmotion_35x35_"] forState:UIControlStateNormal];
    [_switchBtn makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_topPanel.mas_right);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(55);
    }];
    
    _bottomPanel = [UIView new];
    [self addSubview:_bottomPanel];
    [_bottomPanel makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kBottomPanelDefaultHeight);
        make.width.mas_equalTo(self.mas_width);
        make.top.mas_equalTo(_topPanel.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)handleWillChangeFrame:(NSNotification *)note {
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _keyboard_y = keyboardFrame.origin.y;
    
    [self updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-(keyboardFrame.size.height - kBottomPanelDefaultHeight));
    }];
    
    // 如果是退出键盘, 就直接退出输入框
    if (keyboardFrame.origin.y == SCREEN_HEIGHT && keyboardFrame.size.height != 0) {
        [self updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(1000);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self removeFromSuperview];
        });
    }
    
    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
    }];
}

/*! 根据内容设置 tableView的位移 */
- (void)setTableViewOffsetWithKeyboardY:(CGFloat)keyboardY barHeight:(CGFloat)barHeight
{
//    UITableView *tableView = [self tableView];
//    
//    CGFloat maxTabelHeight = SCREEN_HEIGHT-64.f-(SCREEN_HEIGHT-keyboardY+barHeight);
//    
//    CGFloat delta = tableView.contentSize.height - maxTabelHeight;
//    if (delta > 0) {
//        [tableView setContentOffset:CGPointMake(0, delta+kBottomInset)];
//    }
//    [tableView setContentInset:UIEdgeInsetsMake(tableView.contentInset.top,
//                                                0,
//                                                (SCREEN_HEIGHT-keyboardY)+kBottomInset+(barHeight-kChatBarHeight),
//                                                0)];
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidChange:(UITextView *)textView {
    [self autoLayoutHeight];
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    [self autoLayoutHeight];
}

- (void)autoLayoutHeight {
    CGFloat topPanelNewHeight = [_textView sizeThatFits:(CGSize){_textView.us_width, MAXFLOAT}].height + 14.f;
    if (topPanelNewHeight < kTopPanelDefaultHeight) {
        [self animateSetHeight:kTopPanelDefaultHeight];
        return;
    }
    [self animateSetHeight:topPanelNewHeight];
}

- (void)animateSetHeight:(CGFloat)topPanelNewHeight {
    if (topPanelNewHeight > kTopPanelDefaultHeight * 3 * WindowZoomScale) {
        return;
    }
    
    [_topPanel updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(topPanelNewHeight);
    }];
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut animations:^{
        self.bottom = _keyboard_y+kBottomPanelDefaultHeight;
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
