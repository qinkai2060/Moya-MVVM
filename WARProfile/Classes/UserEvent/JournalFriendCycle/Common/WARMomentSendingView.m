//
//  WARMomentSendingView.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/26.
//

#import "WARMomentSendingView.h"
#import "WARMomentCircleProgressView.h"

#import "WARMacros.h"

@interface WARMomentSendingView()
/** progressView */
@property (nonatomic, strong) WARMomentCircleProgressView *progressView;
/** sendingLable */
@property (nonatomic, strong) UILabel *sendingLable;
@end

@implementation WARMomentSendingView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.progressView];
        [self addSubview:self.sendingLable];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    [self.progressView setProgress:progress animated:animated];
}

- (WARMomentCircleProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[WARMomentCircleProgressView alloc]init];
        _progressView.frame = CGRectMake(0, 1, 15, 15);
        _progressView.borderWidth = 1.5;
        _progressView.lineWidth = 1.5;
        _progressView.borderColor = HEXCOLOR(0xDCDEE6);
        _progressView.tintColor = HEXCOLOR(0x2CBE61); 
        _progressView.fillColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (UILabel *)sendingLable {
    if (!_sendingLable) {
        _sendingLable = [[UILabel alloc]init];
        _sendingLable.frame = CGRectMake(20, 0, 50, 17);
        _sendingLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        _sendingLable.textColor = HEXCOLOR(0x8D93A4);
        _sendingLable.text = WARLocalizedString(@"发布中...");
    }
    return _sendingLable;
}

@end
