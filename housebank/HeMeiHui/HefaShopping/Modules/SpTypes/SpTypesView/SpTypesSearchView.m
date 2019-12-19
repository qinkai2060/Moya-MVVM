//
//  CategorySearchView.m
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesSearchView.h"

@interface SpTypesSearchView ()<UITextFieldDelegate>

// 最右侧是否有按钮
@property (nonatomic, assign) BOOL isAddBtn;
@property (nonatomic, strong) NSString *addBtnImageName;
@property (nonatomic, strong) NSString *addBtnTitle;

@property (nonatomic, assign) BOOL isCanEdit;

// 是否有返回按钮
@property (nonatomic, assign) BOOL isHaveBack;
// 是否有底部的分割线
@property (nonatomic, assign) BOOL isHaveBottomLine;

//
@property (nonatomic, strong) NSString *searchKeyStr;

@property (nonatomic, strong) NSString *placeholderStr;

@end

@implementation SpTypesSearchView

- (instancetype)initWithFrame:(CGRect)frame isAddOneBtn:(BOOL)addOneBtn addBtnImageName:(NSString *)imageName addBtnTitle:(NSString *)addBtnTitle searchKeyStr:(NSString *)searchKeyStr canEidt:(BOOL)canEdit placeholderStr:(nonnull NSString *)placeholderStr isHaveBack:(BOOL)isHaveBack isHaveBottomLine:(BOOL)isHaveBottomLine{
    self = [super initWithFrame:frame];
    if (self) {
        self.isAddBtn = addOneBtn;
        self.addBtnImageName = imageName;
        self.addBtnTitle = addBtnTitle;
        self.searchKeyStr = searchKeyStr;
        self.isCanEdit = canEdit;
        self.placeholderStr = placeholderStr;
        self.isHaveBack = isHaveBack;
        self.isHaveBottomLine = isHaveBottomLine;
        
        [self createNav];
    }
    return self;
}

-(void)createNav{
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
    navView.backgroundColor = [UIColor whiteColor];
    [self addSubview:navView];
    //
    UIView *bgView = [[UIView alloc] init];
    if (self.isAddBtn) {
        if (self.isHaveBack) { // 判断是否有返回按钮
            bgView.frame = CGRectMake(40, 7, ScreenW - 60 - 30, 30);
        } else {
            bgView.frame = CGRectMake(10, 7, ScreenW - 60 - 30 + 30, 30);
        }
    } else {
        if (self.isHaveBack) { // 判断是否有返回按钮
            bgView.frame = CGRectMake(40, 7, ScreenW - 60, 30);
        } else {
            bgView.frame = CGRectMake(10, 7, ScreenW - 60 + 30, 30);
        }
    }
    bgView.backgroundColor = RGBACOLOR(233, 234, 235, 1);
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = bgView.frame.size.height / 2;
    [navView addSubview:bgView];
    //
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height / 2 - 7.5, 15, 15)];
    img.image = [UIImage imageNamed:@"VH_videoSearch"];
    [bgView addSubview:img];
    
    _backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //    backButton.frame=CGRectMake(0, 20, 60, 44);
    _backButton.frame=CGRectMake(0, 0, 60, 44);
    
    [_backButton addTarget:self action:@selector(gotoBack) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *backImageView=[[UIImageView alloc] initWithFrame:CGRectMake(11, 11, 20, 20)];
    backImageView.image=[UIImage imageNamed:@"HMH_categoty_black_back"];
    [_backButton addSubview:backImageView];
    
    if (self.isHaveBack) { // 判断是否有返回按钮
        [navView addSubview:_backButton];
    }
    
    self.searchTextField.frame = CGRectMake(35,0, bgView.frame.size.width - 35, bgView.frame.size.height);
   
    if (self.isCanEdit) {
        self.searchTextField.enabled = YES;
        [self.searchTextField becomeFirstResponder];
    } else {
        self.searchTextField.enabled = NO;
    }
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    if (self.searchKeyStr.length > 0) {
        self.searchTextField.text = self.searchKeyStr;
        self.searchTextField.clearButtonMode =  UITextFieldViewModeAlways;
    }else {
         self.searchTextField.clearButtonMode =  UITextFieldViewModeNever;
        if (self.placeholderStr.length > 0) {
            self.searchTextField.placeholder = self.placeholderStr;
        } else {
            self.searchTextField.placeholder = @"请输入搜索内容";
        }
    }
    [bgView addSubview:self.searchTextField];
    //
    @weakify(self)
    [[self.searchTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        if (x.length >0 ) {
             self.searchTextField.clearButtonMode =  UITextFieldViewModeAlways;
        }else {
            self.searchTextField.clearButtonMode =  UITextFieldViewModeNever;
        }
    }];
    _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchBtn.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    _searchBtn.backgroundColor = [UIColor clearColor];
    [_searchBtn addTarget:self action:@selector(searchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (!self.isCanEdit) {
        [bgView addSubview:_searchBtn];
    }     
    if (self.isAddBtn) {
        UIButton *addRightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        //    rightButton2.frame=CGRectMake(_navView.frame.size.width-35 - 35, rightButton1.frame.origin.y, 30, 30);
        addRightBtn.frame=CGRectMake(navView.frame.size.width - 45, bgView.frame.origin.y, 40, 30);
        
        [addRightBtn setTitleColor:RGBACOLOR(73,73,75,1)forState:UIControlStateNormal];
        if (self.addBtnTitle.length > 0) {
            [addRightBtn setTitle:self.addBtnTitle forState:UIControlStateNormal];
            addRightBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        if (self.addBtnImageName.length > 0) {
            [addRightBtn setImage:[UIImage imageNamed:self.addBtnImageName] forState:UIControlStateNormal];
        }

        addRightBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [addRightBtn addTarget:self action:@selector(addRightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:addRightBtn];
    }
    //
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, navView.frame.size.height - 1, navView.frame.size.width, 1)];
    bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
    if (self.isHaveBottomLine) {
        [navView addSubview:bottomLab];
    }
}

// 返回按钮
- (void)gotoBack{
    if ([self.delegate respondsToSelector:@selector(backBtnClick)]) {
        [self.delegate backBtnClick];
    }
}

// 搜索按钮
- (void)searchBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(searchBtnClick)]) {
        [self.delegate searchBtnClick];
    }
}

// 右侧按钮的点击事件
- (void)addRightBtnClick:(UIButton *)btn{
    if (self.searchRightBtnClickBlock) {
        self.searchRightBtnClickBlock(btn);
    }
//    if ([self.delegate respondsToSelector:@selector(searchRightBtnClick:)]){
//        [self.delegate searchRightBtnClick:btn];
//    }
}

- (SpeakTextField *)searchTextField {
    if(!_searchTextField) {
        _searchTextField = [[SpeakTextField alloc]initWithFrame:CGRectZero canAddVoice:YES];
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.font = [UIFont systemFontOfSize:14.0];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        
  
    }
    return _searchTextField;
}
@end
