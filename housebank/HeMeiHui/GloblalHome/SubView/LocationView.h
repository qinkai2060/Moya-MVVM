//
//  LocationView.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/12.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@protocol LocationViewDelegate <NSObject>
- (void)didUpdateLocations;
@end
@interface LocationView : UIView
@property (nonatomic,weak)id<LocationViewDelegate> delegate;
@property(nonatomic,strong) UILabel *positionLable;
@property(nonatomic,strong)UIView *subView;

@end

NS_ASSUME_NONNULL_END
