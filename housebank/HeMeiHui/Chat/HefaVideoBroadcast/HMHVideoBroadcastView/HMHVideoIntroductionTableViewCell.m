//
//  HMHVideoIntroductionTableViewCell.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoIntroductionTableViewCell.h"

@interface HMHVideoIntroductionTableViewCell()

@property (nonatomic, strong) UILabel *videoAbstractLab;

@end

@implementation HMHVideoIntroductionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}
- (void)HMH_createUI{
    //
    self.videoAbstractLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, ScreenW - 20, 40)];
    self.videoAbstractLab.numberOfLines = 0;
    self.videoAbstractLab.textColor = RGBACOLOR(137, 138, 138, 1);
    self.videoAbstractLab.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.videoAbstractLab];
    
}

- (void)refreshWithText:(NSString *)text{
    
   CGFloat h = [self getHeightWithFontSize:14.0 with:ScreenW - 20 text:text];
    CGRect rect = self.videoAbstractLab.frame;
    rect.size.height = h + 10;
    self.videoAbstractLab.frame = rect;
    self.videoAbstractLab.text = text;
}

+(CGFloat)cellHeightWithText:(NSString *)text{
    NSString *commentStr = text;
    
    if (!commentStr || commentStr.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(ScreenW - 20 , MAXFLOAT)
                                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attr
                                              context:nil].size.height;
        // 摘要的高度
    if ((height + 10) < 40) {
        height = 30;
    }
    return height + 10 ;
}

// 自动获取高度
- (CGFloat)getHeightWithFontSize:(CGFloat)font  with:(CGFloat)width text:(NSString *)text
{
    if (!text || text.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil].size.height;
    return height;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
