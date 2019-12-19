//
//  SpTypesSearchFooterView.m
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesSearchFooterView.h"
#import "CustomPasswordAlter.h"
@implementation SpTypesSearchFooterView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.frame.size.width / 2 - 100, 0, 200, 40);
    
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor =RGBACOLOR(221, 221, 221, 1).CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 20;
    
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btn setTitleColor:RGBACOLOR(51, 51, 51, 1) forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"SpTypes_search_delete"] forState:UIControlStateNormal];
    [btn setTitle:@" 清空历史搜索" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clearEventAlter:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}
- (void)clearEventAlter:(UIButton *)btn{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [CustomPasswordAlter showCustomPasswordAlterViewViewIn:[[UIApplication sharedApplication] keyWindow] title:@"确认删除全部历史记录?" suret:@"确定" closet:@"取消" sureblock:^{
        [self deleteBtnClick:btn];
    } closeblock:^{
        
    }];
}
- (void)deleteBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(deleteSearchFooterViewWithBtn:)]) {
        [self.delegate deleteSearchFooterViewWithBtn:btn];
    }
}

@end
