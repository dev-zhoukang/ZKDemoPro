//
//  USTimelineCell.h
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class USTimelineCellLayout;

@interface USTimelineCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)updateWithModelLayout:(USTimelineCellLayout *)layout;
@end
