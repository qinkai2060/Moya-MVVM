//
//  HMHShortVideoMoreTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHShortVideoMoreTableViewCell.h"

@interface HMHShortVideoMoreTableViewCell ()

@property (nonatomic, strong) UIImageView *HMH_imgView;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_lookLab;
@property (nonatomic, strong) UILabel *HMH_labelLab;

@end

@implementation HMHShortVideoMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    self.HMH_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, ScreenW - 20, 180)];
    self.HMH_imgView.layer.masksToBounds = YES;
    self.HMH_imgView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.HMH_imgView];
    
    //
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.HMH_imgView.frame.size.height - 30, self.HMH_imgView.frame.size.width, 30)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.3;
    [self.HMH_imgView addSubview:bgView];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, self.HMH_imgView.frame.size.height - 30, self.HMH_imgView.frame.size.width - 20, 30)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_titleLab.textColor = [UIColor whiteColor];
    [self.HMH_imgView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_lookLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_imgView.frame.origin.x + 5, CGRectGetMaxY(self.HMH_imgView.frame) , 200, 20)];
    self.HMH_lookLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_lookLab.textColor = RGBACOLOR(135, 136, 137, 1);
    [self.contentView addSubview:self.HMH_lookLab];
    
    //
    self.HMH_labelLab = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 20 - 200, self.HMH_lookLab.frame.origin.y, 200, self.HMH_lookLab.frame.size.height)];
    self.HMH_labelLab.textAlignment = NSTextAlignmentRight;
    self.HMH_labelLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_labelLab.textColor = RGBACOLOR(135, 136, 137, 1);
    [self.contentView addSubview:self.HMH_labelLab];
}

- (void)refreshCellWithModel:(HMHVideoListModel *)model{
    self.HMH_imgView.backgroundColor = RGBACOLOR(239, 239, 239, 1);
   
     [self.HMH_imgView sd_setImageWithURL:[model.coverImageUrl get_Image]];
   
    

    self.HMH_titleLab.text = model.title;
    
    NSString *labStr;
//    NSString *firstStr = [NSString stringWithFormat:@"%@",model.primaryCategoryName];
    
    NSString *secondStr;
    if (model.videoTagName.length > 0 && ![model.videoTagName isEqualToString:@"(null)"]) {
        NSArray *arr = [model.videoTagName componentsSeparatedByString:@","];
        if (arr.count >0) {
            secondStr = [arr objectAtIndex:0];
        }
    }

//    if (firstStr.length > 0 && ![firstStr isEqualToString:@"(null)"]) {
//        labStr = [NSString stringWithFormat:@"#%@",firstStr];
//    } else
    if (secondStr.length > 0 && ![secondStr isEqualToString:@"(null)"]){
        labStr = [NSString stringWithFormat:@"#%@",secondStr];
    } else {
        labStr = @"";
    }
    
    self.HMH_labelLab.text = labStr;

    
    NSString *hitsStr;
    if ([model.hits integerValue] > 10000) {
        float hitsF = [model.hits floatValue] / 10000.0;
        hitsStr = [NSString stringWithFormat:@"%.1f万人观看",hitsF];
    } else {
        int hitsI = [model.hits intValue];
        hitsStr = [NSString stringWithFormat:@"%d人观看",hitsI];
    }
    self.HMH_lookLab.text = hitsStr;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
