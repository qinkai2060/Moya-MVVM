

//
//  VIPGiftSelectHeadView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/9/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VIPGiftSelectHeadView.h"
#import "VipGiftShopModel.h"
#define MAXCount 6
@interface VIPGiftSelectHeadView ()
@property (nonatomic, strong) UIImageView * selectHeadImage;
@property (nonatomic, strong) UIButton * firstBtn;
@property (nonatomic, strong) UIButton * secondBtn;
@property (nonatomic, strong) UIButton * thirdBtn;
@property (nonatomic, assign) NSInteger  section;
@property (nonatomic, copy)   NSString  * sectionSting;
@property (nonatomic, strong) NSArray <VipGiftShopModel *> * sectionArray;
@end
@implementation VIPGiftSelectHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#100700"];
        [self addSubview:self.selectHeadImage];
        [self.selectHeadImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@55);
        }];
        self.selectHeadImage.image = [UIImage imageNamed:@"levelTitle_01"];
        
        [self addSubview:self.firstBtn];
        [self addSubview:self.secondBtn];
        [self addSubview:self.thirdBtn];
        [self.firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectHeadImage.mas_bottom).offset(4);
            make.left.equalTo(self).offset(15);
            make.width.equalTo(self.secondBtn);
            make.right.equalTo(self.secondBtn.mas_left).offset(-10);
            make.height.equalTo(@25);
        }];
        
        [self.secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstBtn);
            make.left.equalTo(self.firstBtn.mas_right).offset(10);
            make.height.equalTo(self.firstBtn);
            make.width.equalTo(self.thirdBtn);
            make.right.equalTo(self.thirdBtn.mas_left).offset(-15);
        }];
        
        [self.thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstBtn);
            make.left.equalTo(self.secondBtn.mas_right).offset(15);
            make.height.width.equalTo(self.firstBtn);
            make.right.equalTo(self).offset(-15);
        }];

        [self bindRAC];
    }
    return self;
}

- (void)bindRAC {
    @weakify(self);
    [[self.firstBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.callHeadBlock) {
            self.callHeadBlock(0, self.sectionSting,self.section);
        }
    }];
    [[self.secondBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.callHeadBlock) {
            self.callHeadBlock(1, self.sectionSting,self.section);
        }
    }];
    [[self.thirdBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.callHeadBlock) {
            self.callHeadBlock(2, self.sectionSting,self.section);
        }
    }];
}

- (NSURL *)getImageURLWithImageString:(NSString *)string {
    NSString *url = [NSString stringWithFormat:@"https://m.hfhomes.cn/images/vip/%@.jpg",string];
    return [NSURL URLWithString:url];
}

