//
//  HMLiveRecommendBannerCell.m
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMLiveRecommendBannerCell.h"
#import <SDCycleScrollView/SDCycleScrollView.h>

@interface HMLiveRecommendBannerCell()<SDCycleScrollViewDelegate>

@property (nonatomic,strong)SDCycleScrollView *cycleView;

@property (nonatomic,strong)NSMutableArray<NSString *> *urlArray;

@end

@implementation HMLiveRecommendBannerCell



- (void)setSubviews {
    
    self.urlArray = [NSMutableArray array];
    
    self.cycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:self placeholderImage:ImageLive(@"SpTypes_default_image")];
    [self.contentView addSubview:self.cycleView];
  //  self.cycleView.imageURLStringsGroup = @[@" ",@" ",@" ",@" ",@" "];
    self.cycleView.currentPageDotColor = [UIColor colorWithHexString:@"#F3344A"];
    self.cycleView.pageDotColor = [UIColor colorWithHexString:@"#CCCCCC"];
    self.cycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
        make.height.mas_equalTo(WScale(125));
    }];
    
    
}

- (void)setModelArray:(NSArray<HMHLivereCommendModel *> *)modelArray {
    [super setModelArray:modelArray];
    [self.urlArray removeAllObjects];
    for (int i = 0 ; i < modelArray.count; i++) {
        if (modelArray[i].imagePath) {
            [self.urlArray addObject:imageURL(modelArray[i].imagePath)];
        }
    }
    self.cycleView.imageURLStringsGroup = self.urlArray;
}



#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    [self sendNotificationName:HMHliveCellTapNotification Object:self.modelArray[index]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
