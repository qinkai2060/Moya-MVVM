//
//  HMHVideoPreviewTopView.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoPreviewTopView.h"



@interface HMHVideoPreviewTopView ()

@property (nonatomic, strong) UIImageView *HMH_bgImage;
@property (nonatomic, strong) UIButton *HMH_backBtn;
@property (nonatomic, strong) UIButton *HMH_shareBtn;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_subTitleLab;
@property (nonatomic, strong) UILabel *HMH_timeLab;
@property (nonatomic, strong) UIButton *HMH_lookBtn;

@end

@implementation HMHVideoPreviewTopView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.frame.size.height)];
    self.HMH_bgImage.userInteractionEnabled = YES;
    self.HMH_bgImage.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    [self addSubview:self.HMH_bgImage];
    
    //
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.HMH_bgImage.frame.size.height)];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.7;
    [self.HMH_bgImage addSubview:blackView];
    
    //
    self.HMH_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_backBtn.frame = CGRectMake(0, 5, 44, 44);
    [self.HMH_backBtn setImage:[UIImage imageNamed:@"VP_whiteBackImage"] forState:UIControlStateNormal];
    [self.HMH_backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_bgImage addSubview:self.HMH_backBtn];
    
    
    //
    self.HMH_shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_shareBtn.frame = CGRectMake(self.HMH_bgImage.frame.size.width - 10 - 44, self.HMH_backBtn.frame.origin.y, 44, 44);
    [self.HMH_shareBtn setImage:[UIImage imageNamed:@"VL_ShareImage"] forState:UIControlStateNormal];
    [self.HMH_shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_bgImage addSubview:self.HMH_shareBtn];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.HMH_backBtn.frame) - 10, self.HMH_bgImage.frame.size.width - 10, 45)];
    self.HMH_titleLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_titleLab.textColor = [UIColor whiteColor];
    self.HMH_titleLab.numberOfLines = 0;
    self.HMH_titleLab.font = [UIFont boldSystemFontOfSize:17.0];
    [self.HMH_bgImage addSubview:self.HMH_titleLab];
    
    //
    self.HMH_subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame) + 5, self.HMH_titleLab.frame.size.width, 20)];
    self.HMH_subTitleLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_subTitleLab.textColor = [UIColor whiteColor];
    self.HMH_subTitleLab.font = [UIFont systemFontOfSize:14.0];
    [self.HMH_bgImage addSubview:self.HMH_subTitleLab];
    
    //
    self.HMH_timeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_subTitleLab.frame.origin.x, CGRectGetMaxY(self.HMH_subTitleLab.frame), self.HMH_subTitleLab.frame.size.width, self.HMH_subTitleLab.frame.size.height)];
    self.HMH_timeLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_timeLab.textColor = [UIColor whiteColor];
    self.HMH_timeLab.font = [UIFont systemFontOfSize:14.0];
    [self.HMH_bgImage addSubview:self.HMH_timeLab];
    
    //
    self.HMH_lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_lookBtn.frame = CGRectMake(ScreenW / 2 - 120, self.HMH_bgImage.frame.size.height - 20 - 30, 100, 30);
    self.HMH_lookBtn.backgroundColor = [UIColor clearColor];
    self.HMH_lookBtn.layer.masksToBounds = YES;
    self.HMH_lookBtn.layer.cornerRadius = self.HMH_lookBtn.frame.size.height / 2;
    self.HMH_lookBtn.layer.borderWidth = 1;
    self.HMH_lookBtn.layer.borderColor = RGBACOLOR(195, 156, 95, 1).CGColor;
    [self.HMH_lookBtn setImage:[UIImage imageNamed:@"VP_lookImage"] forState:UIControlStateNormal];
    [self.HMH_lookBtn setTitle:@"看预告片" forState:UIControlStateNormal];
    [self.HMH_lookBtn setTitleColor:RGBACOLOR(195, 156, 95, 1) forState:UIControlStateNormal];
    self.HMH_lookBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.HMH_lookBtn addTarget:self action:@selector(lookBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_bgImage addSubview:self.HMH_lookBtn];
    
    //
    self.previewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previewBtn.frame = CGRectMake(ScreenW / 2 + 20, self.HMH_lookBtn.frame.origin.y, self.HMH_lookBtn.frame.size.width, self.HMH_lookBtn.frame.size.height);
    self.previewBtn.layer.masksToBounds = YES;
    self.previewBtn.layer.cornerRadius = self.previewBtn.frame.size.height / 2;
    self.previewBtn.backgroundColor = RGBACOLOR(195, 156, 95, 1);
    self.previewBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.previewBtn setTitle:@"预约观看" forState:UIControlStateNormal];
