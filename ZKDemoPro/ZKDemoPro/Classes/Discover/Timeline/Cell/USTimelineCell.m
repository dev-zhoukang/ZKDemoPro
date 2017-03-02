//
//  USTimelineCell.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "USTimelineCell.h"
#import "USImageLayoutView.h"
#import "USTimelineCellLayout.h"
#import "USRegularTool.h"
#import "USOptionBarView.h"
#import "USTimelineCommentView.h"

@interface USTimelineCell()

@property (nonatomic, strong) USTimelineCellLayout *modelLayout;

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *contentLabel;
@property (nonatomic, strong) USImageLayoutView *imageLayoutView;
@property (nonatomic, strong) USOptionBarView *optionBarView;
@property (nonatomic, strong) YYLabel *locationLabel;
@property (nonatomic, strong) YYLabel *timeLabel;
@property (nonatomic, strong) USTimelineCommentView *commentView;

@end

static const CGFloat kLeftMargin = 70.f; //  avatarWidth + margin * 2
static const CGFloat kRightMargin = 15.f;

@implementation USTimelineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"USTimelineCell";
    USTimelineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[USTimelineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    _iconView = [UIImageView new];
    [self.contentView addSubview:_iconView];
    _iconView.image = [UIImage imageNamed:@"zk_app_icon"];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    [_iconView makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo((CGSize){50, 50});
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    _nameLabel = [YYLabel new];
    [self.contentView addSubview:_nameLabel];
    _nameLabel.text = @"我是名字";
    _nameLabel.textColor = ThemColor;
    _nameLabel.font = [UIFont systemFontOfSize:16];
    
    [_nameLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).offset(10);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(30);
    }];
    
    _contentLabel = [YYLabel new];
    [self.contentView addSubview:_contentLabel];
    _contentLabel.textColor = HexColor(0x535353);
    _contentLabel.font = [UIFont systemFontOfSize:14];
    _contentLabel.numberOfLines = 0;
    _contentLabel.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        YYTextHighlight *highlight = [text attribute:YYTextHighlightAttributeName atIndex:range.location];
        [USRegularTool handleClickRegularTextWithInfo:highlight.userInfo];
    };
    
    [_contentLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nameLabel.mas_bottom);
        make.left.mas_equalTo(_nameLabel.mas_left);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(50);
    }];
    
    _imageLayoutView = [USImageLayoutView new];
    [self.contentView addSubview:_imageLayoutView];
    [_imageLayoutView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_contentLabel.mas_bottom);
        make.left.mas_equalTo(kLeftMargin);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(0);
    }];
    
    _locationLabel = [YYLabel new];
    [self.contentView addSubview:_locationLabel];
    _locationLabel.font = [UIFont systemFontOfSize:12];
    _locationLabel.textColor = [ThemColor colorWithAlphaComponent:.7];
    _locationLabel.text = @"北京市朝阳区";
    [_locationLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageLayoutView.mas_bottom).offset(10);
        make.left.mas_equalTo(kLeftMargin);
        make.size.mas_equalTo((CGSize){200, 20});
    }];
    
    _timeLabel = [YYLabel new];
    [self.contentView addSubview:_timeLabel];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.textColor = HexColor(0x737373);
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_locationLabel.mas_bottom);
        make.height.mas_equalTo(15);
        make.left.mas_equalTo(_locationLabel.mas_left);
        make.width.mas_equalTo(200);
    }];
    
    _optionBarView = [[USOptionBarView alloc] init];
    [self.contentView addSubview:_optionBarView];
    [_optionBarView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageLayoutView.mas_bottom).offset(0);
        make.size.mas_equalTo((CGSize){SCREEN_WIDTH, 50});
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    _commentView = [USTimelineCommentView new];
    [self.contentView addSubview:_commentView];
    [_commentView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_optionBarView.mas_bottom).offset(0);
        make.left.mas_equalTo(kLeftMargin);
        make.right.mas_equalTo(-kRightMargin);
        make.height.mas_equalTo(90);
    }];
}

#pragma mark - Update

- (void)updateWithModelLayout:(USTimelineCellLayout *)layout {
    
    [self updateLayout:layout];
    [self updateUI:layout];
}

- (void)updateUI:(USTimelineCellLayout *)layout {
    _contentLabel.textLayout = layout.textLayout;
    
    USUser *fromUser = layout.timelineModel.fromUser;
    NSString *avatar = [HLTool avatarSmallImageUrl:fromUser.avatarStr uid:fromUser.uid];
    _nameLabel.text = fromUser.nickName;
    
    NSString *locationStr = layout.timelineModel.location;
    _locationLabel.text = locationStr.length ? [NSString stringWithFormat:@"地球 中国 %@", locationStr] : @"地球 中国";
    _timeLabel.text = layout.timelineModel.sendTime;
    
    [_iconView setImageWithURL:[NSURL URLWithString:avatar] placeholder:[UIImage imageWithColor:GlobalBGColor]];
    
    [_imageLayoutView removeAllSubviews];
    [_imageLayoutView setupWithTimelineModel:layout.timelineModel];
    
    [_commentView updateWithCommentList:layout.timelineModel.comments];
}

/*! 更新布局 */
- (void)updateLayout:(USTimelineCellLayout *)layout {
    _modelLayout = layout;

    [_nameLabel updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(layout.nickTopMargin);
        make.height.mas_equalTo(layout.nickHeight);
    }];
    
    [_contentLabel updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(layout.contentTextHeight);
    }];
    
    [_imageLayoutView updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(layout.contentImageHeight);
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(layout.contentImageTopBottomMargin);
    }];
    
    [_optionBarView updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(layout.optionBarViewHeight);
    }];
    
    [_commentView updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(layout.commentViewHeight);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_DidClickHideTimelineBottomBar object:nil];
    [KeyWindow endEditing:true];
}

@end
