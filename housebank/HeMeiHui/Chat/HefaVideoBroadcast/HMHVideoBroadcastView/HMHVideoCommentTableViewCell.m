//
//  HMHVideoCommentTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/19.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoCommentTableViewCell.h"


@interface HMHVideoCommentTableViewCell()

@property (nonatomic, strong) UIView *HMH_contentBgView;

@property (nonatomic, strong) UIImageView *HMH_iconImageView;
@property (nonatomic, strong) UILabel *HMH_nameLab;
@property (nonatomic, strong) UILabel *HMH_timeLab;
@property (nonatomic, strong) UILabel *HMH_contentLab;

@property (nonatomic, strong) UIView *HMH_commentView; // 其他评论view

@property (nonatomic, strong) UIButton *HMH_showAllCommentBtn;

//cell对应索引号
@property (nonatomic,assign) NSInteger cellIndex;

@end

@implementation HMHVideoCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createTableViewCell];
    }
    return self;
}

- (void)createTableViewCell{
    //
    self.HMH_iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.HMH_iconImageView.backgroundColor = RGBACOLOR(239, 239, 239, 1);
    [self.contentView addSubview:self.HMH_iconImageView];
    
    //
    self.HMH_nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.HMH_iconImageView.frame) + 10, self.HMH_iconImageView.frame.origin.y + 5, ScreenW -CGRectGetMaxX(self.HMH_iconImageView.frame) - 70 , 20)];
    self.HMH_nameLab.textColor = RGBACOLOR(87, 88, 89, 1);
    self.HMH_nameLab.font = [UIFont systemFontOfSize:16.0];
    [self.contentView addSubview:self.HMH_nameLab];
    
    //
    self.HMH_contentLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_nameLab.frame.origin.x, CGRectGetMaxY(self.HMH_nameLab.frame) + 6, self.HMH_nameLab.frame.size.width + 50, 40)];
    self.HMH_contentLab.font = [UIFont systemFontOfSize:15.0];
    self.HMH_contentLab.textColor = RGBACOLOR(87, 88, 89, 1);
    self.HMH_contentLab.numberOfLines = 0;
    [self.contentView addSubview:self.HMH_contentLab];
    
    //
    self.HMH_timeLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_contentLab.frame.origin.x, CGRectGetMaxY(self.HMH_contentLab.frame) + 10, self.HMH_nameLab.frame.size.width, self.HMH_nameLab.frame.size.height)];
    self.HMH_timeLab.font = [UIFont systemFontOfSize:13.0];
    self.HMH_timeLab.textColor = RGBACOLOR(139, 140, 142, 1);
    [self.contentView addSubview:self.HMH_timeLab];
    
    //
    self.zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zanBtn.frame = CGRectMake(ScreenW - 80, self.HMH_nameLab.frame.origin.y - 20, 80, 55);
    [self.zanBtn setImage:[UIImage imageNamed:@"Video_unZanSelectImage"] forState:UIControlStateNormal];
    [_zanBtn setImage:[UIImage imageNamed:@"Video_zanSelectImage"] forState:UIControlStateSelected];
    //    [self.zanBtn setTitle:@" 赞" forState:UIControlStateNormal];
    [_zanBtn setTitle:@"  0" forState:UIControlStateNormal];
    [_zanBtn setTitle:@"  0" forState:UIControlStateSelected];
    self.zanBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [self.zanBtn setTitleColor:RGBACOLOR(186, 184, 184, 1) forState:UIControlStateNormal];
    [self.zanBtn setTitleColor:RGBACOLOR(249, 79, 7, 1) forState:UIControlStateSelected];
    [self.zanBtn addTarget:self action:@selector(zanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage *img = [UIImage imageNamed:@"circle_zan"];
//    [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -img.size.width, 0, img.size.width)];
//    [_zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _zanBtn.titleLabel.bounds.size.width  + 20, 0, -_zanBtn.titleLabel.bounds.size.width - 20)];

    [self.contentView addSubview:self.zanBtn];
    
    //显示全部
    _HMH_showAllCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _HMH_showAllCommentBtn.backgroundColor = [UIColor whiteColor];
    _HMH_showAllCommentBtn.frame = CGRectMake(self.HMH_contentLab.frame.origin.x,CGRectGetMaxY(_HMH_contentLab.frame), 100, 20);
    [_HMH_showAllCommentBtn setTitleColor:RGBACOLOR(83, 96, 114, 1) forState:UIControlStateNormal];
    _HMH_showAllCommentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_HMH_showAllCommentBtn setTitle:@"全文" forState:UIControlStateNormal];
    [_HMH_showAllCommentBtn addTarget:self action:@selector(showAllCommentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _HMH_showAllCommentBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//    [self.contentView addSubview:_HMH_showAllCommentBtn];
}

- (void)refreshTableViewCellWithModel:(HMHVideoCommentModel *)model{
    _cellIndex = model.cellIndex;
    [self.HMH_iconImageView sd_setImageWithURL:[model.commentUserAvatar get_Image] placeholderImage:[UIImage imageNamed:@"circle_default_icon"]];
   
    if (model.commentUserName.length > 0 && ![model.commentUserName isEqualToString:@"(null)"]) {
        self.HMH_nameLab.text = [NSString stringWithFormat:@"%@",model.commentUserName];
    }
    
    if (model.commentTime) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[model.commentTime doubleValue] / 1000];
        
        NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        _HMH_timeLab.text = [dateFormat stringFromDate:date];
    }
    
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
//    NSString *zanNumStr =[NSString stringWithFormat:@" 88"];
//    [_zanBtn setTitle:zanNumStr forState:UIControlStateNormal];
//    UIImage *img = [UIImage imageNamed:@"circle_zan"];
//    CGFloat f = 0.0;
//    if (zanNumStr.length == 3) {
//        f = 30;
//    }else if (zanNumStr.length == 4){
//        f = 50;
//    } else {
//        f = 20;
//    }
//    [_zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -img.size.width, 0, img.size.width)];
//    [_zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _zanBtn.titleLabel.bounds.size.width  + 20, 0, -_zanBtn.titleLabel.bounds.size.width - f)];

    NSString *commentStr = model.content;

    self.HMH_contentLab.text = commentStr;
    
    CGFloat contentHeight = [self getHeightWithFontSize:15.0 with:ScreenW -CGRectGetMaxX(self.HMH_iconImageView.frame) - 20 text:commentStr];
    _HMH_contentLab.height = contentHeight;
    
    CGRect rect=  self.HMH_timeLab.frame;
    rect.origin.y= CGRectGetMaxY(self.HMH_contentLab.frame) + 5;
    self.HMH_timeLab.frame=rect;
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
    
    // 空隙10 name高20 time高20
    height = height + 10 + 20 + 10 + 20 + 10;
    return height;
}

// 查看全部
- (void)showAllCommentBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(showAllConentBtnClickWithIndex:)]) {
        [self.delegate showAllConentBtnClickWithIndex:_cellIndex];
    }
}

- (void)zanBtnClick:(UIButton *)zanBtn{
    //zanBtn.selected = !zanBtn.selected;
    if ([self.delegate respondsToSelector:@selector(videoCommentZanBtbClickWithIndex:withCommentCell:)]) {
        // 此处的index需传值
        [self.delegate videoCommentZanBtbClickWithIndex:_cellIndex withCommentCell:self];
    }
}

@end
