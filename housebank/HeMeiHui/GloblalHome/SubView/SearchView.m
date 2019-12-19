//
//  searchView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/12.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SearchView.h"
@interface SearchView ()<UITextFieldDelegate>

@end
@implementation SearchView
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
//    搜索输入框
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(20,0,self.width, self.height)];
    self.searchTextField.backgroundColor = [UIColor clearColor];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.placeholder = @"关键字/地址/酒店";
    self.searchTextField.userInteractionEnabled=NO;
    self.searchTextField.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:self.searchTextField];
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.searchTextField.text.length == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请输入搜索内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return YES;
    }
    return YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
