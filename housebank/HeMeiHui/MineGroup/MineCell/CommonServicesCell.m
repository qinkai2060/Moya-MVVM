//
//  CommonServicesCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "CommonServicesCell.h"

@implementation CommonServicesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _nameArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"购买门票"];
        _imageArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"menpiao"];
         [self createSubUI];
    }
    return self;
}

//显示赋值
- (void)refreshCellWithModel:(CheckShopsModel*)model
{
    NSArray *subviews = [[NSArray alloc] initWithArray:self.subviews];
    
    for (UIView *subview in subviews) {
        
        [subview removeFromSuperview];
        
    }
    if (model.data.RMGrade==1) {//免费会员
        _nameArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"购买门票"];
        _imageArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"menpiao"];
    }else if (model.data.RMGrade==4)//高级
    {
        _nameArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"购买门票",@"销售线索",@"邀请RM",@"代理商品",@"福利商品"];
        _imageArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"menpiao",@"销售线索",@"邀请RM",@"代理商品",@"福利商品"];
    }else if (model.data.RMGrade==2||model.data.RMGrade==3)
    {//初级。中级
        _nameArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"购买门票",@"销售线索",@"邀请RM",@"代理商品",@"福利商品",@"升级RM"];
        _imageArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"menpiao",@"销售线索",@"邀请RM",@"代理商品",@"福利商品",@"升级RM"];
    }else
    {
        _nameArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"购买门票"];
        _imageArray=@[@"我的收藏",@"邀请好友",@"通讯录邀约",@"银行卡管理",@"地址管理",@"我的团购",@"menpiao"];
    }
     [self createSubUI];
}
- (void)createSubUI {
    for (int i=0; i<_nameArray.count; i++) {
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenW/4 *(i%4), (45+20) *(i/4),ScreenW/4, 45);
        btn.tag=100+i;
        [btn setImage:[UIImage imageNamed:[_imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setTitle:[_nameArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        CGSize titleSize = btn.titleLabel.intrinsicContentSize;
        CGSize imageSize = btn.imageView.bounds.size;
        CGFloat interval = 2.0;
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0,0, titleSize.height + interval, -(titleSize.width + interval))];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(imageSize.height + interval, -(imageSize.width + interval), 0, 0)];
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
-(void)buttonClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 100:
        {//我的收藏
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeMyCollection);
            }
        }
            break;
        case 101:
        {//邀请好友
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeInviteFriends);
            }
        }
            break;
        case 102:
        {//通讯邀约
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeMailList);
            }
        }
            break;
        case 103:
        {//银行卡管理
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeBankCard);
            }
        }
            break;
        case 104:
        {//地址管理
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeAddressManagement);
            }
        }
            break;
        case 105:
        {//我的团购
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeGroupBuy);
            }
        }
            break;
        case 106:
        {//购买门票
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeBuyTickets);
            }
        }
            break;
        case 107:
        {//销售线索
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeSalesLeads);
            }
        }
            break;
        case 108:
        {//邀请RM
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeInviteRM);
            }
        }
            break;
        case 109:
        {//代理商品
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeAgencyGoods);
            }
        }
            break;
        case 110:
        {//福利商品
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeWelfareGoods);
            }
        }
            break;
        case 111:
        {//升级RM
            if (self.clickBlock) {
                self.clickBlock(CommonServicesViewTypeUpgradeRM);
            }
        }
            break;
            
        default:
            break;
    }
    
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
