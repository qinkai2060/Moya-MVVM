//
//  HMHVideoStartTimeTableViewCell.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoStartTimeTableViewCell.h"

@interface HMHVideoStartTimeTableViewCell ()

@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_timeLab;

@end

@implementation HMHVideoStartTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}
- (void)HMH_createUI{
    //
    UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    line1.backgroundColor = RGBACOLOR(221, 219, 221, 1);
    [self.contentView addSubview:line1];
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 200, 38)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_titleLab.textColor =  RGBACOLOR(137, 138, 138, 1);
    self.HMH_titleLab.text = @"直播开始时间";
    [self.contentView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_timeLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 10 - 150, 1, 150, 38)];
    self.HMH_timeLab.textAlignment = NSTextAlignmentRight;
    self.HMH_timeLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_timeLab.textColor =  RGBACOLOR(137, 138, 138, 1);
    [self.contentView addSubview:self.HMH_timeLab];
    
    //
    UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.HMH_titleLab.frame), ScreenW, 1)];
    line2.backgroundColor = RGBACOLOR(221, 219, 221, 1);
    [self.contentView addSubview:line2];

}

- (void)refreshTabelViewCellWithTime:(NSString *)timeStr{
    NSString *timeString = [NSString stringWithFormat:@"%@",timeStr];
    if (timeString.length > 0 && ![timeString isEqualToString:@"(null)"]) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue] / 1000];
        
        NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *result = [dateFormat stringFromDate:date];
        
        self.HMH_timeLab.text = result;
    } else {
        self.HMH_timeLab.text = @"";
    }
}

@end
