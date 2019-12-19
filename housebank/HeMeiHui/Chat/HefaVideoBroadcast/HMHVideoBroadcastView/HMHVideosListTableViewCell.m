//
//  HMHVideosListTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/28.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideosListTableViewCell.h"

@interface HMHVideosListTableViewCell ()
@property (nonatomic, strong) UIImageView *videoImageView;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_firstLab;
@property (nonatomic, strong) UILabel *HMH_secondLab;
@property (nonatomic, strong) UILabel *HMH_viewNumLab;
@property (nonatomic, strong) UILabel *HMH_topLab;

@end

@implementation HMHVideosListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.videoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, (ScreenW - 20) / 5 * 2,(ScreenW - 20) / 5 * 2 * 0.618)];
    self.videoImageView.layer.masksToBounds = YES;
    self.videoImageView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.videoImageView];
    
    // 置顶
    self.HMH_topLab = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 25, 15)];
    self.HMH_topLab.backgroundColor = [UIColor redColor];
    self.HMH_topLab.textColor = [UIColor whiteColor];
    self.HMH_topLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_topLab.font = [UIFont systemFontOfSize:10.0];
    [self.videoImageView addSubview:self.HMH_topLab];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.videoImageView.frame) + 10, 5, ScreenW - CGRectGetMaxX(self.videoImageView.frame) - 20, 35)];
    self.HMH_titleLab.textColor = RGBACOLOR(89, 90, 91, 1);
    self.HMH_titleLab.numberOfLines = 0;
    self.HMH_titleLab.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_firstLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame) + 5, 60, 15)];
    self.HMH_firstLab.backgroundColor = RGBACOLOR(166, 132, 55, 1);
    self.HMH_firstLab.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
    self.HMH_firstLab.textColor = [UIColor whiteColor];
    self.HMH_firstLab.font = [UIFont systemFontOfSize:10.0];
    self.HMH_firstLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_firstLab.layer.masksToBounds = YES;
    self.HMH_firstLab.layer.cornerRadius = 3.0;
    [self.contentView addSubview:self.HMH_firstLab];
    
    //
    self.HMH_secondLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_firstLab.frame) + 5, self.HMH_firstLab.frame.origin.y, 60, 15)];
    self.HMH_secondLab.backgroundColor =RGBACOLOR(166, 132, 55, 1);
    self.HMH_secondLab.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
    self.HMH_secondLab.textColor = [UIColor whiteColor];
    self.HMH_secondLab.font = [UIFont systemFontOfSize:10.0];
    self.HMH_secondLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_secondLab.layer.masksToBounds = YES;
    self.HMH_secondLab.layer.cornerRadius = 3.0;
    [self.contentView addSubview:self.HMH_secondLab];
    
//
    self.HMH_viewNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.videoImageView.frame) - 25, self.HMH_titleLab.frame.size.width, 20)];
    self.HMH_viewNumLab.textColor = RGBACOLOR(142, 143, 144, 1);
    self.HMH_viewNumLab.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.HMH_viewNumLab];
}

- (void)refreshCellWithModel:(HMHVideoListModel *)model{
    self.videoImageView.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    [self.videoImageView sd_setImageWithURL:[model.coverImageUrl get_Image]];
    


    if ([model.top isEqualToNumber:@1]) {
        self.HMH_topLab.hidden = NO;
        self.HMH_topLab.text = @"置顶";
    } else{
        self.HMH_topLab.hidden = YES;
    }
    
    // 实现搜索结果变色
     [self.HMH_titleLab setAttributedText:[self setSearchResultStringColorWithResultStr:model.title searchStr:model.searchStr]];
    
//    self.HMH_titleLab.text = model.title;

    NSString *firstStr = [NSString stringWithFormat:@"%@",model.primaryCategoryName];
    self.HMH_firstLab.text = firstStr;

    CGSize size = [self.HMH_firstLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0],NSFontAttributeName, nil]];
    if (firstStr.length > 0 && ![firstStr isEqualToString:@"(null)"]) {
        self.HMH_firstLab.hidden = NO;
        self.HMH_firstLab.width = size.width + 10;
    } else {
        self.HMH_firstLab.hidden = YES;
    }
    
    NSString *secondStr;
    if (model.videoTagName.length > 0) {
        NSArray *arr = [model.videoTagName componentsSeparatedByString:@","];
        if (arr.count >0) {
            secondStr = [arr objectAtIndex:0];
        }
    }
    self.HMH_secondLab.text = secondStr;
    CGSize secondSize = [self.HMH_secondLab.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0],NSFontAttributeName, nil]];
    CGRect rect = self.HMH_secondLab.frame;
    if (firstStr.length > 0 && ![firstStr isEqualToString:@"(null)"]) {
        rect.origin.x = CGRectGetMaxX(self.HMH_firstLab.frame) + 10;
    } else {
        rect.origin.x = CGRectGetMaxX(self.videoImageView.frame) + 10;
    }
    rect.size.width = secondSize.width + 10;
    
    if (secondStr.length > 0) {
        self.HMH_secondLab.hidden = NO;
        self.HMH_secondLab.frame = rect;
    } else {
        self.HMH_secondLab.hidden = YES;
    }

    NSString *hitsStr;
    if ([model.hits integerValue] > 10000) {
        float hitsF = [model.hits floatValue] / 10000.0;
        hitsStr = [NSString stringWithFormat:@"%.1f万人观看",hitsF];
    } else {
        int hitsI = [model.hits intValue];
        hitsStr = [NSString stringWithFormat:@"%d人观看",hitsI];
    }
    self.HMH_viewNumLab.text = hitsStr;
}

// 实现搜索结果变色
- (NSMutableAttributedString *)setSearchResultStringColorWithResultStr:(NSString *)resultString searchStr:(NSString *)searchString{
    
    NSError *error = NULL;
    
    NSString *initStr = resultString;
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:initStr];
    
    NSString *searchStr = searchString;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:searchStr options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSArray *rangeArray = [expression matchesInString:initStr options:0 range:NSMakeRange(0, initStr.length)];
    
    for (NSTextCheckingResult *result in rangeArray) {
        
        NSRange range = [result range];
        
        if (range.location != NSNotFound) {
            
            [str addAttribute:NSForegroundColorAttributeName value:RGBACOLOR(55, 156, 241, 1) range:NSMakeRange(range.location,range.length)];
        }
    }
    return str;
}

@end
