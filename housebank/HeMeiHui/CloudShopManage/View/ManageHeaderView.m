//
//  ManageHeaderView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageHeaderView.h"
@interface ManageHeaderView ()
@property (nonatomic, strong) UILabel * timeLabel ;
@property (nonatomic, strong) UILabel * orderNumLabel ;
@property (nonatomic, strong) UILabel * stateLabel;
@end

@implementation ManageHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.orderNumLabel];
        [self.contentView addSubview:self.stateLabel];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@70);
            make.height.equalTo(@18);
        }];
        
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor colorWithHexString:@"#DDDDDD"];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@1);
            make.height.equalTo(@18);
            make.left.equalTo(self.timeLabel.mas_right).offset(10);
        }];
        
        [self.contentView addSubview:self.stateLabel];
        [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@18);
            make.width.equalTo(@60);
        }];
        
        [self.contentView addSubview:self.orderNumLabel];
        [self.orderNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.stateLabel.mas_left).offset(-20);
            make.height.equalTo(@18);
        }];
        
    }
    return self;
}

- (void)setSectionModel:(ManageOrderModel *)sectionModel {
    _sectionModel = sectionModel;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.sectionModel.createDate doubleValue] / 1000];
    NSDateFormatter  *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.timeLabel.text = [dateFormat stringFromDate:date];
    
    self.orderNumLabel.text = self.sectionModel.orderNo;
    switch (self.sectionModel.orderState) {
        case 1:
            self.stateLabel.text = @"待付款";
            break;
        case 2:
            self.stateLabel.text = @"待发货";
            break;
        case 3:
            self.stateLabel.text = @"待收货";
            break;
        case 4:
            self.stateLabel.text = @"退款中";
            break;
        case 5:
            self.stateLabel.text = @"已退款";
            break;
        case 6:
            self.stateLabel.text = @"已取消";
            break;
        case 7:
            self.stateLabel.text = @"已完成";
            break;
        case 8:
            self.stateLabel.text = @"已完成";
            break;
            
        default:
            break;
    }
}

#pragma mark -- lazy load
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.text = @"2019-6-20";
        _timeLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLabel.font = kFONT(12);
        _timeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _timeLabel;
}

- (UILabel *)orderNumLabel {
    if (!_orderNumLabel) {
        _orderNumLabel = [UILabel new];
        _orderNumLabel.text = @"E08173485841";
        _orderNumLabel.textColor = [UIColor colorWithHexString:@"#999999"];
        _orderNumLabel.font = kFONT(12);
        _orderNumLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderNumLabel;
}

- (UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [UILabel new];
        _stateLabel.text = @"待发货";
        _stateLabel.textColor = [UIColor colorWithHexString:@"#ED0505"];
        _stateLabel.font = kFONT(12);
        _stateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _stateLabel;
}
@end
