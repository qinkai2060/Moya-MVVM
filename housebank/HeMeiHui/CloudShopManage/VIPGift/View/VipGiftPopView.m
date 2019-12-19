
//
//  VipGiftPopView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftPopView.h"
#import "VipCenterViewController.h"
#define middleHeight (kHeight - WScale(120) - WScale(173) - WScale(80))
@interface VipGiftPopView ()
{
    NSString * string;
    CGFloat  scrollViewHeight;
}
@property (nonatomic, strong)UIImageView * middleImageView;
@property (nonatomic, strong)UIButton * moreBtn;
@property (nonatomic, strong)UIButton * sureBtn;
@property (nonatomic, strong)UIButton * thinkBtn; // 在想想
@property (nonatomic, strong)UIButton * closeBtn;
@property (nonatomic, strong)UIImageView * iconImage;
@property (nonatomic, assign)BOOL isOpen;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UILabel * scrollViewLabel;
@end
@implementation VipGiftPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.isOpen = NO;
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.7f];
        
        // 先确定中间定位
        [self addSubview:self.middleImageView];
        [self.middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.equalTo(self).offset(20);
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@(1));
        }];
        
        UIImageView * headImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VipPop_head"]];
        [self addSubview:headImageView];
        [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.middleImageView);
            make.bottom.equalTo(self.middleImageView.mas_top);
            make.height.equalTo(@(WScale(120)));
        }];
        
        UIImageView * footImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"VipPop_footer"]];
        [self addSubview:footImageView];
        [footImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.middleImageView);
            make.top.equalTo(self.middleImageView.mas_bottom);
            make.height.equalTo(@(WScale(173)));
        }];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.text = @"恭喜您获得";
        titleLabel.font = kFONT_BOLD(14);
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFE8AC"];
        [headImageView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headImageView);
            make.top.equalTo(headImageView).offset((WScale(52)));
            make.height.equalTo(@(WScale(20)));
        }];

        [headImageView addSubview:self.memberLabel];
        [self.memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(headImageView);
            make.top.equalTo(titleLabel.mas_bottom).offset(5);
            make.height.equalTo(@(WScale(40)));
        }];
        
        [headImageView addSubview:self.closeBtn];
        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.right.equalTo(headImageView).offset(25);
            make.top.equalTo(headImageView).offset(-25);
        }];
        
        [footImageView addSubview:self.moreBtn];
        [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footImageView);
            make.top.equalTo(footImageView).offset(2);
            make.height.equalTo(@(WScale(20)));
            make.width.equalTo(@60);
        }];
        
        [footImageView addSubview:self.iconImage];
        [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.moreBtn);
            make.left.equalTo(self.moreBtn.mas_right).offset(5);
            make.width.height.equalTo(@10);
        }];
        
        [footImageView addSubview:self.sureBtn];
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footImageView);
            make.top.equalTo(self.moreBtn.mas_bottom).offset(30);
            make.width.equalTo(@(kWidth - 110));
            make.height.equalTo(@(WScale(50)));
        }];
        
        [footImageView addSubview:self.thinkBtn];
        [self.thinkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(footImageView);
            make.width.equalTo(@100);
            make.height.equalTo(@(WScale(20)));
            make.bottom.equalTo(footImageView).offset(-(WScale(40)));
        }];
        
        footImageView.userInteractionEnabled = YES;
        headImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]init];
        [headImageView addGestureRecognizer:tap];
//        @weakify(self);
//        [[tap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
//            @strongify(self);
//            [self closeAnimation];
//        }];
        
        [self bindRAC];
        
    }
    return self;
}

- (void)bindRAC {
    @weakify(self);
    [[self.moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        } completion:^(BOOL finished) {
            @strongify(self);
            self.isOpen = !self.isOpen;
            [self changeStatus:self.isOpen];
        }];
    }];
    
    [[self.thinkBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self closeAnimation];
    }];
    
    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self closeAnimation];
         [[NSNotificationCenter  defaultCenter] postNotificationName:@"closeVIPPG" object:nil];
    }];
    
    [[self loadRequest_VipAlert] subscribeNext:^(NSString * x) {
        if (x.length > 0) {
            @strongify(self);
            string = x;
            // 计算scrollview滑动
            scrollViewHeight = [self rowHeight:string];
            CGFloat nowHeight = scrollViewHeight+15<middleHeight?scrollViewHeight+15:middleHeight;
            self.scrollView.contentSize = CGSizeMake(kWidth - 120, scrollViewHeight);
            [self.middleImageView addSubview:self.scrollView];
            self.scrollView.hidden = YES;
            [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.middleImageView);
                make.left.equalTo(self.middleImageView).offset(40);
                make.right.equalTo(self.middleImageView).offset(-40);
                make.height.equalTo(@(nowHeight));
            }];
            
            [self.scrollView addSubview:self.scrollViewLabel];
            self.scrollViewLabel.text = string;
            self.scrollViewLabel.frame = CGRectMake(0, 0, kWidth-120, nowHeight);
        }
    }];
    
    [[self.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self closeAnimation];
        VipCenterViewController * vipCenterVc = [[VipCenterViewController alloc]init];
        vipCenterVc.hidesBottomBarWhenPushed = YES;
        [[UIViewController visibleViewController].navigationController pushViewController:vipCenterVc animated:YES];
    }];
}

