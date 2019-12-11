//
//  WARImageButton.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/19.
//

#import "WARImageButton.h"
#import "Masonry.h"
#import "WARMacros.h"

#define TIPLABEL_MARGIN_INSET 2

@interface WARImageButton()

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation WARImageButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = NO;
        
        [self addSubview:self.iconView];
        [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return self;
}

- (UIImageView *)iconView {
    if(!_iconView){
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.hidden = YES;
        
        [self addSubview:tipLabel];
        _tipLabel = tipLabel;
    }
    return _tipLabel;
}

- (void)setBadgeValue:(NSUInteger)badgeValue{
    _badgeValue = badgeValue;
    self.tipLabel.hidden = badgeValue<=0;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (!self.tipLabel.hidden) {
        [self makeNumBadge];
    } 
    
}

- (void)makeNumBadge {
    NSString *tipStr = (self.badgeValue>999)?@"···":[NSString stringWithFormat:@"%zd",self.badgeValue];
    CGSize tipLabelStrSize = [tipStr sizeWithAttributes:@{NSFontAttributeName:self.tipLabel.font}];
    CGFloat tipLabelStrH = tipLabelStrSize.height;
    CGFloat tipLabelStrW = tipLabelStrSize.width + 2;
    
    tipLabelStrW = tipLabelStrW>tipLabelStrH?(tipLabelStrW+2*TIPLABEL_MARGIN_INSET):tipLabelStrH;
    
    int tipLabelH = 13;
    int tipLabelW = tipLabelStrW <= 13 ? 13 : tipLabelStrW;
    int tipLabelX = (int)(CGRectGetMaxX(self.iconView.frame) - 12);
    int tipLabelY = (int)(CGRectGetMinY(self.iconView.frame) - 1);
    
    self.tipLabel.frame = CGRectMake(tipLabelX, tipLabelY, tipLabelW, tipLabelH);
    self.tipLabel.text = (self.badgeValue>999)?@"···":[NSString stringWithFormat:@"%zd",self.badgeValue];
    
    CALayer *layer = self.tipLabel.layer;
    layer.cornerRadius = tipLabelH*0.5;
    layer.backgroundColor = HEXCOLOR(0xF2604D).CGColor;
}


@end
