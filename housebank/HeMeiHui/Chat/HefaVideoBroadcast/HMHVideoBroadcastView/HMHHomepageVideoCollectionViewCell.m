//
//  HMHHomepageVideoCollectionViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHHomepageVideoCollectionViewCell.h"

@interface HMHHomepageVideoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *HMH_imageView;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_lookNumLab;
@property (nonatomic, strong) UILabel *HMH_topLab;

@end

@implementation HMHHomepageVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 40)];
    self.HMH_imageView.layer.masksToBounds = YES;
    self.HMH_imageView.layer.cornerRadius = 7.0;
    self.HMH_imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.HMH_imageView];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_imageView.frame.origin.x, CGRectGetMaxY(self.HMH_imageView.frame), self.HMH_imageView.frame.size.width, 25)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_titleLab.textColor = RGBACOLOR(104, 105, 106, 1);
    [self.contentView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_lookNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame), self.HMH_titleLab.frame.size.width, 15)];
    self.HMH_lookNumLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_lookNumLab.textColor = RGBACOLOR(131, 132, 133, 1);
    [self.contentView addSubview:self.HMH_lookNumLab];
    
    // 置顶
    self.HMH_topLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 25, 15)];
    self.HMH_topLab.backgroundColor = [UIColor redColor];
    self.HMH_topLab.textColor = [UIColor whiteColor];
    self.HMH_topLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_topLab.font = [UIFont systemFontOfSize:10.0];
    [self.contentView addSubview:self.HMH_topLab];
}
// 视频首页
- (void)refreshViewWithModel:(HMHVideoHomeGriditemModel *)model{
    self.HMH_imageView.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    
    [self.HMH_imageView sd_setImageWithURL:[model.imagePath get_Image]];

    self.HMH_titleLab.text =model.text;
    NSString *hitsStr;
    if ([model.hits integerValue] > 10000) {
        float hitsF = [model.hits floatValue] / 10000.0;
        hitsStr = [NSString stringWithFormat:@"%.1f万人观看",hitsF];
    } else {
       int hitsI = [model.hits intValue];
        hitsStr = [NSString stringWithFormat:@"%d人观看",hitsI];
    }
    self.HMH_lookNumLab.text = hitsStr;
    if (model.tagType.length > 0) {
        self.HMH_topLab.hidden = NO;
        self.HMH_topLab.text = model.tagType;
    } else{
        self.HMH_topLab.hidden = YES;
    }
}
//更多精彩
- (void)moreWonderfullWithModel:(HMHVideoListModel *)model{
    self.HMH_imageView.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    
    [self.HMH_imageView sd_setImageWithURL:[model.coverImageUrl get_Image]];
    
    

    self.HMH_titleLab.text =model.title;
    NSString *hitsStr;
    if ([model.hits integerValue] > 10000) {
        float hitsF = [model.hits floatValue] / 10000.0;
        hitsStr = [NSString stringWithFormat:@"%.1f万人观看",hitsF];
    } else {
        int hitsI = [model.hits intValue];
        hitsStr = [NSString stringWithFormat:@"%d人观看",hitsI];
    }
    self.HMH_lookNumLab.text = hitsStr;
    if ([model.top isEqualToNumber:@1]) {
        self.HMH_topLab.hidden = NO;
        self.HMH_topLab.text = @"置顶";
    } else{
        self.HMH_topLab.hidden = YES;
    }

}

@end
