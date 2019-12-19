//
//  LocationView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/12.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "LocationView.h"

@implementation LocationView
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

    self.positionLable=[MyUtil createLabelFrame:CGRectMake(20, 23, ScreenW-100, 20) text:@"上海" font:[UIFont systemFontOfSize:16] textAlignment:NSTextAlignmentLeft];
    self.positionLable.textColor=HEXCOLOR(0x333333);
    [self addSubview:self.positionLable];
    
    _subView=[[UIView alloc]initWithFrame:CGRectMake(ScreenW-100, 0, 100, self.height)];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
    aTapGR.numberOfTapsRequired = 1;
    [_subView addGestureRecognizer:aTapGR];
    [self addSubview:_subView];
    
    UIButton *button=[MyUtil createBtnFrame:CGRectMake(_subView.width-32-19, 15, 19, 19) imageName:@"Group" selectImageName:@"" target:nil action:nil];
    button.userInteractionEnabled=NO;
    [_subView addSubview:button];
    
    UILabel *btnTitleLable=[MyUtil createLabelFrame:CGRectMake(0, 34, 60, 20) text:@"我的位置" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter];
    btnTitleLable.centerX=button.centerX;
    btnTitleLable.textColor=HEXCOLOR(0xFA8C1D);
    btnTitleLable.userInteractionEnabled=NO;
    [_subView addSubview:btnTitleLable];
    
    UILabel *lineLable=[MyUtil createLabelFrame:CGRectMake(20, self.height-1, ScreenW-40,1) text:@"" font:[UIFont systemFontOfSize:11] textAlignment:NSTextAlignmentCenter];
    lineLable.backgroundColor=HEXCOLOR(0xEAEAEA);
    [self addSubview:lineLable];
}
//手势
-(void)tapGRAction
{
    
    [self.delegate didUpdateLocations];
    

}


@end
