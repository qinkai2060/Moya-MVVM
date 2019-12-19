//
//  ManageLogticsHeadView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageLogticsHeadView.h"
@interface ManageLogticsHeadView ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UILabel * expressLabel ;
@property (nonatomic, strong) UILabel * orderLabel ;
@property (nonatomic, strong) UIButton * pressBtn;
@end
@implementation ManageLogticsHeadView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(@105);
        }];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_bottom);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
        
        UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logistics"]];
        [self.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(15);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(@35);
        }];
        
        UILabel * compangLabel = [UILabel new];
        compangLabel.text = @"物流公司：";
        compangLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        compangLabel.font = kFONT(12);
        [self.contentView addSubview:compangLabel];
        [compangLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView);
            make.left.equalTo(imageView.mas_right).offset(15);
            make.width.equalTo(@60);
            make.height.equalTo(@20);
        }];
        
        UILabel * transLabel = [UILabel new];
        transLabel.text = @"物流单号：";
        transLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        transLabel.font = kFONT(12);
        [self.contentView addSubview:transLabel];
        [transLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(compangLabel.mas_bottom);
            make.left.equalTo(imageView.mas_right).offset(15);
            make.width.equalTo(@60);
            make.height.equalTo(@20);
        }];
       
        [self.contentView addSubview:self.expressLabel];
        [self.expressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(compangLabel);
            make.height.equalTo(compangLabel);
            make.left.equalTo(compangLabel.mas_right);
            make.right.equalTo(self.contentView).offset(-50);
        }];
        
        [self.contentView addSubview:self.orderLabel];
        [self.orderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(transLabel);
            make.height.equalTo(transLabel);
            make.left.equalTo(transLabel.mas_right);
            make.right.equalTo(self.contentView).offset(-50);
        }];
        
        [self.contentView addSubview:self.pressBtn];
        [self.pressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(imageView);
            make.width.equalTo(@68);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@25);
        }];
        
        UIView * bottom = [UIView new];
        bottom.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        [self.contentView addSubview:bottom];
        [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-50);
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@10);
        }];
        
        UILabel * bottomLabel = [UILabel new];
        bottomLabel.text = @"订单跟踪";
        bottomLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        bottomLabel.font = kFONT(14);
        [self.contentView addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bottom.mas_bottom).offset(15);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@60);
            make.height.equalTo(@20);
        }];
        
        @weakify(self);
        [[self.pressBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self tapCopyAction];
        }];
    }
    return self;
}

- (void)setLogticsModel:(ManageLogticsModel *)logticsModel {
    _logticsModel = logticsModel;
    self.expressLabel.text = ([self.logticsModel.expTextName isNotNil])?objectOrEmptyStr(self.logticsModel.expTextName):@"暂无物流信息";
    self.orderLabel.text = ([self.logticsModel.mailNo isNotNil])?objectOrEmptyStr(self.logticsModel.mailNo):@"暂无物流信息";
    BOOL isShow = [self.logticsModel.mailNo isNotNil];
    self.pressBtn.hidden = !isShow;
}

- (void)passScrollDataSource:(NSArray *)dataSource {
    
    if (dataSource.count == 0) {return;}

    self.scrollView.contentSize = CGSizeMake((dataSource.count+1)*80+20, 0);
    for (NSInteger i = 0; i < dataSource.count; i++) {
        
        NSDictionary * addDic = dataSource[i];
        UIView * newView = [UIView new];
        newView.backgroundColor = [UIColor colorWithHexString:@"#F7F7F7"];
        newView.tag = 100 +i;
        
        [self.scrollView addSubview:newView];
        CGFloat leftX = (i+1)*15 + i*75;
        [newView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.scrollView).offset(leftX);
            make.centerY.equalTo(self.scrollView);
            make.width.equalTo(@75);
            make.height.equalTo(@75);
        }];
        
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString * urlString = [addDic objectForKey:@"address"];
        [imageView sd_setImageWithURL:[urlString get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        [newView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(newView);
            make.width.equalTo(@52);
            make.height.equalTo(@65);
        }];
    }
}

/** 复制*/
- (void)tapCopyAction{
    if (!CHECK_STRING_ISNULL(self.orderLabel.text)) {
        UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
        pastboard.string = objectOrEmptyStr(self.orderLabel.text);
        [SVProgressHUD showSuccessWithStatus:@"已复制到剪贴板!"];
        [SVProgressHUD dismissWithDelay:1];
    }
}

#pragma mark -- lazy load
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.contentSize = CGSizeMake(2*kWidth, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"FFFFFF"];
        _scrollView.layer.cornerRadius = 4;
    }
    return _scrollView;
}

- (UILabel *)expressLabel {
    if (!_expressLabel) {
        _expressLabel = [UILabel new];
        _expressLabel.text = @"顺丰快递";
        _expressLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _expressLabel.font = kFONT(12);
        _expressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _expressLabel;
}

- (UILabel *)orderLabel {
    if (!_orderLabel) {
        _orderLabel = [UILabel new];
        _orderLabel.text = @"39873404090";
        _orderLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _orderLabel.font = kFONT(12);
        _orderLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderLabel;
}
- (UIButton *)pressBtn {
    if (!_pressBtn) {
        _pressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pressBtn setTitle:@"复制单号" forState:UIControlStateNormal];
        [_pressBtn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
        _pressBtn.titleLabel.font = kFONT(12);
        _pressBtn.layer.borderWidth = 1;
        _pressBtn.layer.borderColor = [UIColor colorWithHexString:@"#DDDDDD"].CGColor;
        _pressBtn.layer.masksToBounds = YES;
        _pressBtn.layer.cornerRadius = 12.5;
    }
    return _pressBtn;
}
@end
