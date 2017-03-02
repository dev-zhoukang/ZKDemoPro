//
//  ZKTimelineCommentCellLayout.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/28.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKTimelineCommentCellLayout.h"
#import "USTextLinePositionModifier.h"
#import "ZKRegularTool.h"

@interface ZKTimelineCommentCellLayout()

@property (nonatomic, strong) ZKComment *comment;

@end

#define CommentFont      [UIFont systemFontOfSize:13.5]
#define CommonTextColor  HexColor(0x848489)

@implementation ZKTimelineCommentCellLayout

- (instancetype)initWithComment:(ZKComment *)comment {
    if (!comment) return nil;
    self = [super init];
    _comment = comment;
    [self layoutHeight];
    return self;
}

- (void)layoutHeight {
    _totalHeight = 0;
    _totalHeight += [self layoutTextHeight];
    _totalHeight += 6;
}

- (CGFloat)layoutTextHeight {
    USTextLinePositionModifier *modifier = [USTextLinePositionModifier new];
    modifier.font = [UIFont systemFontOfSize:14];
    modifier.paddingTop = 0;
    modifier.paddingBottom = 0;
    modifier.lineHeightMultiple = 1.3;
    
    YYTextContainer *container = [YYTextContainer new];
    container.maximumNumberOfRows = 0;
    container.size = (CGSize){[self calculateWidth], MAXFLOAT};
    container.linePositionModifier = modifier;
    
    NSMutableAttributedString *attributedString = [self matchCommentLabelWithString:_comment.content];
    
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:container text:attributedString];
    _textLayout = textLayout;
    CGFloat textHeight = [modifier heightForLineCount:textLayout.rowCount];
    return textHeight;
}

- (CGFloat)calculateWidth {
    return (SCREEN_WIDTH - 70 - 15 - 16);
}

- (NSMutableAttributedString *)matchText:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    attributedString.font = CommentFont;
    attributedString = [ZKRegularTool matchAttributedText:attributedString highlightColor:nil];
    
    return attributedString;
}

- (NSMutableAttributedString *)matchCommentLabelWithString:(NSString *)commentString
{
    if (!commentString) return nil;
    
    NSString *nick_from = _comment.fromNick?:@"";
    NSString *nick_to = _comment.toNick?:@"";
    
    YYTextBorder *highlightBorder = [[YYTextBorder alloc] init];
    highlightBorder.insets = UIEdgeInsetsMake(-3.f, 0, -3.f, 0);
    highlightBorder.cornerRadius = 3.f;
    highlightBorder.fillColor = HexColor(0xbfdffe);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:commentString];
    attributedString.font = CommentFont;
    [attributedString setColor:CommonTextColor range:attributedString.rangeOfAll];
    
    NSRange symbolRange = [attributedString.string rangeOfString:@": "];
    NSRange sendFlowerRange = [attributedString.string rangeOfString:@" 送给 "];
    
    if (symbolRange.location != NSNotFound) {
        NSString *prefixString = [attributedString.string substringToIndex:symbolRange.location];
        [attributedString setColor:ThemColor range:[attributedString.string rangeOfString:prefixString]];
        [attributedString setColor:CommonTextColor range:[attributedString.string rangeOfString:@"回复"]];
    }
    else if ([_comment.content isEqualToString:@"/flower/"] && sendFlowerRange.location != NSNotFound) {
        NSString *prefixString = [attributedString.string substringToIndex:nick_from.length+nick_to.length+sendFlowerRange.length];
        [attributedString setColor:ThemColor range:[attributedString.string rangeOfString:prefixString]];
        [attributedString setColor:CommonTextColor range:sendFlowerRange];
    }
    
    YYTextHighlight *highlight_from = [YYTextHighlight new];
    [highlight_from setBackgroundBorder:highlightBorder];
    highlight_from.userInfo = @{kLinkNameKey_from: nick_from};
    
    YYTextHighlight *highlight_to = [YYTextHighlight new];
    [highlight_to setBackgroundBorder:highlightBorder];
    highlight_to.userInfo = @{kLinkNameKey_to: nick_to};
    
    [attributedString setTextHighlight:highlight_from range:[attributedString.string rangeOfString:nick_from]];
    [attributedString setTextHighlight:highlight_to range:[attributedString.string rangeOfString:nick_to]];
    
    attributedString = [ZKRegularTool matchAttributedText:attributedString];
    
    return attributedString;
}

@end

// ===

NSString *const kLinkNameKey_from  = @"kLinkNameKey_from";
NSString *const kLinkNameKey_to = @"kLinkNameKey_to";
const CGFloat kCommentLineSpacing = 3.f;
