//
//  AssembleListCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleListCell.h"
#import "UIView+addGradientLayer.h"
@implementation AssembleListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    // 头像
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.image=[UIImage imageNamed:@"icon_image"];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius =15;
    [self addSubview:_iconImageView];
    //    标题
    _nameLabel = [UILabel lableFrame:CGRectZero title:@"傅秀平" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15] textColor:HEXCOLOR(0x333333)];
    [self addSubview:_nameLabel];
    //    名称
    //     (NSMutableAttributedString *)setupAttributeString:(NSString *)text rangeText:(NSString *)rangeText textColor:(UIColor *)color
    
    _contentLabel = [UILabel lableFrame:CGRectZero title:@"还差1人成团" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:15] textColor:HEXCOLOR(0x333333)];
    NSMutableAttributedString *setLineStr = [NSMutableAttributedString  setupAttributeString:@"还差1人成团" rangeText:@"1人" textColor:HEXCOLOR(0xF3344A)];
    _contentLabel.attributedText=setLineStr;
    [self addSubview:_contentLabel];
    //   去参团
    _goGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goGroupBtn.bounds=CGRectMake(0, 0, 70, 25);
    _goGroupBtn.tag=102;
    [_goGroupBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //       设置渐变背景色
    [_goGroupBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [_goGroupBtn setTitle:@"去参团" forState:UIControlStateNormal];
    _goGroupBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_goGroupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _goGroupBtn.layer.cornerRadius = _goGroupBtn.height/2;
    _goGroupBtn.userInteractionEnabled=NO;
    _goGroupBtn.layer.masksToBounds = YES;
    [self addSubview:_goGroupBtn];
    //    分割线
    _spaceLabe = [UILabel lableFrame:CGRectZero title:@"" backgroundColor:HEXCOLOR(0xF5F5F5) font:[UIFont systemFontOfSize:14] textColor:HEXCOLOR(0x333333)];
    [self addSubview:_spaceLabe];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin];
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make){
        [make.left.mas_equalTo(_iconImageView.mas_right)setOffset:DCMargin-5];
        [make.top.mas_equalTo(self)setOffset:DCMargin+5];
    }];
    [_goGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(self)setOffset:17];
        make.size.mas_equalTo(CGSizeMake(70, 25));
        
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(_goGroupBtn.mas_left)setOffset:-DCMargin];
        [make.top.mas_equalTo(self)setOffset:DCMargin+5];
    }];
    
    [_spaceLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:15];
        [make.right.mas_equalTo(self)setOffset:-15];
        make.height.mas_equalTo(1);
        [make.bottom.mas_equalTo(self.mas_bottom)setOffset:-1];
    }];
    
}

//fuzhi
- (void)reSetSelectedData:(OpenGroupListItem*)model
{

   
    [_iconImageView sd_setImageWithURL:[model.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    _nameLabel.text=model.nickname;
    NSInteger count=model.activeNum- model.groupNum;
    NSString *str1=[NSString stringWithFormat:@"还差%ld人成团",(long)count];
    NSString *str2=[NSString stringWithFormat:@"%ld人",(long)count];
    NSMutableAttributedString *setLineStr = [NSMutableAttributedString  setupAttributeString:str1 rangeText:str2 textColor:HEXCOLOR(0xF3344A)];
    _contentLabel.attributedText=setLineStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
