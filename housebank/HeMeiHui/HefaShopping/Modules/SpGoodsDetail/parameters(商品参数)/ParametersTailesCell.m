//
//  ParametersTailesCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "ParametersTailesCell.h"

@implementation ParametersTailesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCommentView];
    }
    return self;
}
- (void)createCommentView{
    /* 分类*/
    _titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 15, 70, 15)];
    _titleLab.font=PFR15Font;
    _titleLab.textColor=HEXCOLOR(0x333333);
    _titleLab.text=@"";
    _titleLab.numberOfLines=0;
    [self.contentView addSubview:_titleLab];
 
//    /* 分割线 */
//    @property (strong , nonatomic)UILabel *lineLabel;
    /* 内容 */
    _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(_titleLab.rightX+30, 15, ScreenW-130, 15)];
    _contentLabel.font=PFR15Font;
    _contentLabel.textColor=HEXCOLOR(0x333333);
    _contentLabel.text=@"";
    _contentLabel.numberOfLines=0;
    [self.contentView addSubview:_contentLabel];
  
    
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
