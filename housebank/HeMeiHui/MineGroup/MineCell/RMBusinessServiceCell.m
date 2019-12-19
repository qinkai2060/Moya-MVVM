//
//  RMBusinessServiceCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "RMBusinessServiceCell.h"

@implementation RMBusinessServiceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //            1、商城店铺入驻（不是合发购商家）/商城店铺管理（合发够商家）
        //            2、注册RM门店（免费会员）/新零售店铺管理（RM会员或者新零售商家）
        //            3、全球家店铺管理/没有（有没有全球家）
        //            4、注册街镇代（RM高级会员）/我的街镇代（街镇代会员）
        _nameArray=[[NSMutableArray alloc]init];
        _imageArray=[[NSMutableArray alloc]init];
//        [_nameArray addObjectsFromArray:@[@"合发购店铺入驻",@"注册RM门店"]];
//         [_imageArray addObjectsFromArray:@[@"合法购店铺",@"新零售店铺"]];
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
//赋值操作
- (void)refreshCellWithModel:(CheckShopsModel*)checkShopsModel withUserInfo:(UserInfoModel*)userInfoModel objectAtIndex:(NSInteger)indexPath
{
    [_nameArray removeAllObjects];
    [_imageArray removeAllObjects];
    NSString *name1=@"";    NSString *name2=@"";    NSString *name3=@"";    NSString *name4=@"";
    NSString *image1=@"";    NSString *image2=@"";    NSString *image3=@"";    NSString *image4=@"";
    //            1、商城店铺入驻（不是合发购商家）/商城店铺管理（合发够商家）
    //            2、注册RM门店（有新零售店铺但是不是RMz或者普通会员不是RM）
    //            3、新零售店铺管理/没有（RM会员或者新零售商家）
    //            4、全球家店铺管理/没有（有没有全球家）
    //            5、注册街镇代/没有（RM高级会员）/我的街镇代（街镇代会员）
    //显示全球家店铺
    
    if (checkShopsModel.data.isHfShops) {
//        有合发购物店铺
        if (checkShopsModel.data.hfShopsState==0||checkShopsModel.data.hfShopsState==4) {
            name1=@"商城店铺入驻";
            image1=@"合法购店铺";
            [_nameArray addObject:name1];
            [_imageArray addObject:image1];
        }else
        {
            name1=@"商城店铺管理";
            image1=@"合法购店铺";
            [_nameArray addObject:name1];
            [_imageArray addObject:image1];
        }
       
    }else
    {
        name1=@"商城店铺入驻";
        image1=@"合法购店铺";
        [_nameArray addObject:name1];
        [_imageArray addObject:image1];
    }
    if (checkShopsModel.data.RMGrade<=1) {
      
        name2=@"注册RM门店";
        image2=@"新零售店铺";
        [_nameArray addObject:name2];
        [_imageArray addObject:image2];
        if (checkShopsModel.data.isOtoShops) {
            name2=@"新零售店铺管理";
            image2=@"新零售店铺";
            [_nameArray addObject:name2];
            [_imageArray addObject:image2];
        }
        
    }else
    {
        name2=@"新零售店铺管理";
        image2=@"新零售店铺";
        [_nameArray addObject:name2];
        [_imageArray addObject:image2];
    }
   
    if(userInfoModel && userInfoModel.data.userCenterInfo.memberLevel>=6) {
//        有全球家店铺
        name3=@"全球家店铺管理";
        image3=@"全球家店铺";
        [_nameArray addObject:name3];
        [_imageArray addObject:image3];
    }
 
 
    if (checkShopsModel.data.RMGrade==4||checkShopsModel.data.agentWhite==1){
        if (checkShopsModel.data.RMAgent== 2 || checkShopsModel.data.RMAgent== 4 || checkShopsModel.data.RMAgent== 5 || checkShopsModel.data.RMAgent== 7 || checkShopsModel.data.RMAgent== 8)
        {//注册街镇代
            name4=@"注册街镇代";
            image4=@"注册街镇代";
            [_nameArray addObject:name4];
            [_imageArray addObject:image4];
          
        }else
        {//我的街镇代
            name4=@"我的街镇代";
            image4=@"注册街镇代";
            [_nameArray addObject:name4];
            [_imageArray addObject:image4];
        }
        
    }
    [_iconImage setImage:[UIImage imageNamed:[_imageArray objectAtIndex:indexPath]]];
    _nameLable.text=[_nameArray objectAtIndex:indexPath];
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
