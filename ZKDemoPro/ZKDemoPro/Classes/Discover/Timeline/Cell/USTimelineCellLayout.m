//
//  USTimelineCellLayout.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "USTimelineCellLayout.h"
#import "USTextLinePositionModifier.h"
#import "USRegularTool.h"
#import "USImageLayoutView.h"
#import "USTimelineCommentView.h"

@interface USTimelineCellLayout()

@end

static const CGFloat kDefaultMargin = 10.f;

@implementation USTimelineCellLayout

- (instancetype)initWithTimelineModel:(USTimeline *)model {
    if (!model) return nil;
    self = [super init];
    _timelineModel = model;
    [self layout];
    return self;
}

- (void)layout {
    _totalHeight = 0;
    
    // 昵称高度
    _nickHeight = [self layoutNickLabel];
    _totalHeight += self.nickTopMargin;
    _totalHeight += _nickHeight;
    
    // 文本高度
    _contentTextHeight = [self layoutContentText];
    _totalHeight += _contentTextHeight;
    
    // 图片高度
    _contentImageHeight = [self layoutContentImage];
    _totalHeight += self.contentImageTopBottomMargin;
    _totalHeight += _contentImageHeight;
    _totalHeight += self.contentImageTopBottomMargin;
    
    // 评论 bar 的高度
    _totalHeight += self.optionBarViewHeight;
    
    // 计算评论面板的高度
    _commentViewHeight = [self layoutCommentView];
    _totalHeight += _commentViewHeight;
}

- (CGFloat)layoutCommentView {
    CGFloat height = 0;
    height = [USTimelineCommentView calculateHeightWithCommentList:_timelineModel.comments];
    return height;
}

- (CGFloat)layoutNickLabel {
    return 20;
}

- (CGFloat)layoutContentText {
    CGFloat height = 0;
    
    USTextLinePositionModifier *modifier = [USTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:15];
    modifier.paddingTop = 5;
    modifier.paddingBottom = 5;
    modifier.lineHeightMultiple = 1.25;
    
    NSMutableAttributedString *attributedString = [self matchText:_timelineModel.contentText];
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = (CGSize){[self calculateContentLabelMaxWidth], MAXFLOAT};
    container.maximumNumberOfRows = 0;
    container.linePositionModifier = modifier;
    
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    _textLayout = textLayout;
    height = [modifier heightForLineCount:textLayout.rowCount];
    
    return height;
}

- (CGFloat)layoutContentImage {
    CGFloat height = 0;
    NSString *imageStr = _timelineModel.imageUrls;
    if (!imageStr.length) {
        return 0;
    }
    
    NSArray *imageUrls = [imageStr componentsSeparatedByString:@","];
    CGFloat imageContainerWidth = [self calculateContentLabelMaxWidth];
    NSString *imageSizeStr = nil;
    if (imageUrls.count == 1) {
        imageSizeStr = _timelineModel.imgSize;
    }
    
    height = [USImageLayoutView heightWithImageCount:imageUrls.count
                                                         maxWidth:imageContainerWidth
                                                 singleImgSizeStr:imageSizeStr];
    
    return height;
}

- (NSMutableAttributedString *)matchText:(NSString *)string {
    if (!string) return nil;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    attributedString.font = [UIFont systemFontOfSize:15];
    attributedString.color = HexColor(0x535353);
    return [USRegularTool matchAttributedText:attributedString];
}

- (CGFloat)calculateContentLabelMaxWidth {
                       // 头像的宽度加间距  右间距
    return (SCREEN_WIDTH - (10 * 2 + 50) - 40);
}

- (CGFloat)optionBarViewHeight {
    return 50.f;
}

- (CGFloat)nickTopMargin {
    return kDefaultMargin;
}

- (CGFloat)contentImageTopBottomMargin {
    return kDefaultMargin * 1.2;
}

@end
