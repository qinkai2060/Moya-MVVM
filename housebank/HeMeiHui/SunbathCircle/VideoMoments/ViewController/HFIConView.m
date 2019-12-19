//
//  HFIConView.m
//  HeMeiHui
//
//  Created by usermac on 2019/12/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFIConView.h"
#import "UIView+addGradientLayer.h"
@interface HFIConView()
@property(nonatomic,strong)UIButton *followedBtn;
@property(nonatomic,strong)UIButton *nonefollowBtn;
@property(nonatomic,strong)UIButton *avatarBtn;

@end
@implementation HFIConView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.avatarBtn];
        [self addSubview:self.followedBtn];
        [self addSubview:self.nonefollowBtn];
        self.avatarBtn.frame = CGRectMake(0, 0, 45, 45);
        self.nonefollowBtn.frame = CGRectMake(6, self.avatarBtn.bottom-7, 34, 14);
        self.followedBtn.frame = CGRectMake((self.width-16)*0.5, self.avatarBtn.bottom-8, 16, 16);
        
    }
    return self;
}
- (void)avatarTouch:(UIButton*)btn {
    if ([self.delegate respondsToSelector:@selector(avatarClick:)]) {
        [self.delegate avatarClick:0];
    }
}
- (void)status:(HFIConViewStatus)status avatarUrl:(NSString*)url {
    self.followedBtn.hidden = !(status == HFIConViewStatusFllowed);
    self.nonefollowBtn.hidden = !(status == HFIConViewStatusNoneFllow);
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:@""] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"circle_default"]];
}
- (UIButton *)followedBtn {
    if (!_followedBtn) {
        _followedBtn = [[UIButton alloc] init];
        [_followedBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        _followedBtn.hidden = YES;
    }
    return _followedBtn;
}
- (UIButton *)nonefollowBtn {
    if (!_nonefollowBtn) {
        _nonefollowBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 34, 14)];
        [_nonefollowBtn setTitle:@"+ 关注" forState:UIControlStateNormal];
        [_nonefollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nonefollowBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_nonefollowBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
        [_nonefollowBtn bringSubviewToFront:_nonefollowBtn.titleLabel];
        _nonefollowBtn.layer.cornerRadius = 7;
        _nonefollowBtn.layer.masksToBounds = YES;
        _nonefollowBtn.hidden = YES;
    }
    return _nonefollowBtn;
}

- (UIButton *)avatarBtn {
    if (!_avatarBtn) {
        _avatarBtn = [[UIButton alloc] init];
        [_avatarBtn addTarget:self action:@selector(avatarTouch:) forControlEvents:UIControlEventTouchUpInside];
        _avatarBtn.layer.cornerRadius = 10;
        _avatarBtn.layer.masksToBounds = YES;
        
    }
    return _avatarBtn;
}
@end
