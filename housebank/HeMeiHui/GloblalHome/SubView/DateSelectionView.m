//
//  DateSelectionView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/12.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "DateSelectionView.h"

@implementation DateSelectionView
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
    UILabel *lable1=[MyUtil createLabelFrame:CGRectMake(20, 15, 60, 16) text:@"入住日期" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft];
    lable1.textColor=HEXCOLOR(0x333333);
    [self addSubview:lable1];
  
    
    UILabel *lable3=[MyUtil createLabelFrame:CGRectMake(0, 54, 45, 1) text:@"" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft];
    lable3.centerX=self.centerX;
    lable3.backgroundColor=HEXCOLOR(0xFA8C1D);
    [self addSubview:lable3];
    
    NSString *text1=@"08月231日";
    NSString *text2=@"04月261日";
    NSString *text3=@"今天";
    NSString *text4=@"明天";
    NSString *text5=@"共365天";
    //入住日期
    self.checkInDate=[MyUtil createLabelFrame:CGRectMake(20, 36, [self calculateRowWidth:text1 height:20 font:16], 20) text:text1 font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft];
     self.checkInDate.textColor=HEXCOLOR(0x333333);
    [self addSubview:self.checkInDate];
    //今天
    self.checkInDateTag=[MyUtil createLabelFrame:CGRectMake(CGRectGetMaxX(self.checkInDate.frame)+5, 40, [self calculateRowWidth:text3 height:15 font:12], 15) text:text3 font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft];
     self.checkInDateTag.textColor=HEXCOLOR(0x333333);
    [self addSubview:self.checkInDateTag];
    
    //离店日期
    self.departureDate=[MyUtil createLabelFrame:CGRectMake(ScreenW-51-[self calculateRowWidth:text2 height:20 font:16], 36, [self calculateRowWidth:text2 height:20 font:16], 20) text:text1 font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft];
     self.departureDate.textColor=HEXCOLOR(0x333333);
     [self addSubview:self.departureDate];
    //离店日期
    UILabel *lable2=[MyUtil createLabelFrame:CGRectMake(ScreenW-51-[self calculateRowWidth:text2 height:20 font:16], 15, 60, 16) text:@"离店日期" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentLeft];
    lable2.textColor=HEXCOLOR(0x333333);
    [self addSubview:lable2];
    //明天
    self.departureDateTag=[MyUtil createLabelFrame:CGRectMake(CGRectGetMaxX(self.departureDate.frame)+5, 40, [self calculateRowWidth:text4 height:15 font:12], 15) text:text4 font:[UIFont systemFontOfSize:12] textAlignment:NSTextAlignmentLeft];
    self.departureDateTag.textColor=HEXCOLOR(0x333333);
    [self addSubview:self.departureDateTag];
    //共多少夜晚
    self.nightsNum=[MyUtil createLabelFrame:CGRectMake(0, 38,[self calculateRowWidth:text5 height:15 font:11] , 15) text:text5 font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter];
    self.nightsNum.centerX=self.centerX;
    self.nightsNum.textColor=HEXCOLOR(0x333333);
    [self addSubview:self.nightsNum];
//    下划线
    UILabel *lineLable=[MyUtil createLabelFrame:CGRectMake(20, self.height-1, ScreenW-40,1) text:@"" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter];
    lineLable.backgroundColor=HEXCOLOR(0xEAEAEA);
    [self addSubview:lineLable];
//    @property(nonatomic,strong) UILabel *checkInDate;//入住日期
//    @property(nonatomic,strong) UILabel *departureDate;//离店日期
//    @property(nonatomic,strong) UILabel *nightsNum;//总共天数
//    @property(nonatomic,strong) UILabel *checkInDateTag;//今天
//    @property(nonatomic,strong) UILabel *departureDateTag;//明天
    
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
