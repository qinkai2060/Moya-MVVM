//
//  HFNavBarTitleView.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFNavBarTitleView : HFView
@property(nonatomic,strong)UIButton *cityBtn;
@property(nonatomic,strong)CALayer *lineLayer1;
@property(nonatomic,strong)UILabel *datelb;
@property(nonatomic,strong)UIButton *dateBtn;
@property(nonatomic,strong)CALayer *lineLayer2;
@property(nonatomic,strong)UIButton *searchBtn;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *keyLb;
@property(nonatomic,strong)UIButton *clearBtn;
- (void)cityName:(NSString*)cityName date:(NSString*)date keyWord:(NSString*)keyWord;
@end

NS_ASSUME_NONNULL_END
