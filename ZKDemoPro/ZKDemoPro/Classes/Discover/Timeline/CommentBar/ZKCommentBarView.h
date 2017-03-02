//
//  ZKCommentBarView.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/24.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZKCommentBarView : UIView

@property (nonatomic, assign, readonly) CGFloat keyboard_y;

+ (void)show;

@end

extern const CGFloat kBottomPanelDefaultHeight;
