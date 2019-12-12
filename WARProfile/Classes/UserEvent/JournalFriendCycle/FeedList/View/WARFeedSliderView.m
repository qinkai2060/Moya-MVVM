//
//  WARFeedSliderView.m
//  WARControl
//
//  Created by helaf on 2018/4/27.
//

#import "WARFeedSliderView.h"
#import "WARFeedHeader.h"
#import "WARFeedPopUpView.h"

@interface WARFeedSliderView ()

@property (nonatomic, strong) UILabel *slider;
/** 轨迹条 */
@property (nonatomic, strong) UIView *trackLineView;
/** Description */
@property (nonatomic, assign) NSInteger currentPage;
/** Description */
@property (nonatomic, assign) NSInteger pageCount;
/** Description */
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (strong, nonatomic) WARFeedPopUpView *popUpView;
/** Description */
@property (nonatomic, assign) CGSize popUpViewSize;
@end

@implementation WARFeedSliderView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViewUI];
    }
    return self;
}


- (void)setupViewUI{
    
    _currentPage = 0;
    _pageCount = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.trackLineView];
    [self addSubview:self.slider];
    
    self.popUpView = [[WARFeedPopUpView alloc] initWithFrame:CGRectZero];
    //self.popUpViewColor = [UIColor colorWithHue:0.6 saturation:0.6 brightness:0.5 alpha:0.65];
    self.popUpView.alpha = 0.0;
    [self.popUpView setColor:[UIColor colorWithHexString:@"386DB4" opacity:0.65]];
    [self.popUpView setTextColor:[UIColor colorWithHexString:@"FFFFFF"]];
    [self.popUpView setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:self.popUpView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderChangeValue:)];
    [self.slider addGestureRecognizer:panGesture];
    self.panGesture = panGesture;
}


- (void)sliderChangeValue:(UIPanGestureRecognizer *)panChange{
    CGPoint point = [panChange translationInView:self];//slider相对位移
    static CGPoint center;//slider中心坐标
    
    if (panChange.state == UIGestureRecognizerStateBegan) {
        center = panChange.view.center;
        [self.popUpView show];
    }else if (panChange.state == UIGestureRecognizerStateChanged){
        
    }else{
        [self.popUpView hide];
    }
    
    CGFloat slider_x = center.x + point.x;
    
    if (slider_x <= 25) {
        slider_x = 25;
    }else if (slider_x >= (self.width - 25)){
        slider_x = self.width - 25;
    }
    
    panChange.view.center = CGPointMake(slider_x, center.y);
    
    [self valueChangeWithFloat:slider_x];
    
}


- (void)valueChangeWithFloat:(CGFloat)centerX{
    
    CGFloat oneHalf = self.width / (_pageCount + 1);
    CGFloat percent = centerX / oneHalf;
    NSInteger currentPage = 0;
    
    if (percent + .5f < ceilf(percent)) {
        currentPage = floor(percent) - 1;
    } else {
        currentPage = ceilf(percent) - 1;
    }
    
    if (currentPage > (_pageCount - 1)) {
        currentPage = _pageCount - 1;
    }
    
    if (currentPage < 0) {
        currentPage = 0;
    }
    
    _currentPage = currentPage;
    self.slider.text = [NSString stringWithFormat:@"%@/%@", @(currentPage + 1), @(_pageCount)];
    
    [self.popUpView setString:[NSString stringWithFormat:@"%@", @(currentPage + 1)]];
    _popUpViewSize = [self.popUpView popUpSizeForString:[NSString stringWithFormat:@"%@", @(currentPage + 1)]];
    self.popUpView.x = 0;
    self.popUpView.height = 35;
    self.popUpView.y = self.slider.y - self.popUpView.height - 13;
    self.popUpView.width = _popUpViewSize.width;
    self.popUpView.centerX = self.slider.centerX;
    
    if (_delegate && [_delegate respondsToSelector:@selector(feedSliderChangeIndex:)]) {
        [_delegate feedSliderChangeIndex:currentPage];
    }
}


- (void)reloadData:(CGFloat)value{
    
}

- (void)updateSliderCurrentPage:(NSInteger)currentPage pageCount:(NSInteger)pageCount {
    
    _currentPage = currentPage;
    _pageCount = pageCount;
    
    CGFloat offsetCenterX = self.width / (pageCount + 1);
    offsetCenterX = offsetCenterX * (currentPage + 1);
    if (currentPage == 0) {
        offsetCenterX = 25;
    }else if (currentPage == (pageCount - 1)){
        offsetCenterX = self.width - 25;
    }
    self.slider.centerX = offsetCenterX;
    self.slider.text = [NSString stringWithFormat:@"%@/%@", @(currentPage + 1), @(pageCount)];
    
    if (pageCount <= 1) {
        self.panGesture.enabled = NO;
    }else{
        self.panGesture.enabled = YES;
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.slider.frame = CGRectFlatMake(0, 0, 50, self.height);
    self.trackLineView.frame = CGRectFlatMake(0, (self.height - PixelOne) * 0.5, self.width, PixelOne);
    
}



#pragma mark -- lazy 懒加载所有的视图

- (UILabel *)slider{
    if (!_slider) {
        _slider = [[UILabel alloc] init];
        _slider.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _slider.textAlignment = NSTextAlignmentCenter;
        _slider.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        _slider.textColor = [UIColor colorWithHexString:@"ADB1BE"];
        _slider.userInteractionEnabled = YES;
    }
    return _slider;
}


- (UIView *)trackLineView{
    if (!_trackLineView) {
        _trackLineView = [[UIView alloc] init];
        _trackLineView.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"];
    }
    return _trackLineView;
}



@end
