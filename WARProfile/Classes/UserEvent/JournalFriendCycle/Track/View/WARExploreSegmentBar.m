//
//  WARActivateSegmentBar.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARExploreSegmentBar.h"

#import "WARMacros.h"
#import "Masonry.h"

#import "UIImage+WARBundleImage.h"
#import "UIImage+Color.h"

@interface WARExploreSegmentBar()
@property (nonatomic, strong) WARExploreItemView *mineItemView;
@property (nonatomic, strong) WARExploreItemView *activateItemView;
@end

@implementation WARExploreSegmentBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mineItemView];
        [self addSubview:self.activateItemView];
        
        [self.mineItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth*0.5);
            make.height.mas_equalTo(34);
        }];
        [self.activateItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth*0.5);
            make.height.mas_equalTo(34);
        }];
        
        __weak typeof(self) weakSelf = self;
        self.mineItemView.didBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.didBlock(0);
            strongSelf.activateItemView.eventButton.selected = YES;
            strongSelf.mineItemView.eventButton.selected = NO;
        };
        
        self.activateItemView.didBlock = ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.didBlock(1);
            strongSelf.activateItemView.eventButton.selected = NO;
            strongSelf.mineItemView.eventButton.selected = YES;
        };
        
        /// 默认选择自己探索
    }
    return self;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == 0) {
        
    } else {
        
    }
}

- (WARExploreItemView *)mineItemView {
    if (!_mineItemView) {
        _mineItemView = [[WARExploreItemView alloc]init];
        _mineItemView.eventButton.selected = YES;
        [_mineItemView configTitle:@"自己探索" number:@"999+"];
    }
    return _mineItemView;
}

- (WARExploreItemView *)activateItemView {
    if (!_activateItemView) {
        _activateItemView = [[WARExploreItemView alloc]init];
        
        [_activateItemView configTitle:@"激活探索" number:@"999+"];
    }
    return _activateItemView;
}

@end

#pragma mark - WARExploreItemView

@interface WARExploreItemView()
/** titleLable */
@property (nonatomic, strong) UILabel *titleLable;
/** iconView */
@property (nonatomic, strong) UIImageView *iconView;
/** numberLable */
@property (nonatomic, strong) UILabel *numberLable;
@end

@implementation WARExploreItemView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.eventButton];
        [self addSubview:self.titleLable];
        [self addSubview:self.iconView];
        [self addSubview:self.numberLable];
        
        [self.eventButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (void)eventAction:(UIButton *)button {
    if (self.didBlock) {
        self.didBlock();
    }
}

- (void)configTitle:(NSString *)title number:(NSString *)number {
    self.titleLable.text = title;
    self.iconView.image = [UIImage war_imageName:@"map_foot_explore_icon" curClass:[self class] curBundle:@"WARProfile.bundle"];
    self.numberLable.text = number;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]init];
        _titleLable.frame = CGRectMake(AdaptedWidth(43), 0, 60, 34);
        _titleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _titleLable.numberOfLines = 1;
        _titleLable.textAlignment = NSTextAlignmentCenter;
        _titleLable.textColor = HEXCOLOR(0x8D93A4);
    }
    return _titleLable;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.frame = CGRectMake(AdaptedWidth(106), 12.5, 13, 13);
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)numberLable {
    if (!_numberLable) {
        _numberLable = [[UILabel alloc]init];
        _numberLable.frame = CGRectMake(AdaptedWidth(120), 15, 60, 10);
        _numberLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        _numberLable.numberOfLines = 1;
        _numberLable.textAlignment = NSTextAlignmentLeft;
        _numberLable.textColor = HEXCOLOR(0xADB1BE);
    }
    return _numberLable;
}


- (UIButton *)eventButton {
    if (!_eventButton) {
        _eventButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_eventButton addTarget:self action:@selector(eventAction:) forControlEvents:UIControlEventTouchUpInside];
        [_eventButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF6F6F6)] forState:UIControlStateNormal];
        [_eventButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateSelected];
        _eventButton.adjustsImageWhenHighlighted = NO;
    }
    return _eventButton;
}


@end
