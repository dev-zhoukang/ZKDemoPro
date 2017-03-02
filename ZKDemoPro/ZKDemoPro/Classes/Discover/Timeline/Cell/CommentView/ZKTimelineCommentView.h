//
//  ZKTimelineCommentView.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/27.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZKComment;

@interface ZKTimelineCommentView : UIView

+ (CGFloat)calculateHeightWithCommentList:(NSArray <ZKComment *> *)commentList;

- (void)updateWithCommentList:(NSArray <ZKComment *> *)commentList;

@end
