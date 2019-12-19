//
//  MSSCalendarCollectionViewCell.m
//  MSSCalendar
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//

#import "MSSCalendarCollectionViewCell.h"
#import "MSSCalendarDefine.h"

@implementation MSSCalendarCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
//    self.layer.cornerRadius = 5;
//    self.layer.masksToBounds = YES;
   
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    [self.contentView addSubview:_imageView];
    
    _tagLabel = [[MSSCircleLabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-30,0 , 30,  MSS_Iphone6Scale(10))];
    _tagLabel.textAlignment = NSTextAlignmentCenter;
    _tagLabel.hidden=NO;
    _tagLabel.font = [UIFont systemFontOfSize:9.0f];
    [self.contentView addSubview:_tagLabel];
    
    _dateLabel = [[MSSCircleLabel alloc]initWithFrame:CGRectMake(0, MSS_Iphone6Scale(15), self.contentView.frame.size.width, self.frame.size.height / 2 - MSS_Iphone6Scale(10))];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    _dateLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:_dateLabel];
    
    _subLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateLabel.frame), self.contentView.frame.size.width, _dateLabel.frame.size.height)];
    _subLabel.textAlignment = NSTextAlignmentCenter;
    _subLabel.font = [UIFont systemFontOfSize:9.0f];
    [self.contentView addSubview:_subLabel];
    
    
//    _dateLabel.backgroundColor = [UIColor yellowColor];
//    _subLabel.backgroundColor = [UIColor yellowColor];
}
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        [make.right.mas_equalTo(self)setOffset:-1];
//        [make.top.mas_equalTo(self)setOffset:1];
//         make.height.mas_equalTo(10);
//
//    }];
//
//}
- (void)setIsSelected:(BOOL)isSelected
{
    _dateLabel.isSelected = isSelected;
}

@end