//    [self.previewBtn setTitle:@"预约成功" forState:UIControlStateSelected];
    [self.previewBtn addTarget:self action:@selector(previewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_bgImage addSubview:self.previewBtn];
}
// 返回按钮的点击事件
- (void)backBtnClick:(UIButton *)btn{
    if (self.backClickBlock) {
        self.backClickBlock();
    }
}
// 分享按钮的点击事件
- (void)shareBtnClick:(UIButton *)btn{
    if (self.shareBtnBlock) {
        self.shareBtnBlock();
    }
}
// 看预告片按钮的点击事件
- (void)lookBtnClick:(UIButton *)btn{
    if (self.seePreViewBlock) {
        self.seePreViewBlock();
    }
}
// 预约观看按钮的点击事件
- (void)previewBtnClick:(UIButton *)btn{
    if (self.yuYueBtnClick) {
        self.yuYueBtnClick();
    }
}

- (void)refreshViewWithModel:(HMHVideoListModel *)model{
    
    [self.HMH_bgImage sd_setImageWithURL:[model.coverImageUrl get_Image]];
   
    self.HMH_titleLab.text = model.title;;
    self.HMH_subTitleLab.text = model.liveSpeaker;
    if (model.liveEndTime.length > 0) {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[model.liveStartTime doubleValue] / 1000];
        NSDate *endData = [NSDate dateWithTimeIntervalSince1970:[model.liveEndTime doubleValue] / 1000];
        
        NSDateFormatter  *start = [[NSDateFormatter alloc] init];
        [start setDateFormat:@"MM月dd日"];
        NSString *startStr = [start stringFromDate:startDate];
        
        NSDateFormatter  *end = [[NSDateFormatter alloc] init];
        [end setDateFormat:@"MM月dd日"];
        NSString *endStr = [end stringFromDate:endData];
        
        NSString *result;
        if ([startStr isEqualToString:endStr]) {
            [start setDateFormat:@"MM月dd日 HH:mm"];
            NSString *start1 =  [start stringFromDate:startDate];
            
            [end setDateFormat:@"HH:mm"];
            NSString *end1 =  [end stringFromDate:endData];
            if (end1.length > 0) {
                result = [NSString stringWithFormat:@"%@-%@",start1,end1];
            } else {
                result = [NSString stringWithFormat:@"%@",start1];
            }
        } else {
            [start setDateFormat:@"MM月dd日 HH:mm"];
            NSString *start1 =  [start stringFromDate:startDate];
            
            [end setDateFormat:@"MM月dd日 HH:mm"];
            NSString *end1 =  [end stringFromDate:endData];
            
            if (end1.length > 0) {
                result = [NSString stringWithFormat:@"%@-%@",start1,end1];
            } else {
                result = [NSString stringWithFormat:@"%@",start1];
            }
        }
        
        self.HMH_timeLab.text = result;
        
    } else {
        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[model.liveStartTime doubleValue] / 1000];
        
        NSDateFormatter  *start = [[NSDateFormatter alloc] init];
        [start setDateFormat:@"MM月dd日 HH:mm"];
        NSString *startStr = [start stringFromDate:startDate];
        self.HMH_timeLab.text = startStr;
        
    }
    if (model.appointment) {
        [self.previewBtn setTitle:@"已预约" forState:UIControlStateNormal];
    } else {
        [self.previewBtn setTitle:@"预约观看" forState:UIControlStateNormal];
    }
    
    if (model.coverVideoUrl.length > 6) {
        self.HMH_lookBtn.hidden = NO;
        self.previewBtn.frame = CGRectMake(ScreenW / 2 + 20, self.HMH_lookBtn.frame.origin.y, 100, 30);
    } else {
        self.HMH_lookBtn.hidden = YES;
        self.previewBtn.frame = CGRectMake(ScreenW / 2 - 50, self.HMH_bgImage.frame.size.height - 20 - 30, 100, 30);
    }
}

@end
