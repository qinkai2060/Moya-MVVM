//
//  HMHSearchHistoryListTableViewCell.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHSearchHistoryListTableViewCell.h"

@interface HMHSearchHistoryListTableViewCell ()

@property (nonatomic, strong) UILabel *searchLab;

@end

@implementation HMHSearchHistoryListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //
    UIImageView *timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
    timeImage.image = [UIImage imageNamed:@"VS_videoHistory"];
    [self.contentView addSubview:timeImage];
    
    //
    self.searchLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timeImage.frame) + 5, 0, ScreenW - CGRectGetMaxX(timeImage.frame) - 20 - 30, self.frame.size.height - 1)];
    self.searchLab.font = [UIFont systemFontOfSize:14.0];
    self.searchLab.textColor = RGBACOLOR(73, 73, 75, 1);
    [self.contentView addSubview:self.searchLab];
    
    //
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(ScreenW - 10 - 30, 0, 30, self.frame.size.height);
    [cancelBtn setImage:[UIImage imageNamed:@"VS_closeImage"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:cancelBtn];
    
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, ScreenW, 1)];
    lineLab.backgroundColor = RGBACOLOR(239, 240, 241, 1);
    [self.contentView addSubview:lineLab];
}

- (void)refreshCellWithSearchStr:(NSString *)searchStr{
    self.searchLab.text = searchStr;
}

// 删除按钮的点击事件
- (void)cancelBtnClick:(UIButton *)btn{
    if (self.cancelBtnClickBlock) {
        self.cancelBtnClickBlock(self);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
