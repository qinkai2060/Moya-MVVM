
//
//  CloudTypicalView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudTypicalView.h"
@interface CloudTypicalView ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UILabel * showLabel;
@end
@implementation CloudTypicalView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
        self.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.8f];

        self.imageView = [[UIImageView alloc]init];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(@210);
            make.center.equalTo(self);
        }];
        
        [self.imageView addSubview:self.showLabel];
        [self.showLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView).offset(30);
            make.right.equalTo(self.imageView).offset(-10);
            make.width.equalTo(@150);
            make.height.equalTo(@20);
        }];
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self closeAnimation];
}

- (void)showImageString:(NSURL *)imageString withWidth:(CGSize)size{
    [self.imageView sd_setImageWithURL:imageString];
    if(size.width != 0){
        [self.imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(size.width));
            make.height.equalTo(@(size.height));
            make.center.equalTo(self);
        }];
    }
    [self popAnimation];
}

- (void)showLabelText:(NSString *)showString {
    if ([showString isNotNil]) {
        self.showLabel.text = showString;
    }
}

- (void)popAnimation {
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, 0, kWidth, kHeight);
    } completion:^(BOOL finished) {
    }];
}

- (void)closeAnimation {
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    } completion:^(BOOL finished) {
    }];
}

- (UILabel *)showLabel {
    if (!_showLabel) {
        _showLabel = [UILabel new];
        _showLabel.text = @"店铺名称";
        _showLabel.font = kFONT(15);
        _showLabel.textColor = [UIColor whiteColor];
        _showLabel.textAlignment = NSTextAlignmentLeft;
    }
    return  _showLabel;
}
@end
