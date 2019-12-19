//
//  HMHVideoCardTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoCardTableViewCell.h"

@interface HMHVideoCardTableViewCell ()

@property (nonatomic, strong) UILabel *HMH_nameLab;
@property (nonatomic, strong) UILabel *HMH_timeLab;
@property (nonatomic, strong) UILabel *HMH_contentLab;

@property (nonatomic, assign) NSInteger cellIndex;
@end

@implementation HMHVideoCardTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    //
    self.HMH_nameLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 20)];
    self.HMH_nameLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_nameLab.textColor = RGBACOLOR(70, 123, 211, 1);
    [self.contentView addSubview:self.HMH_nameLab];
    
    //
    self.HMH_timeLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_nameLab.frame) + 5, self.HMH_nameLab.frame.origin.y, ScreenW - CGRectGetMaxX(self.HMH_nameLab.frame) - 80, self.HMH_nameLab.frame.size.height)];
    self.HMH_timeLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_timeLab.textColor = RGBACOLOR(123, 124, 125, 1);
    [self.contentView addSubview:self.HMH_timeLab];
    
    //
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zanBtn.frame = CGRectMake(ScreenW - 80, self.HMH_nameLab.frame.origin.y - 20, 80, 55);
    [self.zanBtn setImage:[UIImage imageNamed:@"Video_unZanSelectImage"] forState:UIControlStateNormal];
    [_zanBtn setImage:[UIImage imageNamed:@"Video_zanSelectImage"] forState:UIControlStateSelected];
    [_zanBtn setTitle:@" 0" forState:UIControlStateNormal];
    [_zanBtn setTitle:@" 0" forState:UIControlStateSelected];
    self.zanBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.zanBtn setTitleColor:RGBACOLOR(186, 184, 184, 1) forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:RGBACOLOR(249, 79, 7, 1) forState:UIControlStateSelected];
    [self.zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:self.zanBtn];

//    UIImage *img = [UIImage imageNamed:@"circle_zan"];
//    [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -img.size.width, 0, img.size.width)];
//    [_zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _zanBtn.titleLabel.bounds.size.width  + 20, 0, -_zanBtn.titleLabel.bounds.size.width - 20)];
    
    //
    self.HMH_contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_nameLab.frame.origin.x, CGRectGetMaxY(self.HMH_nameLab.frame) + 5, ScreenW - 40, 40)];
    self.HMH_contentLab.font = [UIFont systemFontOfSize:15.0];
    self.HMH_contentLab.textColor = RGBACOLOR(88, 89, 90, 1);
    self.HMH_contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.HMH_contentLab];
}

- (void)refreshCellWithModel:(HMHVideoCommentModel *)model{
    _cellIndex = model.cellIndex;
    NSString *nameStr;
    if (model.commentUserName.length > 0 && ![model.commentUserName isEqualToString:@"(null)"]) {
        nameStr = model.commentUserName;
    } else {
        nameStr = @"";
    }
    CGFloat w = [self getWidthWithFont:[UIFont systemFontOfSize:14.0] height:20 text:nameStr];
    self.HMH_nameLab.width = w + 5;
    
    CGRect rect = self.HMH_timeLab.frame;
    rect.origin.x = CGRectGetMaxX(self.HMH_nameLab.frame) + 5;
    self.HMH_timeLab.frame = rect;
    
    self.HMH_nameLab.text = nameStr;
    
    if (model.commentTime) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.commentTime doubleValue] / 1000];
        
        NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];

        _HMH_timeLab.text = [dateFormat stringFromDate:date];
    }
    
    NSString *commentStr =model.content;

    self.HMH_contentLab.text = commentStr;
    
    CGFloat contentHeight = [self getHeightWithFontSize:15.0 with:ScreenW - 40 text:commentStr];
    _HMH_contentLab.height = contentHeight;
    
    // 点赞的状态
    if (model.myLike) {
        _zanBtn.selected = YES;
    } else if(!model.myLike){
        _zanBtn.selected = NO;
    }
    
    if ([model.likesNum longLongValue] > 99) {
        [_zanBtn setTitle:@" 99+" forState:UIControlStateNormal];
        [_zanBtn setTitle:@" 99+" forState:UIControlStateSelected];
    } else {
        [_zanBtn setTitle:[NSString stringWithFormat:@" %lld",[model.likesNum longLongValue]] forState:UIControlStateNormal];
        [_zanBtn setTitle:[NSString stringWithFormat:@" %lld",[model.likesNum longLongValue]] forState:UIControlStateSelected];
    }

}

+(CGFloat)cellHeightWithModel:(HMHVideoCommentModel *)model{
    NSString *commentStr = model.content;
    
    if (!commentStr || commentStr.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:15]};
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(ScreenW -60 - 20 , MAXFLOAT)
                                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attr
                                              context:nil].size.height;
    // 空隙10  name高20
    height = height + 10 + 20 + 10;
    return height;

}

- (CGFloat)getWidthWithFont:(UIFont *)font  height:(CGFloat)height text:(NSString *)text
{
    NSDictionary *attr = @{NSFontAttributeName : font};
    CGFloat width = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                    attributes:attr
                                       context:nil].size.width;
    return width;
}

// 自动获取高度
- (CGFloat)getHeightWithFontSize:(CGFloat)font  with:(CGFloat)with text:(NSString *)text
{
    if (!text || text.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:font]};
    CGFloat height = [text boundingRectWithSize:CGSizeMake(with, MAXFLOAT)
                                        options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                     attributes:attr
                                        context:nil].size.height;
    return height;
}
// 点赞按钮的点击事件
- (void)zanBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([self.delegate respondsToSelector:@selector(videoCardCommentZanBtbClickWithIndex: withTableViewCell:)]) {
        // 此处需传按钮所对应的index
        [self.delegate videoCardCommentZanBtbClickWithIndex:_cellIndex withTableViewCell:self];
    }
}

@end
