//
//  WARProfileHeaderView.h
//  Pods
//
//  Created by huange on 2017/8/3.
//
//

#import <UIKit/UIKit.h>

@protocol WARProfileHeaderViewDelegate <NSObject>

@optional
- (void)clickIconAction;

@end

@class WARLikeView;
@interface WARProfileHeaderView : UIView

@property (nonatomic, strong) UIView *radiusBackView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WARLikeView *likeView;
@property (nonatomic, strong) WARLikeView *fansView;
@property (nonatomic, strong) WARLikeView *arrangeView;
@property (nonatomic, weak) id <WARProfileHeaderViewDelegate> delegate;

@end


@interface WARLikeView : UIView

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;


@end
