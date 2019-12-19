//
//  UserOrderCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "UserOrderCell.h"

@implementation UserOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubUI];
    }
    return self;
}
- (void)createSubUI {
     NSArray *nameArray=@[@"待付款",@"待发货",@"待收货",@"评价",@"退货退款"];
     NSArray *imageArray=@[@"待付款",@"待发货",@"待收货",@"评价",@"退货退款"];
    for (int i=0; i<nameArray.count; i++) {
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenW/5 *i, 0,ScreenW/5, 50);
        btn.tag=100+i;
        [btn setImage:[UIImage imageNamed:[imageArray objectAtIndex:i]] forState:UIControlStateNormal];
        [btn setTitle:[nameArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        CGSize titleSize = btn.titleLabel.intrinsicContentSize;
        CGSize imageSize = btn.imageView.bounds.size;
        CGFloat interval = 1.0;
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
        {//待付款
            if (self.clikBlock) {
                self.clikBlock(UserOrderCellClickTypePendingPayment);
            }
        }
            break;
        case 101:
        {//待发货
            if (self.clikBlock) {
                self.clikBlock(UserOrderCellClickTypeToBeShipped);
            }
        }
            break;
        case 102:
        {//待收货
            if (self.clikBlock) {
                self.clikBlock(UserOrderCellClickTypeGoodsReceived);
            }
        }
            break;
        case 103:
        {//评价
            if (self.clikBlock) {
                self.clikBlock(UserOrderCellClickTypeGrade);
            }
        }
            break;
        case 104:
        {//退货退款
            if (self.clikBlock) {
                self.clikBlock(UserOrderCellClickTypeRefund);
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
