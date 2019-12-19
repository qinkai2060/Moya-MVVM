//
//  HMHVideoMoreCollectionViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/19.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoMoreCollectionViewCell.h"

@interface HMHVideoMoreCollectionViewCell ()

@property (nonatomic, strong) UIImageView *HMH_videoImage;
@property (nonatomic, strong) UIView *HMH_zhiBoBgView;
@property (nonatomic, strong) UILabel *HMH_zhiBoTopLab;
@property (nonatomic, strong) UILabel *HMH_playbackLab;

@property (nonatomic, strong) UIView *HMH_bottomBlackView;
@property (nonatomic, strong) UILabel *HMH_videoTypeLab;
@property (nonatomic, strong) UIButton *HMH_videoTypeBtn;

@property (nonatomic, strong) UIView *HMH_centerView;
@property (nonatomic, strong) UILabel *HMH_percentageLab;
@property (nonatomic, strong) UILabel *HMH_downLoadTypeLab;

@property (nonatomic, strong) UILabel *HMH_contentLab;

@end

@implementation HMHVideoMoreCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    self.HMH_videoImage.backgroundColor = [UIColor orangeColor];
    self.HMH_videoImage.userInteractionEnabled = YES;
    [self.contentView addSubview:self.HMH_videoImage];
    //
    self.HMH_zhiBoBgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 45, 20)];
    self.HMH_zhiBoBgView.backgroundColor = RGBACOLOR(51, 131, 238, 1);
    self.HMH_zhiBoTopLab.layer.masksToBounds = YES;
    self.HMH_zhiBoTopLab.layer.cornerRadius = 3.0;
    [self.HMH_videoImage addSubview:self.HMH_zhiBoBgView];
    //
    UILabel *dianLab = [[UILabel alloc] initWithFrame:CGRectMake(3, self.HMH_zhiBoBgView.frame.size.height / 2 - 4, 8, 8)];
    dianLab.backgroundColor = [UIColor whiteColor];
    dianLab.layer.masksToBounds = YES;
    dianLab.layer.cornerRadius = dianLab.frame.size.height / 2;
    [self.HMH_zhiBoBgView addSubview:dianLab];
    //
    self.HMH_zhiBoTopLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dianLab.frame), 0, 30, self.HMH_zhiBoBgView.frame.size.height)];
    self.HMH_zhiBoTopLab.textColor = [UIColor whiteColor];
    self.HMH_zhiBoTopLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_zhiBoTopLab.textAlignment = NSTextAlignmentCenter;
    [self.HMH_zhiBoBgView addSubview:self.HMH_zhiBoTopLab];
    
    //
    self.HMH_playbackLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 30, 20)];
    self.HMH_playbackLab.backgroundColor = [UIColor blackColor];
    self.HMH_playbackLab.alpha = 0.5;
    self.HMH_playbackLab.textColor = [UIColor whiteColor];
    self.HMH_playbackLab.font = [UIFont systemFontOfSize:10.0];
    self.HMH_playbackLab.textAlignment = NSTextAlignmentCenter;
    [self.HMH_videoImage addSubview:self.HMH_playbackLab];
    self.HMH_playbackLab.hidden = YES;
    
    //
    self.HMH_bottomBlackView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.HMH_videoImage.frame.size.height - 20, self.HMH_videoImage.frame.size.width, 20)];
    self.HMH_bottomBlackView.backgroundColor = [UIColor blackColor];
    self.HMH_bottomBlackView.alpha = 0.5;
    self.HMH_bottomBlackView.userInteractionEnabled = YES;
    [self.HMH_videoImage addSubview:self.HMH_bottomBlackView];
    
    //
    self.HMH_videoTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_bottomBlackView.frame.size.width - 60 - 100, 0, 100, self.HMH_bottomBlackView.frame.size.height)];
    self.HMH_videoTypeLab.textAlignment = NSTextAlignmentRight;
    self.HMH_videoTypeLab.textColor = [UIColor whiteColor];
    self.HMH_videoTypeLab.font = [UIFont systemFontOfSize:12.0];
    [self.HMH_bottomBlackView addSubview:self.HMH_videoTypeLab];
    
    //
    self.HMH_videoTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_videoTypeBtn.frame = CGRectMake(CGRectGetMaxX(self.HMH_videoTypeLab.frame), 0, 60, self.HMH_bottomBlackView.frame.size.height);
    [self.HMH_videoTypeBtn addTarget:self action:@selector(downLoadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_bottomBlackView addSubview:self.HMH_videoTypeBtn];
    
    //    HMH_centerView
    self.HMH_centerView = [[UIView alloc] initWithFrame:CGRectMake(self.HMH_videoImage.frame.size.width / 2 - 40, self.HMH_videoImage.frame.size.height / 2 - 20, 80, 40)];
    self.HMH_centerView.backgroundColor = [UIColor blackColor];
    self.HMH_centerView.alpha = 0.5;
    self.HMH_centerView.layer.masksToBounds = YES;
    self.HMH_centerView.layer.cornerRadius = 5.0;
    self.HMH_centerView.userInteractionEnabled = YES;
    [self.HMH_videoImage addSubview:self.HMH_centerView];
    
    //
    self.HMH_percentageLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, self.HMH_centerView.frame.size.width, 15)];
    self.HMH_percentageLab.textColor = [UIColor whiteColor];
    self.HMH_percentageLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_percentageLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_percentageLab.userInteractionEnabled = YES;
    [self.HMH_centerView addSubview:self.HMH_percentageLab];
    
    //
    self.HMH_downLoadTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_percentageLab.frame.origin.x, CGRectGetMaxY(self.HMH_percentageLab.frame) + 2, self.HMH_percentageLab.frame.size.width, 15)];
    self.HMH_downLoadTypeLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_downLoadTypeLab.textColor = [UIColor whiteColor];
    self.HMH_downLoadTypeLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_downLoadTypeLab.userInteractionEnabled = YES;
    [self.HMH_centerView addSubview:self.HMH_downLoadTypeLab];
    
    //
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.frame = CGRectMake(0, 0, self.HMH_centerView.frame.size.width, self.HMH_centerView.frame.size.height);
    centerBtn.backgroundColor = [UIColor clearColor];
    [centerBtn addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_centerView addSubview:centerBtn];
    
    //
    self.HMH_contentLab = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.HMH_videoImage.frame) + 5, self.HMH_videoImage.frame.size.width - 10, 50)];
    self.HMH_contentLab.font = [UIFont systemFontOfSize:16.0];
    self.HMH_contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.HMH_contentLab];
}

- (void)refreshCellWithModel:(id)model{
    self.HMH_zhiBoTopLab.text = @"直播";
    self.HMH_videoTypeLab.text = @"已下载";
    [self.HMH_videoTypeBtn setTitle:@"下载" forState:UIControlStateNormal];
    self.HMH_percentageLab.text = @"50%";
    self.HMH_downLoadTypeLab.text = @"下载中...";
    self.HMH_contentLab.text = @"测试测试测试试测试测试试测试测试试";
}
// 下载按钮的点击事件
- (void)downLoadBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(videoButtonClickToDownLoadWithIndex:)]) {
        [self.delegate videoButtonClickToDownLoadWithIndex:1];
    }
}
// 中间下载百分比按钮的点击事件
- (void)centerButtonClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(centerButtonClickToChangeDownLoadStatesWithCell:Index:)]) {
        [self.delegate centerButtonClickToChangeDownLoadStatesWithCell:self Index:1];
    }
}

@end
