//
//  YunDianNewRefundDetailStateView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundDetailStateView.h"

@interface YunDianNewRefundDetailStateView()
{
    
    dispatch_source_t _timer;
    
}

@end

@implementation YunDianNewRefundDetailStateView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.refundStateLabel];
    [self.refundStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self.refundStateLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(75);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(10);
    }];
    
}
- (UILabel *)refundStateLabel{
    if (!_refundStateLabel) {
        _refundStateLabel = [[UILabel alloc] init];
        _refundStateLabel.text = @"";
        _refundStateLabel.font = [UIFont boldSystemFontOfSize:14];
        _refundStateLabel.textColor = HEXCOLOR(0x333333);
        _refundStateLabel.numberOfLines = 1;
        _refundStateLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _refundStateLabel;
}
- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"";
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = HEXCOLOR(0x333333);
        _timeLabel.numberOfLines = 1;
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        
    }
    return _timeLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = HEXCOLOR(0xF5F5F5);
    }
    return _line;
}
- (NSString *)ConvertStrToTime:(NSString *)timeStr

{
    long long ss = [timeStr longLongValue];
    
    NSString *str_day = [NSString stringWithFormat:@"%02lld",ss / 86400];
        //format of hour
    NSString *str_hour = [NSString stringWithFormat:@"%lld",(ss%86400)/3600];
        //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02lld",((ss%86400)%3600)/60];
        //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02lld",((ss%86400)%3600)%60];
        //format of time
    NSString *format_time = [NSString stringWithFormat:@"还剩%@天%@时%@分%@秒",str_day,str_hour,str_minute,str_second];
    
    return format_time;
    
}

- (void)setRefundDetailModel:(YunDianNewRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
    switch ([_refundDetailModel.returnState integerValue]) {
        case 1://(买家=退款中，卖家=退款待处理）
        {
            _refundStateLabel.text = @"等待商家处理";
            
            
            if ([_refundDetailModel.applyRemindInvalidTimestamp longLongValue] > 0) {
                //1天(d)=86400000毫秒(ms)
                // 1时(h)=3600000毫秒(ms)
                // 1分(min)=60000毫秒(ms)
                __block NSInteger time_sy = [_refundDetailModel.applyRemindInvalidTimestamp longLongValue] / 1000;
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                if (_timer) {
                    dispatch_source_cancel(_timer);
                    _timer = nil;
                }
                
                
                _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
                
                dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);  //每秒执行
                
                dispatch_source_set_event_handler(_timer, ^{
                    time_sy--;
                    if(time_sy<=0){ //倒计时结束，关闭
                        self.timeLabel.text = @"还剩0天0时0分0秒";
                        
                        dispatch_source_cancel(_timer);
                        
                        _timer = nil;
                                            
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *str = [self ConvertStrToTime:[NSString stringWithFormat:@"%ld",time_sy]];
//                            NSLog(@"%@ _____%ld", str, time_sy);
                            self.timeLabel.text = str;
                            
                        });
                    }
                });
                dispatch_resume(_timer);
                
            }
            
        }
            
            
            break;
        case 2://撤销退款
        {
            if (_timer) {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            _refundStateLabel.text = @"取消退款";
            _timeLabel.text = _refundDetailModel.operatorDate;
        }
            break;
        case 3://(商家拒绝退款）
        {
            if (_timer) {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            _refundStateLabel.text = @"商家已拒绝";
            _timeLabel.text = _refundDetailModel.operatorDate;
        }
            break;
        case 4://（商家同意退款)
        {
            if (_timer) {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            _refundStateLabel.text = @"已退款";
            _timeLabel.text = _refundDetailModel.operatorDate;
        }
            break;
        case 5://(退款待仲裁）
        {
            if (_timer) {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            _refundStateLabel.text = @"退款待仲裁";
            _timeLabel.text = _refundDetailModel.operatorDate;
            
        }
            break;
        case 6://（仲裁拒绝退款）
        {
            if (_timer) {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            _refundStateLabel.text = @"拒绝退款";
            _timeLabel.text = _refundDetailModel.operatorDate;
        }
            break;
        case 7://（仲裁同意退款)
        {
            if (_timer) {
                dispatch_source_cancel(_timer);
                _timer = nil;
            }
            _refundStateLabel.text = @"已退款";
            _timeLabel.text = _refundDetailModel.operatorDate;
        }
            break;
            
        default:
            break;
    }
    
}
@end