- (RACSignal *)loadRequest_VipAlert {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sidStr = [NSString stringWithFormat:@"%@",[ud objectForKey:@"sid"]];
    RACSubject * subject = [RACSubject subject];
   NSString * utrl = [[NetWorkManager shareManager] getForKey:@"common./user/vip/upgrade-rule-desc/find"];
    [HFCarRequest requsetUrl:[NSString stringWithFormat:@"%@?sid=%@",utrl,sidStr] withRequstType:YTKRequestMethodGET requestSerializerType:YTKRequestSerializerTypeJSON params:@{} success:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary * jsonDic = request.responseJSONObject ;
            if ([[jsonDic objectForKey:@"state"] isEqual:@1]) {
                NSDictionary * dataDic = [jsonDic objectForKey:@"data"];
                if ([dataDic.allKeys containsObject:@"upgradeDesc"]) {
                    NSString * upgradeDesc = [dataDic objectForKey:@"upgradeDesc"];
                    [subject sendNext:upgradeDesc];
                }
            }else{
                NSString * errorString = ([jsonDic.allKeys containsObject:@"msg"]) ? [jsonDic objectForKey:@"msg"] :@"网络状况不好,加载失败!";
                NSError *error = [NSError errorWithDomain:@"manage.code" code:0 userInfo:@{@"error":errorString}];
                [subject sendError:error];
            }
        }
    } error:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = [NSError errorWithDomain:@"VIP.code" code:0 userInfo:@{@"error":@"网络状况不好,加载失败!"}];
        [subject sendError:error];
    }];
    return subject;
}

- (void)changeStatus:(BOOL)isOpen {
    [UIView animateWithDuration:0.5 animations:^{
        if (isOpen == YES) {
            [self.middleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(scrollViewHeight+15<middleHeight?scrollViewHeight+15:middleHeight));
            }];
            self.iconImage.image = [UIImage imageNamed:@"Vip_gift_pop"];
            self.scrollView.hidden = NO;
        }else {
            [self.middleImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(1));
            }];
            self.iconImage.image = [UIImage imageNamed:@"Vip_gift_down"];
            self.scrollView.hidden = YES;
        }
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

- (UILabel *)memberLabel {
    if (!_memberLabel) {
        _memberLabel = [UILabel new];
        _memberLabel.text = @"XXX会员资格";
        _memberLabel.font = kFONT_BOLD(28);
        _memberLabel.textColor = [UIColor colorWithHexString:@"#FFE8AC"];
    }
    return _memberLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setTitle:@"了解更多" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor colorWithHexString:@"#FEECBB"] forState:UIControlStateNormal];
        _moreBtn.titleLabel.font = kFONT(14);
    }
    return _moreBtn;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Vip_gift_down"]];
    }
    return _iconImage;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"立即领取" forState:UIControlStateNormal];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"#FEECBB"];
        [_sureBtn setTitleColor:[UIColor colorWithHexString:@"#000000"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = kFONT(16);
        _sureBtn.layer.masksToBounds = YES;
        _sureBtn.layer.cornerRadius = 5;
    }
    return _sureBtn;
}

- (UIButton *)thinkBtn {
    if (!_thinkBtn) {
        _thinkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thinkBtn setTitle:@"再想想" forState:UIControlStateNormal];
        [_thinkBtn setTitleColor:[UIColor colorWithHexString:@"#FEECBB"] forState:UIControlStateNormal];
        _thinkBtn.titleLabel.font = kFONT(14);
    }
    return _thinkBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"Vip_close"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (UILabel *)scrollViewLabel {
    if (!_scrollViewLabel) {
        _scrollViewLabel = [UILabel new];
        _scrollViewLabel.font = kFONT(14);
        _scrollViewLabel.textAlignment = NSTextAlignmentLeft;
        _scrollViewLabel.textColor = [UIColor colorWithHexString:@"#FEECBB"];
        _scrollViewLabel.numberOfLines = 0;
    }
    return _scrollViewLabel;
}
@end
