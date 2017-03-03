//
//  ZKImageLayoutView.m
//  ZKDemoPlus
//
//  Created by ZK on 17/2/21.
//  Copyright © 2017年 ZK. All rights reserved.
//

#import "ZKImageLayoutView.h"
#import "ZKPhotoBrowser.h"
#import "ZKTimeline.h"

@interface ZKImageLayoutView()

@property (nonatomic, copy) NSArray <NSString *> *imageUrls;

@end

static const CGFloat kPicMargin = 5.f;
static CGFloat viewMaxWidth_;
static const NSUInteger kMaxColCountPerRow = 3;

@implementation ZKImageLayoutView

+ (CGFloat)heightWithImageCount:(NSUInteger)imageCount maxWidth:(CGFloat)maxWidth singleImgSizeStr:(NSString *)imgSizeStr {
    
    viewMaxWidth_ = maxWidth;
    
    if (imageCount == 1) { // 单个图片单独处理
        CGSize finalSize = [self calculateSingleSizeWithImageSizeStr:imgSizeStr];
        return finalSize.height;
    }
    
    NSUInteger rowCount = (int)(imageCount + kMaxColCountPerRow - 1) / kMaxColCountPerRow;
    CGFloat picWH = (maxWidth - (kMaxColCountPerRow - 1) * kPicMargin) / kMaxColCountPerRow;
    
    CGFloat imageLayoutHeight = rowCount * picWH + (rowCount - 1) * kPicMargin;
    
    return imageLayoutHeight;
}

+ (CGSize)calculateSingleSizeWithImageSizeStr:(NSString *)imgSizeStr {
    
    if (!imgSizeStr.length) {
        return (CGSize){160, 160};
    }
    
    NSArray *sizeArray = [imgSizeStr componentsSeparatedByString:@"x"];
    CGSize oriSize = (CGSize){[sizeArray[0] floatValue], [sizeArray[1] floatValue]};
    
    CGFloat singleMaxWidth = SCREEN_WIDTH * .6;
    CGFloat singleMaxHeight = SCREEN_WIDTH * .7;
    
    CGFloat finalHeight, finalWidth;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat oriHeight = oriSize.height / scale;
    CGFloat oriWidth = oriSize.width / scale;
    
    if (oriHeight > oriWidth) { // 如果是高大于宽
        finalHeight = oriHeight > singleMaxHeight ? singleMaxHeight : oriHeight;
        finalWidth = finalHeight / oriHeight * oriWidth;
    }
    else {
        finalWidth = oriWidth > singleMaxWidth ? singleMaxWidth : oriWidth;
        finalHeight = finalWidth / oriWidth * oriHeight;
    }
    return (CGSize){finalWidth, finalHeight};
}

- (void)setupWithTimelineModel:(ZKTimeline *)timelineModel {
    NSString *imageUrlStr = timelineModel.imageUrls;
    
    NSArray *imageUrlArray = [imageUrlStr componentsSeparatedByString:@","];
    _imageUrls = imageUrlArray.copy;
    
    NSUInteger imageCount = imageUrlArray.count;
    
    CGFloat picWH = (viewMaxWidth_ - (kMaxColCountPerRow - 1) * kPicMargin) / kMaxColCountPerRow;
    CGFloat widthWithMargin = picWH + kPicMargin;
    
    for (int i = 0; i < imageCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = GlobalBGColor;
        
        imageView.size = (imageCount == 1) ? [[self class] calculateSingleSizeWithImageSizeStr:timelineModel.imgSize] : (CGSize){picWH, picWH};

        imageView.us_top = i / kMaxColCountPerRow * widthWithMargin;
        imageView.us_left = i % kMaxColCountPerRow * widthWithMargin;
        
//        NSString *thumbUrlStr = [imageUrlArray[i] fullThumbImageURLWithMinPixel:150];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr] placeholderImage:[UIImage imageWithColor:GlobalBGColor]];
        
        imageView.tag = i;
        imageView.userInteractionEnabled = true;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
    }
}

- (void)tapImage:(UITapGestureRecognizer *)tap {
    
    ZKPhotoBrowser *browser = [[ZKPhotoBrowser alloc] initWithImageUrls:_imageUrls
                                                      currentPhotoIndex:tap.view.tag
                                                        sourceSuperView:self];
    [browser show];
}

@end
