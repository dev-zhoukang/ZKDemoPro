//
//  USTimelineCommentView.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/27.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class USComment;

@interface USTimelineCommentView : UIView

+ (CGFloat)calculateHeightWithCommentList:(NSArray <USComment *> *)commentList;

- (void)updateWithCommentList:(NSArray <USComment *> *)commentList;

@end
