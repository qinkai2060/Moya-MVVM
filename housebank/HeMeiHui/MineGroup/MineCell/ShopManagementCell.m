//
//  ShopManagementCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/6/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ShopManagementCell.h"

@implementation ShopManagementCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
      
        [self createSubUI];
        
    }
    return self;
}
- (void)createSubUI {
    _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(20, 13, 20, 20)];
    [self.contentView addSubview:_iconImage];
    
    _nameLable=[[UILabel alloc]initWithFrame:CGRectMake(_iconImage.frame.origin.x+_iconImage.frame.size.width+10, 15, ScreenW-40-10-_iconImage.frame.size.width-20, 15)];
    _nameLable.textColor=HEXCOLOR(0x333333);
    _nameLable.textAlignment=NSTextAlignmentLeft;
    _nameLable.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.contentView addSubview:_nameLable];
    
    _btnImage=[[UIImageView alloc]initWithFrame:CGRectMake(ScreenW-20-15, 15, 15, 15)];
    [_btnImage setImage:[UIImage imageNamed:@"back_light666"]];
    [self.contentView addSubview:_btnImage];
    
    _lineLable=[[UILabel alloc]initWithFrame:CGRectMake(20, self.height-1, ScreenW-40, 1)];
    _lineLable.backgroundColor=HEXCOLOR(0xF5F5F5);
    [self.contentView addSubview:_lineLable];
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
