//
//  WARBirthdayFooterView.m
//  Pods
//
//  Created by huange on 2017/8/25.
//
//

#import "WARBirthdayFooterView.h"
#import "NSDate+Utilities.h"

@interface WARBirthdayFooterView ()

@property (nonatomic, strong) UILabel *bottomDescriptionLabel;

@end

@implementation WARBirthdayFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createButtonDescriptionLabel];
        [self createDatePicker];
    }
    
    return self;
}


- (void)createButtonDescriptionLabel {
    self.bottomDescriptionLabel = [UILabel new];
    self.bottomDescriptionLabel.textColor = ThreeLevelTextColor;
    self.bottomDescriptionLabel.font = [UIFont systemFontOfSize:12];
    self.bottomDescriptionLabel.numberOfLines = 0;
    self.bottomDescriptionLabel.text = WARLocalizedString(@"*选择你的生日日期，自动计算出年龄和星座。\n  你的出生日期为保密状态，不会被他人看到。");
    [self.contentView addSubview:self.bottomDescriptionLabel];
    
    [self.bottomDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView.mas_leading).with.offset(15);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-15);
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.height.mas_equalTo(40);
    }];
}

- (void)createDatePicker {
    self.datePick = [UIDatePicker new];
    self.datePick.datePickerMode = UIDatePickerModeDate;
    self.datePick.maximumDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:-110];//设置最小时间为：当前时间前推110年
    self.datePick.minimumDate = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    [self.contentView addSubview:self.datePick];
    
    [self.datePick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(170);
    }];
}

@end
