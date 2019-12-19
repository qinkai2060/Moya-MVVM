//
//  AssembleSubViewTool.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "AssembleSubViewTool.h"
#import "UIView+addGradientLayer.h"
#import "AssembleListTableView.h"

#define SYSTEM_VERSION   [[UIDevice currentDevice].systemVersion floatValue]
//屏幕宽度相对iPhone6屏幕宽度的比例
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

@implementation AssembleSubViewTool

/*弹出拼团规则视图*/
+(void)showReluerSubView:(NSInteger)content activeType:(NSInteger)activeType
{
    NSString *titleLableTex=@"";
    NSString *lable1Text=@"";
    NSString *lable2Text=@"";
    NSString *lable3Text=@"";
    
    if (activeType==1) {//新人团
        titleLableTex=@"新人团规则";
        lable1Text=@"1.参团人员必须是合发的新会员（未在平台有过支付成功记录），团长可以是老会员";
        lable2Text=@"2.拼团成功条件为参加拼团的人数满%ld人（含团长）";
        lable3Text=@"3.在拼团时间结束后，拼团人数未满则拼团失败。";
    }else
    {
        titleLableTex=@"购买团规则";
        lable1Text=@"1.凡合美惠会员都可以参与购买拼团";
        lable2Text=@"2.拼团成功条件为参加拼团的人数满%ld人（含团长）";
        lable3Text=@"3.在拼团时间结束后，拼团人数未满则拼团失败。";
    }
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    aTapGR.numberOfTapsRequired = 1;
    [blackView addGestureRecognizer:aTapGR];
    blackView.alpha=0.6;
    blackView.backgroundColor=[UIColor colorWithHexString:@"0X000000" alpha:1.0];
    blackView.tag = 1000;
    [window addSubview:blackView];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 367+KBottomSafeHeight)];
    shareView.backgroundColor =HEXCOLOR(0xFFFFFF);
    shareView.tag = 1100;
    [window addSubview:shareView];

    UILabel *titleLble=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    titleLble.text=titleLableTex;
    titleLble.font=[UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    titleLble.textAlignment=NSTextAlignmentCenter;
    titleLble.textColor=HEXCOLOR(0x333333);
    [shareView addSubview:titleLble];
    
    UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectZero];
    lable1.text=lable1Text;
    lable1.numberOfLines=0;
    lable1.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    lable1.textAlignment=NSTextAlignmentLeft;
    lable1.textColor=HEXCOLOR(0x333333);
    [shareView addSubview:lable1];
    
    UILabel *lable2=[[UILabel alloc]initWithFrame:CGRectZero];
    lable2.text=[NSString stringWithFormat:@"2.拼团成功条件为参加拼团的人数满%ld人（含团长）",(long)content];
    lable1.numberOfLines=0;
    lable2.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    lable2.textAlignment=NSTextAlignmentLeft;
    lable2.textColor=HEXCOLOR(0x333333);
    [shareView addSubview:lable2];
    
    UILabel *lable3=[[UILabel alloc]initWithFrame:CGRectZero];
    lable3.text=lable3Text;
    lable1.numberOfLines=0;
    lable3.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    lable3.textAlignment=NSTextAlignmentLeft;
    lable3.textColor=HEXCOLOR(0x333333);
    [shareView addSubview:lable3];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(titleLble.mas_bottom)setOffset:18];
    }];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(lable1.mas_bottom)setOffset:DCMargin];
    }];
    [lable3 mas_makeConstraints:^(MASConstraintMaker *make){
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(lable2.mas_bottom)setOffset:DCMargin];
    }];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, shareView.height-50*KWidth_Scale-KBottomSafeHeight+1, shareView.width, 50*KWidth_Scale)];
    //       设置渐变背景色
    [cancleBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [cancleBtn setTitle:@"完成" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    cancleBtn.tag = 1200;
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    blackView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        //        shareView.transform = CGAffineTransformMakeScale(1, 1);
        shareView.frame= CGRectMake(0, ScreenH-367-KBottomSafeHeight, ScreenW, 367+KBottomSafeHeight);
        blackView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
}
/*弹出正在拼团列表*/
+(void)showAssembleListSubView:(id)model
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    aTapGR.numberOfTapsRequired = 1;
    [blackView addGestureRecognizer:aTapGR];
    blackView.alpha=0.6;
    blackView.backgroundColor=[UIColor colorWithHexString:@"0X000000" alpha:1.0];
    blackView.tag = 2000;
    [window addSubview:blackView];
    
    AssembleListTableView *listTableView = [[AssembleListTableView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 417+KBottomSafeHeight)];
    listTableView.openGroupList=model;
    listTableView.backgroundColor =HEXCOLOR(0xFFFFFF);
    listTableView.tag = 2100;
    [window addSubview:listTableView];
    
    UIView* headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    UILabel *headerTitle = [UILabel lableFrame:CGRectMake(30, 0, ScreenW-60, 50) title:@"正在拼团" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:16] textColor:HEXCOLOR(0x333333)];
    headerTitle.textAlignment=NSTextAlignmentCenter;
    [headerView addSubview:headerTitle];
    
    UIButton *clossBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    clossBtn.frame=CGRectMake(ScreenW-30, 18, 15, 15);
    clossBtn.tag=2200;
    [clossBtn setImage:[UIImage imageNamed:@"order_detail_cancel"] forState:UIControlStateNormal];
    [clossBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:clossBtn];
    [listTableView addSubview:headerView];
    
    UIView* footView =[[UIView alloc]initWithFrame:CGRectMake(0, 417+KBottomSafeHeight-67-KBottomSafeHeight, ScreenW, 67)];
    UILabel *footTitle = [UILabel lableFrame:CGRectMake(0, 0, ScreenW, 67) title:@"仅显示5个正在拼团的人" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14] textColor:HEXCOLOR(0x999999)];
    footTitle.textAlignment=NSTextAlignmentCenter;
    [footView addSubview:footTitle];
    [listTableView addSubview:footView];
    //为了弹窗不那么生硬，这里加了个简单的动画
    blackView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        //        shareView.transform = CGAffineTransformMakeScale(1, 1);
        listTableView.frame= CGRectMake(0, ScreenH-417-KBottomSafeHeight, ScreenW, 417+KBottomSafeHeight);
        blackView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
}
+(void)showAssembleStrategySubView:(id)content
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction:)];
    aTapGR.numberOfTapsRequired = 1;
    [blackView addGestureRecognizer:aTapGR];
    blackView.alpha=0.6;
    blackView.backgroundColor=[UIColor colorWithHexString:@"0X000000" alpha:1.0];
    blackView.tag = 3000;
    [window addSubview:blackView];
    
    UIView *shareView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenH, ScreenW, 367+KBottomSafeHeight)];
    shareView.backgroundColor =HEXCOLOR(0xFFFFFF);
    shareView.tag = 3100;
    [window addSubview:shareView];
   
    UILabel *titleLble=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    titleLble.text=@"拼团攻略";
    titleLble.font=[UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    titleLble.textAlignment=NSTextAlignmentCenter;
    titleLble.textColor=HEXCOLOR(0x333333);
    [shareView addSubview:titleLble];
    UITextView *textview=[[UITextView alloc]initWithFrame:CGRectMake(0, 50, ScreenW, 367+KBottomSafeHeight-50-55*KWidth_Scale-KBottomSafeHeight)];
    textview.text=@"何以解忧，唯有拼团！如此低价竟然还全场包邮！合发购商城推出双十一新玩法，血拼到底，史上从未有！合发购拼团是基于社交分享的好友组团购买，获取团购优惠的促销活动。在进入合发app之后，就能看到“限时拼团”图片，点击图片，就能进入拼团界面。快来看看有哪些规则吧！\n拼团产品界面最下角会有两个购买按钮，单独购买价和一键拼团价。【单独购买价】是您单独购买商品的销售价，【一键拼团价】是您参与拼团购买的活动价格。\n进入拼团界面，你可以看到多种拼团分类：折扣团，拉新团。\n首先你需要选择商品开团：点击商品购买，团长（开团且该团第一位支付成功的人）完成支付后，拼团即可开启。在规定活动时间内参团人数（参团成员：通过团长邀请购买该商品的成员即为参团成员，参团成员也可以邀请更多的成员参与。）达到规定人数，此团才算成团。\n1.折扣团定义：合发购商城精选尖货，折上加折！团长开团，邀请好友参团，参团人数达到指定人数之后，团购成功。\n2.新人团定义：开团后，必须邀请新人（未在合发购注册购买过商品的会员）参团，且团购人数到达指定人数，才能获得拉新团商品，或者平台指定商品的超值优惠券。此优惠券在购买指定商品时，可作为现金抵扣。\n团长开团后，可以在app中【我的】界面，【我的团】中查看自己开的或者参与的拼团。点击【查看详情】，就可以把还未满人数的拼团产品分享给好友。\n团购成功：从团长开团开始，到活动时间结束期间，找到相应开团人数的好友参团，团购成功，卖家就会发货。\n凡是成功开团的人都有机会获得合发购商城抽奖机会，神秘奖品震撼来袭！有没有特别激动？！";
    textview.textColor=HEXCOLOR(0x333333);
    textview.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [shareView addSubview:textview];
//    UILabel *lable1=[[UILabel alloc]initWithFrame:CGRectZero];
//    lable1.text=@"1.参团人员必须是合发的新会员（未在平台有过支付成功记录），团长可以是老会员";
//    lable1.numberOfLines=0;
//    lable1.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//    lable1.textAlignment=NSTextAlignmentLeft;
//    lable1.textColor=HEXCOLOR(0x333333);
//    [shareView addSubview:lable1];
//
//    UILabel *lable2=[[UILabel alloc]initWithFrame:CGRectZero];
//    lable2.text=@"2.拼团成功条件为参加拼团的人数满2人（不含团长）";
//    lable1.numberOfLines=0;
//    lable2.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//    lable2.textAlignment=NSTextAlignmentLeft;
//    lable2.textColor=HEXCOLOR(0x333333);
//    [shareView addSubview:lable2];
//
//    UILabel *lable3=[[UILabel alloc]initWithFrame:CGRectZero];
//    lable3.text=@"3.在拼团时间结束后，拼团人数未满则拼团失败。";
//    lable1.numberOfLines=0;
//    lable3.font=[UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
//    lable3.textAlignment=NSTextAlignmentLeft;
//    lable3.textColor=HEXCOLOR(0x333333);
//    [shareView addSubview:lable3];
//    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        [make.left.mas_equalTo(self)setOffset:DCMargin];
//        [make.right.mas_equalTo(self)setOffset:-DCMargin];
//        [make.top.mas_equalTo(titleLble.mas_bottom)setOffset:18];
//    }];
//    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        [make.left.mas_equalTo(self)setOffset:DCMargin];
//        [make.right.mas_equalTo(self)setOffset:-DCMargin];
//        [make.top.mas_equalTo(lable1.mas_bottom)setOffset:DCMargin];
//    }];
//    [lable3 mas_makeConstraints:^(MASConstraintMaker *make){
//        [make.left.mas_equalTo(self)setOffset:DCMargin];
//        [make.right.mas_equalTo(self)setOffset:-DCMargin];
//        [make.top.mas_equalTo(lable2.mas_bottom)setOffset:DCMargin];
//    }];
    
    UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, shareView.height-50*KWidth_Scale-KBottomSafeHeight+1, shareView.width, 50*KWidth_Scale)];
    //       设置渐变背景色
    [cancleBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [cancleBtn setTitle:@"完成" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    cancleBtn.tag = 3200;
    [cancleBtn addTarget:self action:@selector(cancleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:cancleBtn];
    
    //为了弹窗不那么生硬，这里加了个简单的动画
    blackView.alpha = 0;
    [UIView animateWithDuration:0.5f animations:^{
        //        shareView.transform = CGAffineTransformMakeScale(1, 1);
        shareView.frame= CGRectMake(0, ScreenH-367-KBottomSafeHeight, ScreenW, 367+KBottomSafeHeight);
        blackView.alpha = 0.6;
    } completion:^(BOOL finished) {
        
    }];
}
+(void)cancleBtnClick:(UIButton *)btn
    {
          UIWindow *window = [UIApplication sharedApplication].keyWindow;
        switch (btn.tag) {
            case 1200:
//                规则视图
                {
                    UIView *blackView = [window viewWithTag:1000];
                    UIView *shareView = [window viewWithTag:1100];
                    
                    //为了弹窗不那么生硬，这里加了个简单的动画
                    [UIView animateWithDuration:0.5f animations:^{
                        shareView.frame= CGRectMake(0, ScreenH, ScreenW, 367+KBottomSafeHeight);
                        blackView.alpha = 0;
                    } completion:^(BOOL finished) {
                        
                        [shareView removeFromSuperview];
                        [blackView removeFromSuperview];
                    }];
                }
                break;
            case 2200:
            {
                UIView *blackView = [window viewWithTag:2000];
                UIView *listTableView = [window viewWithTag:2100];
                
                //为了弹窗不那么生硬，这里加了个简单的动画
                [UIView animateWithDuration:0.35f animations:^{
                    listTableView.frame= CGRectMake(0, ScreenH, ScreenW, 417+KBottomSafeHeight);
                    blackView.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    [listTableView removeFromSuperview];
                    [blackView removeFromSuperview];
                }];
            }
                break;
            case 3200:
            {
                UIView *blackView = [window viewWithTag:3000];
                UIView *listTableView = [window viewWithTag:3100];
                
                //为了弹窗不那么生硬，这里加了个简单的动画
                [UIView animateWithDuration:0.35f animations:^{
                    listTableView.frame= CGRectMake(0, ScreenH, ScreenW, 417+KBottomSafeHeight);
                    blackView.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    [listTableView removeFromSuperview];
                    [blackView removeFromSuperview];
                }];
            }
                break;
                
            default:
                break;
        }
        
}
+(void)tapGRAction:(UITapGestureRecognizer*)gesture
    {
         UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIView *view=gesture.view;
        switch (view.tag) {
            case 1000:
                {
                    UIView *blackView = [window viewWithTag:1000];
                    UIView *shareView = [window viewWithTag:1100];
                    
                    //为了弹窗不那么生硬，这里加了个简单的动画
                    [UIView animateWithDuration:0.35f animations:^{
                        shareView.frame= CGRectMake(0, ScreenH, ScreenW, 367+KBottomSafeHeight);
                        blackView.alpha = 0;
                    } completion:^(BOOL finished) {
                        
                        [shareView removeFromSuperview];
                        [blackView removeFromSuperview];
                    }];
                }
                break;
            case 2000:
            {
                UIView *blackView = [window viewWithTag:2000];
                UIView *listTableView = [window viewWithTag:2100];
                
                //为了弹窗不那么生硬，这里加了个简单的动画
                [UIView animateWithDuration:0.35f animations:^{
                    listTableView.frame= CGRectMake(0, ScreenH, ScreenW, 417+KBottomSafeHeight);
                    blackView.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    [listTableView removeFromSuperview];
                    [blackView removeFromSuperview];
                }];
            }
                break;
            case 3000:
            {
                UIView *blackView = [window viewWithTag:3000];
                UIView *listTableView = [window viewWithTag:3100];
                
                //为了弹窗不那么生硬，这里加了个简单的动画
                [UIView animateWithDuration:0.35f animations:^{
                    listTableView.frame= CGRectMake(0, ScreenH, ScreenW, 417+KBottomSafeHeight);
                    blackView.alpha = 0;
                } completion:^(BOOL finished) {
                    
                    [listTableView removeFromSuperview];
                    [blackView removeFromSuperview];
                }];
            }
                break;
                
            default:
                break;
        }
       
     
    }


@end
