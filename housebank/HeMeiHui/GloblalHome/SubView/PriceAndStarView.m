//
//  PriceAndStarView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/12.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "PriceAndStarView.h"

@implementation PriceAndStarView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
              [self initView];
    }
    
    return self;
}
-(void)initView
{
    NSString *text1=@"价格/星级";
    self.contionLable=[MyUtil createLabelFrame:CGRectMake(20,15, ScreenW-60, 20) text:text1 font:[UIFont systemFontOfSize:14] textAlignment:NSTextAlignmentLeft];
    self.contionLable.textColor=HEXCOLOR(0xCCCCCC);
    [self addSubview:self.contionLable];
    //    箭头
    UIButton *indicateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    indicateBtn.frame=CGRectMake(ScreenW-20-15, 18, 15, 15);
    [indicateBtn setImage:[UIImage imageNamed:@"order_detail_arrow"] forState:UIControlStateNormal];
//    [indicateBtn setTitle:@">" forState:UIControlStateNormal];
//    [indicateBtn setTitleColor:HEXCOLOR(0xD8D8D8) forState:UIControlStateNormal];
    [self addSubview:indicateBtn];
    //    下划线
    UILabel *lineLable=[MyUtil createLabelFrame:CGRectMake(20, self.height-1, ScreenW-40,1) text:@"" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter];
    lineLable.backgroundColor=HEXCOLOR(0xEAEAEA);
    [self addSubview:lineLable];
}
//计算宽度
- (CGFloat)calculateRowWidth:(NSString*)string height:(CGFloat)height font:(CGFloat)font {
    NSDictionary *dic =@{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGRect rect =[string boundingRectWithSize:CGSizeMake(0,height)/*计算宽度时要确定高度*/options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
