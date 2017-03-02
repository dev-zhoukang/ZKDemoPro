//
//  ZKProfileHeaderCell.m
//  ZKDemoPro
//
//  Created by ZK on 17/3/2.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKProfileHeaderCell.h"

@implementation ZKProfileHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"ZKProfileHeaderCell";
    ZKProfileHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil].lastObject;
    }
    return cell;
}

@end
