//
//  HMHCoursewareAndRedpacketView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/12.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHCoursewareAndRedpacketView.h"

@implementation HMHCoursewareAndRedpacketView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    self.backgroundColor = [UIColor clearColor];
    //
    _HMH_redPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_redPacketBtn.frame = CGRectMake(0, 60, 60, 60);
    [_HMH_redPacketBtn setImage:[UIImage imageNamed:@"Video_redPacket"] forState:UIControlStateNormal];
    [_HMH_redPacketBtn addTarget:self action:@selector(redPacketBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _HMH_redPacketBtn.hidden = YES;
    _HMH_redPacketBtn.userInteractionEnabled = YES;
    [self addSubview:_HMH_redPacketBtn];
    
    //    coursewareAddr
    _HMH_pptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_pptBtn.frame = CGRectMake(0,120, 60, 60);
    [_HMH_pptBtn setImage:[UIImage imageNamed:@"VL_keJian"] forState:UIControlStateNormal];
    [_HMH_pptBtn addTarget:self action:@selector(pptBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _HMH_pptBtn.hidden = YES;
    _HMH_pptBtn.userInteractionEnabled = YES;
    [self addSubview:_HMH_pptBtn];
    //
    _HMH_addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_addBtn.frame = CGRectMake(_HMH_pptBtn.frame.origin.x, _HMH_pptBtn.frame.origin.y, _HMH_pptBtn.frame.size.width, _HMH_pptBtn.frame.size.height);
    [_HMH_addBtn setImage:[UIImage imageNamed:@"VL_addImage"] forState:UIControlStateNormal];
    [_HMH_addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _HMH_addBtn.hidden = YES;
    _HMH_addBtn.userInteractionEnabled = YES;
    [self addSubview:_HMH_addBtn];
}

- (void)refreshUIWithCoursewareUrlArr:(NSMutableArray *)courseArr isFromTimeShift:(BOOL)isFromTimeShift redPacketWithModel:(HMHVideoRedPacketModel *)redModel{
    // 是否来自直播
    if (isFromTimeShift) {
        //如果hasRedPacket为turn 并且rpid > 0  则显示红包 否则隐藏
        self.HMH_redPacketBtn.hidden = YES;
        if (redModel) { // 当前是否有红包
            if ([redModel.hasRedPacket boolValue] && [redModel.rpId longLongValue] > 0) {
                    self.HMH_redPacketBtn.hidden = NO;
            }
        }
    } else {
        self.HMH_redPacketBtn.hidden = YES;
    }
    // 是否显示或隐藏课件
    if (courseArr.count > 0) {
        _HMH_addBtn.hidden = NO;
        _HMH_pptBtn.hidden = NO;
        self.hidden=NO;
    } else {
        _HMH_addBtn.hidden = YES;
        _HMH_pptBtn.hidden = YES;
          self.hidden=YES;
    }
    
    
    if (_HMH_addBtn.hidden && _HMH_pptBtn.hidden) {
        [_HMH_addBtn removeFromSuperview];
        [_HMH_pptBtn removeFromSuperview];
    }
}

// 课件加号
- (void)addBtnClick:(UIButton *)btn{
    [UIView animateWithDuration:0.2 animations:^{
        if (btn.selected) {
            CGRect rect = _HMH_pptBtn.frame;
            rect.origin.y = 120;
            _HMH_pptBtn.frame = rect;
            
            CGRect redRect = _HMH_redPacketBtn.frame;
            redRect.origin.y = 60;
            _HMH_redPacketBtn.frame = redRect;
            
            btn.selected = NO;
            
        } else {
            CGRect rect = _HMH_pptBtn.frame;
            rect.origin.y = 60;
            _HMH_pptBtn.frame = rect;
            
            CGRect redRect = _HMH_redPacketBtn.frame;
            redRect.origin.y = 0;
            _HMH_redPacketBtn.frame = redRect;

            btn.selected = YES;
        }
    }];
}
// 课件按钮的点击事件
- (void)pptBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(pptBtnClickWithBtn:)]) {
        [self.delegate pptBtnClickWithBtn:btn];
    }
}
// 红包按钮的点击事件
- (void)redPacketBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(redPacketBtnClickWithBtn:)]) {
        [self.delegate redPacketBtnClickWithBtn:btn];
    }
}

@end
