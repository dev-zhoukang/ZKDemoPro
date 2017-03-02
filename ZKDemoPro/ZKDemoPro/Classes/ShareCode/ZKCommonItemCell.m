//
//  ZKCommonItemCell.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKCommonItemCell.h"

@interface ZKCommonItemCell()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation ZKCommonItemCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellIdentify = @"ZKCommonItemCell";
    ZKCommonItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[ZKCommonItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
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
    [_iconView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(60);
    }];
    _iconView.contentMode = UIViewContentModeCenter;
    _iconView.image = [UIImage imageNamed:@"MoreGame"];
    
    _titleLabel = [UILabel new];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    _titleLabel.text = @"更多游戏";
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconView.mas_right).offset(-5);
        make.right.mas_equalTo(-30);
        make.top.bottom.mas_equalTo(0);
    }];
    
    _arrowView = [UIImageView new];
    [self.contentView addSubview:_arrowView];
    _arrowView.image = [UIImage imageNamed:@"HeadImageReadNodeViewRightArrow_8x12_"];
    _arrowView.contentMode = UIViewContentModeCenter;
    [_arrowView makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(40);
    }];
}

- (void)updateWithDict:(NSDictionary *)dict {
    _titleLabel.text = dict[@"title"];
    _iconView.image = [UIImage imageNamed:dict[@"icon"]];
}

@end
