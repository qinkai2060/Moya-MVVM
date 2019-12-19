//
//  CacheListTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoCacheListTableViewCell.h"

@interface HMHVideoCacheListTableViewCell ()
@property (nonatomic, strong) UIImageView *HMH_videoImageView;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_firstLab;
@property (nonatomic, strong) UILabel *HMH_secondLab;
@property (nonatomic, strong) UILabel *HMH_viewNumLab;

@end

@implementation HMHVideoCacheListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //
    self.HMH_videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 110, 70)];
    self.HMH_videoImageView.layer.masksToBounds = YES;
    self.HMH_videoImageView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.HMH_videoImageView];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_videoImageView.frame) + 10, 5, ScreenW - CGRectGetMaxX(self.HMH_videoImageView.frame) - 20, 20)];
    self.HMH_titleLab.textColor = RGBACOLOR(89, 90, 91, 1);
    self.HMH_titleLab.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_firstLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame) + 7, 60, 15)];
    self.HMH_firstLab.backgroundColor = RGBACOLOR(163, 125, 58, 1);
    self.HMH_firstLab.textColor = [UIColor whiteColor];
    self.HMH_firstLab.font = [UIFont systemFontOfSize:10.0];
    self.HMH_firstLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_firstLab.layer.masksToBounds = YES;
    self.HMH_firstLab.layer.cornerRadius = 3.0;
    [self.contentView addSubview:self.HMH_firstLab];
    
    //
    self.HMH_secondLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_firstLab.frame) + 5, self.HMH_firstLab.frame.origin.y, 60, 15)];
    self.HMH_secondLab.backgroundColor = RGBACOLOR(163, 125, 58, 1);
    self.HMH_secondLab.textColor = [UIColor whiteColor];
    self.HMH_secondLab.font = [UIFont systemFontOfSize:10.0];
    self.HMH_secondLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_secondLab.layer.masksToBounds = YES;
    self.HMH_secondLab.layer.cornerRadius = 3.0;
    [self.contentView addSubview:self.HMH_secondLab];

    //
    self.HMH_viewNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_firstLab.frame) + 5, self.HMH_titleLab.frame.size.width, 20)];
    self.HMH_viewNumLab.textColor = RGBACOLOR(142, 143, 144, 1);
    self.HMH_viewNumLab.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.HMH_viewNumLab];
}

- (void)refreshCellWithModel:(id)model{
    self.HMH_videoImageView.backgroundColor = [UIColor grayColor];
    self.HMH_titleLab.text = @"合发合发合发合发合发合发";
    self.HMH_firstLab.text = @"合发培训合发 缓存";
    
    CGSize size = [self.HMH_firstLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0],NSFontAttributeName, nil]];
    self.HMH_firstLab.width = size.width + 10;
    
    self.HMH_secondLab.text = @"企业文化";
    CGSize secondSize = [self.HMH_secondLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0],NSFontAttributeName, nil]];
    CGRect rect = self.HMH_secondLab.frame;
    rect.origin.x = CGRectGetMaxX(self.HMH_firstLab.frame) + 10;
    rect.size.width = secondSize.width + 10;
    self.HMH_secondLab.frame = rect;
    
    self.HMH_viewNumLab.text = @"234人观看";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
