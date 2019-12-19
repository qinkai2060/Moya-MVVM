//
//  AdvertisementView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "AdvertisementView.h"
#define middleHeight (kHeight - WScale(120) - WScale(173) - WScale(80))
@interface AdvertisementView ()
{
    NSString * string;
    CGFloat  scrollViewHeight;
}

@property (nonatomic, strong)UIButton * closeBtn;
@property (nonatomic, strong)UIImageView * iconImage;

@end
@implementation AdvertisementView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isOpen = NO;
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.5f];
        
        // 先确定中间定位
        [self addSubview:self.middleImageView];
        self.middleImageView.backgroundColor = [UIColor whiteColor];
        [self.middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.width.equalTo(@(275));
            make.height.equalTo(@(300));
        }];
        
        [self addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@35);
            make.centerX.equalTo(self.middleImageView).offset(0);
            make.bottom.equalTo(self.middleImageView.mas_bottom).offset(55);
        }];
        self.middleImageView.userInteractionEnabled = YES;
        [self bindRAC];
        
    }
    return self;
}

- (void)bindRAC {
    @weakify(self);
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self closeAnimation];
    }];
    
   
}

- (CGFloat)rowHeight:(NSString *)rowOfHeight
{
    CGSize contentSize = CGSizeMake(kWidth-120, 10000);
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:14.0]};
    CGRect rowRect = [rowOfHeight boundingRectWithSize:contentSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return ceil(rowRect.size.height);
}

- (void)popViewAnimation{
    CGFloat halfScreenWidth = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat halfScreenHeight = [[UIScreen mainScreen] bounds].size.height * 0.5;  // 屏幕中心
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    self.center = screenCenter;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity,                                            CGFLOAT_MIN, CGFLOAT_MIN);
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.transform =  CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.transform = CGAffineTransformIdentity;
                                          }];
                     }];
    
}

- (void)closeAnimation {
    self.isOpen=YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark -- lazy load
- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VipPop_middle"]];
    }
    return _middleImageView;
}
- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Vip_gift_down"]];
    }
    return _iconImage;
}


- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"guangGao"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
