//
//  HMHVideoCoursewareCollectionViewCell.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/6.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoCoursewareCollectionViewCell.h"
@interface HMHVideoCoursewareCollectionViewCell ()

@property (nonatomic, strong) UIView *HMH_bgView;
@property (nonatomic, strong) UIImageView *HMH_centerImageView;
@property (nonatomic, strong) UILabel *HMH_titleLab;

@end
@implementation HMHVideoCoursewareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    self.HMH_bgView.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    [self.contentView addSubview:self.HMH_bgView];
    
    //
    self.HMH_centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.HMH_bgView.frame.size.width / 2 - 26, self.HMH_bgView.frame.size.height / 2 - 31, 52, 62)];
    self.HMH_centerImageView.userInteractionEnabled = YES;
    [self.HMH_bgView addSubview:self.HMH_centerImageView];

    //
    self.HMH_titleLab = [[UILabel alloc] init];
    self.HMH_titleLab.frame = CGRectMake(0, CGRectGetMaxY(self.HMH_bgView.frame),self.HMH_bgView.frame.size.width, 30);
    self.HMH_titleLab.numberOfLines = 0;
    self.HMH_titleLab.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.HMH_titleLab];
}

- (void)refreshTableViewCellWithUrl:(NSString *)url title:(NSString *)titleStr{
    NSString *endStr = [url substringFromIndex:url.length- 1];
    NSString *normalStr;
    if ([endStr isEqualToString:@"|"]) {
        normalStr = [url substringToIndex:url.length - 1];
    } else {
        normalStr = url;
    }
    
    NSString *categoryStr = [normalStr substringFromIndex:6];
    if ([categoryStr containsString:@"pdf"] || [categoryStr containsString:@"PDF"]) {
        self.HMH_centerImageView.image = [UIImage imageNamed:@"video_PDF"];
    } else if ([categoryStr containsString:@"doc"] || [categoryStr containsString:@"doc"]){
        self.HMH_centerImageView.image = [UIImage imageNamed:@"video_Word"];

    } else if ([categoryStr containsString:@"ppt"] || [categoryStr containsString:@"PPT"]){
        self.HMH_centerImageView.image = [UIImage imageNamed:@"video_PPT"];

    }else if ([categoryStr containsString:@"excel"] || [categoryStr containsString:@"EXCEL"]){
        self.HMH_centerImageView.image = [UIImage imageNamed:@"video_Excel"];
    }else{
        self.HMH_centerImageView.image = [UIImage imageNamed:@"video_keJianOther"];
    }
    
    self.HMH_titleLab.text = titleStr;
}

@end
