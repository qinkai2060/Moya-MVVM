//
//  SpProductReviewHeaderView.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import "SpProductReviewHeaderView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface SpProductReviewHeaderView ()

/* 指示按钮 */
@property (strong , nonatomic)UIButton *indicateButton;

/* 评价数量 */
@property (strong , nonatomic)UILabel *commentNumLabel;
/* 好评比 */
@property (strong , nonatomic)UILabel *viewAllLabel;

@end

@implementation SpProductReviewHeaderView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _commentNumLabel = [[UILabel alloc] init];
    _commentNumLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    _commentNumLabel.textColor=HEXCOLOR(0x333333);
    _commentNumLabel.text=@"商品评价（11）";
    [self addSubview:_commentNumLabel];
    
    _viewAllLabel = [[UILabel alloc] init];
    _viewAllLabel.font = PFR13Font;
    _viewAllLabel.textColor=HEXCOLOR(0x666666);
    _viewAllLabel.text=@"查看全部";
    [self addSubview:_viewAllLabel];
     self.userInteractionEnabled = YES;
    _indicateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_indicateButton setImage:[UIImage imageNamed:@"back_light666"] forState:UIControlStateNormal];
    [self addSubview:_indicateButton];
    // 创建一个轻拍手势 同时绑定了一个事件
    UITapGestureRecognizer *aTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGRAction)];
    // 设置轻拍次数
    aTapGR.numberOfTapsRequired = 1;
    
//    // 设置手指触摸的个数
//    aTapGR.numberOfTouchesRequired = 2;
    
    // 添加手势
    [self addGestureRecognizer:aTapGR];
//    [aTapGR release];
//    // 一行代码为 view 添加手势事件
//    [self addGestureTapEventHandle:^(id sender, UITapGestureRecognizer *gestureRecognizer) {
//        NSLog(@"tap");
//    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_commentNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        make.centerY.mas_equalTo(self);
    }];
    
    [_indicateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.mas_equalTo(self);
    }];
    
    [_viewAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(_indicateButton.mas_left)setOffset:-5];
        make.centerY.mas_equalTo(self);
    }];
    
}
#pragma mark - Setter Getter Methods
- (void)setComNum:(NSString *)comNum
{
    _comNum = comNum;
    _commentNumLabel.text = [NSString stringWithFormat:@"商品评价(%@)",comNum];
    if ([comNum integerValue] == 0) {
        _viewAllLabel.hidden = YES;
        _indicateButton.hidden = YES;
        self.userInteractionEnabled = NO;
    } else {
        _viewAllLabel.hidden = NO;
        _indicateButton.hidden = NO;
        self.userInteractionEnabled = YES;
    }
}
//手势
-(void)tapGRAction
{
     [[NSNotificationCenter defaultCenter]postNotificationName:SeaTheReviewList object:nil userInfo:nil];
}
@end