- (void)setUpHeadDataSource:(NSDictionary *)headDic index:(NSInteger)path heightBlock:(nonnull void (^)(CGFloat))block {
    /** 取字典的keys*/
    NSString *keyValue = headDic.allKeys[0];
    if ([keyValue isEqualToString:@"silverArray"]) {
//        [self.selectHeadImage setImage:[UIImage imageNamed:@"levelTitle_01"]];
        [self.selectHeadImage sd_setImageWithURL:[self getImageURLWithImageString:@"levelTitle_01"]];
    }else if ([keyValue isEqualToString:@"platinumArray"]){
//        [self.selectHeadImage setImage:[UIImage imageNamed:@"levelTitle_02"]];
        [self.selectHeadImage sd_setImageWithURL:[self getImageURLWithImageString:@"levelTitle_02"]];
    }else if ([keyValue isEqualToString:@"diamondsArray"]){
        [self.selectHeadImage sd_setImageWithURL:[self getImageURLWithImageString:@"levelTitle_03"]];
//        [self.selectHeadImage setImage:[UIImage imageNamed:@"levelTitle_03"]];
    }
    /** 单层section数据源*/
    NSArray * rowArray = headDic.allValues[0];
    self.sectionArray = rowArray.copy;
    NSInteger i = rowArray.count;
    /** 解决重用问题*/
    self.section = path;
    self.sectionSting = keyValue;
    
    if (i == 1) {
        // 说明就需要一列
        self.firstBtn.hidden = YES;
        self.secondBtn.hidden = YES;
        self.thirdBtn.hidden = YES;
        block(55);
    }else if(i == 2){
        self.thirdBtn.hidden = YES;
        self.firstBtn.hidden = NO;
        self.secondBtn.hidden = NO;
        [self.firstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectHeadImage.mas_bottom).offset(4);
            make.left.equalTo(self).offset(15);
            make.width.equalTo(self.secondBtn);
            make.right.equalTo(self.secondBtn.mas_left).offset(-10);
            make.height.equalTo(@25);
        }];
        [self.secondBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.firstBtn);
            make.left.equalTo(self.firstBtn.mas_right).offset(10);
            make.height.equalTo(self.firstBtn);
            make.width.equalTo(self.thirdBtn);
            make.right.equalTo(self).offset(-15);
        }];
        block(87);
    }else {
        self.thirdBtn.hidden = NO;
        self.firstBtn.hidden = NO;
        self.secondBtn.hidden = NO;
        
    [self.firstBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectHeadImage.mas_bottom).offset(4);
        make.left.equalTo(self).offset(15);
        make.width.equalTo(self.secondBtn);
        make.right.equalTo(self.secondBtn.mas_left).offset(-10);
        make.height.equalTo(@25);
    }];
    
    [self.secondBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstBtn);
        make.left.equalTo(self.firstBtn.mas_right).offset(10);
        make.height.equalTo(self.firstBtn);
        make.width.equalTo(self.thirdBtn);
        make.right.equalTo(self.thirdBtn.mas_left).offset(-15);
    }];
    
    [self.thirdBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.firstBtn);
        make.left.equalTo(self.secondBtn.mas_right).offset(15);
        make.height.width.equalTo(self.firstBtn);
        make.right.equalTo(self).offset(-15);
    }];
        block(87);
    }
}

- (void)changeSelectBtnImage:(NSMutableDictionary *)dic withDataSource:(NSArray *)array{
    NSArray * a = [dic objectForKey:[NSString stringWithFormat:@"%ld",self.section]];
    self.firstBtn.selected = [a[0] boolValue];
    self.secondBtn.selected = [a[1] boolValue];
    self.thirdBtn.selected = [a[2] boolValue];
    
    NSInteger i = array.count;
    BOOL  isMore = (i>2)?YES:NO;
    
    // showMore 是不是展示3列
    if (isMore == YES) {
        [self.firstBtn setImage:[UIImage imageNamed:@"tab3_1b"] forState:UIControlStateNormal];
        [self.secondBtn setImage:[UIImage imageNamed:@"tab3_2b"] forState:UIControlStateNormal];
        [self.thirdBtn setImage:[UIImage imageNamed:@"tab3_3b"] forState:UIControlStateNormal];
        [self.firstBtn setImage:[UIImage imageNamed:@"tab3_1a"] forState:UIControlStateSelected];
        [self.secondBtn setImage:[UIImage imageNamed:@"tab3_2a"] forState:UIControlStateSelected];
        [self.thirdBtn setImage:[UIImage imageNamed:@"tab3_3a"] forState:UIControlStateSelected];
    }else {
        [self.firstBtn setImage:[UIImage imageNamed:@"tab2_1b"] forState:UIControlStateNormal];
        [self.secondBtn setImage:[UIImage imageNamed:@"tab2_2b"] forState:UIControlStateNormal];
        [self.firstBtn setImage:[UIImage imageNamed:@"tab2_1a"] forState:UIControlStateSelected];
        [self.secondBtn setImage:[UIImage imageNamed:@"tab2_2a"] forState:UIControlStateSelected];
    }
}

#pragma mark -- lazy load
- (UIImageView *)selectHeadImage {
    if (!_selectHeadImage) {
        _selectHeadImage = [[UIImageView alloc]init];
    }
    return _selectHeadImage;
}

- (UIButton *)firstBtn {
    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _firstBtn;
}

- (UIButton *)secondBtn {
    if (!_secondBtn) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _secondBtn;
}

- (UIButton *)thirdBtn {
    if (!_thirdBtn) {
        _thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _thirdBtn;
}

- (NSArray<VipGiftShopModel *> *)sectionArray {
    if(!_sectionArray){
        _sectionArray = [NSArray array];
    }
    return _sectionArray;
}
@end
