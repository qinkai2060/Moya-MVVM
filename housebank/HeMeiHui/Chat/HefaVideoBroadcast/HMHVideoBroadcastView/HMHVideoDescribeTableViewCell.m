//
//  HMHVideoDescribeTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoDescribeTableViewCell.h"

@interface HMHVideoDescribeTableViewCell ()

@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_zhaiYaoLab;
@property (nonatomic, strong) UILabel *HMH_subLab;
@property (nonatomic, strong) UIButton *HMH_openBtn;
@end

@implementation HMHVideoDescribeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,ScreenW - 20 , 30)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:15.0];
    [self.contentView addSubview:self.HMH_titleLab];
    
    //
    self.HMH_zhaiYaoLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_titleLab.frame), self.HMH_titleLab.frame.size.width, 20)];
    self.HMH_zhaiYaoLab.font = [UIFont systemFontOfSize:14.0];
    self.HMH_zhaiYaoLab.textColor = RGBACOLOR(99, 100, 101, 1);
    [self.contentView addSubview:self.HMH_zhaiYaoLab];

    //
    self.HMH_subLab = [[UILabel alloc] initWithFrame:CGRectMake(self.HMH_titleLab.frame.origin.x, CGRectGetMaxY(self.HMH_zhaiYaoLab.frame), self.HMH_titleLab.frame.size.width, 40)];
    self.HMH_subLab.numberOfLines = 0;
    self.HMH_subLab.textColor = RGBACOLOR(99, 100, 101, 1);
    self.HMH_subLab.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:self.HMH_subLab];
    
    //
    self.HMH_openBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_openBtn.frame = CGRectMake(ScreenW / 2 - 50, CGRectGetMaxY(self.HMH_subLab.frame) + 5, 100, 30);
    [self.HMH_openBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.HMH_openBtn setImage:[UIImage imageNamed:@"VC_downOpenImage"] forState:UIControlStateNormal];
//    [self.HMH_openBtn setTitle:@"收起" forState:UIControlStateNormal];
    [self.HMH_openBtn addTarget:self action:@selector(openBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.HMH_openBtn];
}

- (void)openBtnClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(showAllConentBtnClickWithIndex:)]){
        [self.delegate showAllConentBtnClickWithIndex:0];
    }
}

- (void)refreshCellWithModel:(HMHVideoListModel *)model{
    self.HMH_titleLab.text = model.title;
//    self.HMH_zhaiYaoLab.text = model.videoAbstract;
    self.HMH_zhaiYaoLab.text = @"  ";

    self.HMH_subLab.text = model.videoContent;
    
    CGFloat contentHeight = [self getHeightWithFontSize:14.0 with:ScreenW - 20 text:model.videoContent];
    
    if (contentHeight > 40) {
        if (model.isOpenSubTitle) {
            //            contentHeight = contentHeight + 20;
            CGRect subRect = self.HMH_subLab.frame;
            subRect.size.height = contentHeight;
            self.HMH_subLab.frame = subRect;
            
            CGRect btnRect = self.HMH_openBtn.frame;
            btnRect.origin.y = CGRectGetMaxY(self.HMH_subLab.frame);
            self.HMH_openBtn.frame = btnRect;
            
            //            _showAllCommentBtn.y = CGRectGetMaxY(_contentLab.frame);
            [self.HMH_openBtn setImage:[UIImage imageNamed:@"VC_upOpenImage"] forState:UIControlStateNormal];
        } else {
            CGRect subRect = self.HMH_subLab.frame;
            subRect.size.height = 40;
            self.HMH_subLab.frame = subRect;
            
            //            _contentLab.height = 40;
            CGRect btnRect = self.HMH_openBtn.frame;
            btnRect.origin.y = CGRectGetMaxY(self.HMH_subLab.frame);
            self.HMH_openBtn.frame = btnRect;
            
            //            _showAllCommentBtn.y = CGRectGetMaxY(_contentLab.frame);
            [self.HMH_openBtn setImage:[UIImage imageNamed:@"VC_downOpenImage"] forState:UIControlStateNormal];
        }
        self.HMH_openBtn.hidden = NO;
        
    } else {
        if (contentHeight > 20) {
            CGRect subRect = self.HMH_subLab.frame;
            subRect.size.height = 40;
            self.HMH_subLab.frame = subRect;
            //            self.HMH_subLab.height = 40;
        } else {
            CGRect subRect = self.HMH_subLab.frame;
            subRect.size.height = 20;
            self.HMH_subLab.frame = subRect;
            //            self.HMH_subLab.height = 20;
        }
        self.HMH_openBtn.hidden = YES;
    }
}

+(CGFloat)cellHeightWithModel:(HMHVideoListModel *)model{
    NSString *commentStr = model.videoContent;
    
    if (!commentStr || commentStr.length == 0) {
        return 0;
    }
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    CGFloat height = [commentStr boundingRectWithSize:CGSizeMake(ScreenW - 20 , MAXFLOAT)
                                              options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attr
                                              context:nil].size.height;
    
    if (height > 40) {
        if (model.isOpenSubTitle) {
            height = height + 70;
        } else {
            height = 120;
        }
        
    } else {
//        if (height > 20) {
            height = 120 - 40;
//        } else {
//            height = 120 - 20;
//        }
    }
    // 25 为摘要的高度
    return height + 25 ;
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

@end
