//
//  HFYDCategoryCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYDCategoryCell.h"

@implementation HFYDCategoryCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.saleCountLb];
    }
    return self;
}
- (void)doMessageSomthing {
    self.titleLb.text = self.model.classificationName;
    self.titleLb.frame = CGRectMake(8, 12, 56, [HFUntilTool boundWithStr:self.titleLb.text font:14 maxSize:CGSizeMake(56, 40)].height);
    self.saleCountLb.text = [NSString stringWithFormat:@"%ld",self.model.saleCount];
    CGSize size =  [self.titleLb sizeThatFits: CGSizeMake(86, 44)];
    
    if (self.saleCountLb.text.length == 1) {
//        if(size.width>=56) {
//            self.saleCountLb.frame = CGRectMake(5+56, 5, 17, 17);
//        }else {
//            self.saleCountLb.frame = CGRectMake(size.width+8, 5, 17, 17);
//        }
         self.saleCountLb.frame = CGRectMake(86-17, 5, 17, 17);
    }else {
        
        if ([self.saleCountLb.text integerValue] >= 99) {
            self.saleCountLb.text = @"99+";
        }else {
            self.saleCountLb.text = [NSString stringWithFormat:@"%ld",self.model.saleCount];
        }
//        if(8+size.width+34>=86) {
//
//        }else {
//            self.saleCountLb.frame = CGRectMake(size.width+8, 5, 34, 17);
//        }
         self.saleCountLb.frame = CGRectMake(86-34, 5, 34, 17);
    }
    if (self.model.saleCount == 0) {
        self.saleCountLb.hidden = YES;
    }else {
        self.saleCountLb.hidden = NO;
    }
    self.saleCountLb.layer.cornerRadius = 8;
    self.saleCountLb.layer.masksToBounds = YES;
    if (self.model.selected) {
        self.titleLb.font = [UIFont boldSystemFontOfSize:12];
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else {
        self.contentView.backgroundColor  = [UIColor colorWithHexString:@"F5F5F5"];
        self.titleLb.font = [UIFont systemFontOfSize:12];
    }
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [HFUIkit textColor:@"666666" font:14 numberOfLines:2];
//        _titleLb.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLb;
}
- (UILabel *)saleCountLb {
    if (!_saleCountLb) {
        _saleCountLb = [HFUIkit textColor:@"FFFFFF" font:12 numberOfLines:1];
        _saleCountLb. backgroundColor = [UIColor colorWithHexString:@"F3344A"];
        _saleCountLb.textAlignment = NSTextAlignmentCenter;
    }
    return _saleCountLb;
}
@end
