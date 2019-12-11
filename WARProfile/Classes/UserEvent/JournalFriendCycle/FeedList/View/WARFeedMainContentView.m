//
//  WARFeedMainContentView.m
//  Pods
//
//  Created by helaf on 2018/4/25.
//

#import "WARFeedMainContentView.h"
#import "WARPageCoverController.h"
#import "WARPageContentViewController.h"
#import "WARFeedHeader.h"
#import "WARFeedSliderView.h"

@interface WARFeedMainContentView () <WARPageCoverControllerDelegate, WARFeedSliderViewDelegate, WARPageContentViewControllerDelegate>
@property (nonatomic, strong) NSMutableArray* pageLayers;
@property (nonatomic, strong) WARPageCoverController *coverVC;
@property (nonatomic, strong) UIButton *preButton;
@property (nonatomic, strong) UIButton *nextButton;
/** 翻页进度 */
@property (nonatomic, strong) UIView* progressView;
/** 当前翻到的位置 */
@property (nonatomic, assign) NSInteger currentPageIndex;
/** <#Description#> */
@property (nonatomic, strong) WARPageContentViewController *currentPageVC;
/** 滑块 */
@property (nonatomic, strong) UILabel *sliderLabel;
/** 滑块阴影 */
@property (nonatomic, strong) CAShapeLayer *shadowLayer;
/** 滑块的offset */
@property (nonatomic, assign) CGFloat sliderMoveOffsetX;
/** <#Description#> */
@property (nonatomic, strong) WARFeedSliderView *sliderView;
@end

@implementation WARFeedMainContentView


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.currentPageIndex = 0;
        [self addPageBgLayers];
        [self addSubview:self.coverVC.view];
        [self addSubview:self.preButton];
        [self addSubview:self.nextButton];
        [self addSubview:self.progressView];
        [self addSubview:self.sliderLabel];
        //[self.sliderLabel.layer addSublayer:self.shadowLayer];
        self.sliderView = [[WARFeedSliderView alloc] init]; 
        self.sliderView.delegate = self;
        [self addSubview:self.sliderView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didAction:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didFeedMainContentView:)]) {
        [self.delegate didFeedMainContentView:self];
    }
}


- (void)setModelProtocol:(id<WARFeedModelProtocol>)modelProtocol {
    
    _modelProtocol = modelProtocol;
    
    NSArray* feedLayoutArr = modelProtocol.feedLayoutArr;
    
    WARPageContentViewController *vc = [[WARPageContentViewController alloc] init];
    vc.delegate = self;
    [self.coverVC setController:vc];
    
    if (kArrayIsEmpty(feedLayoutArr)) {
        vc.pageLayout = nil;
        return;
    }
    
    if ((modelProtocol.currentPageIndex < 0) || (modelProtocol.currentPageIndex > feedLayoutArr.count)) {
        return;
    }
    
    self.currentPageIndex = modelProtocol.currentPageIndex;
    WARFeedPageLayout* pageLayout = [feedLayoutArr objectAtIndex:self.currentPageIndex];
    vc.pageLayout = pageLayout;
    self.coverVC.gestureRecognizerEnabled = !kArrayIsEmpty(feedLayoutArr);
    
    [self updateSlideLabel];
}

#pragma mark - Delegate

// 切换结果
- (void)coverController:(WARPageCoverController *)coverController currentController:(UIViewController *)currentController finish:(BOOL)isFinish{
//    if (!isFinish) { // 切换失败
//        WARPageContentViewController *vc = (WARPageContentViewController *)currentController;
//    }
    if ([self.delegate respondsToSelector:@selector(feedMainContentView:finishHorizontalScroll:)]) {
        [self.delegate feedMainContentView:self finishHorizontalScroll:@(isFinish)];
    }
}

// 上一个控制器
- (UIViewController *)coverController:(WARPageCoverController *)coverController getAboveControllerWithCurrentController:(UIViewController *)currentController{
    if ([self.delegate respondsToSelector:@selector(feedMainContentView:scrollToLeft:)]) {
        [self.delegate feedMainContentView:self scrollToLeft:YES];
    }
    NSArray* feedLayoutArr = self.modelProtocol.feedLayoutArr;
    if (kArrayIsEmpty(feedLayoutArr)) {
        return nil;
    }
    self.currentPageIndex --;
    if (self.currentPageIndex < 0) {
        self.currentPageIndex = 0;
        return nil;
    }
    self.modelProtocol.currentPageIndex = self.currentPageIndex;
    WARPageContentViewController *vc = [[WARPageContentViewController alloc] init];
    vc.delegate = self;
    vc.pageLayout = [feedLayoutArr objectAtIndex:self.currentPageIndex];
    
    [self updateSlideLabel];
    return vc;
}


// 下一个控制器
- (UIViewController *)coverController:(WARPageCoverController *)coverController getBelowControllerWithCurrentController:(UIViewController *)currentController{
    if ([self.delegate respondsToSelector:@selector(feedMainContentView:scrollToLeft:)]) {
        [self.delegate feedMainContentView:self scrollToLeft:NO];
    }
    
    NSArray* feedLayoutArr = self.modelProtocol.feedLayoutArr;
    if (kArrayIsEmpty(feedLayoutArr)) {
        return nil;
    }
    self.currentPageIndex ++;
    if (self.currentPageIndex > feedLayoutArr.count - 1) {
        self.currentPageIndex = feedLayoutArr.count - 1;
        return nil;
    }
    self.modelProtocol.currentPageIndex = self.currentPageIndex;
    WARPageContentViewController *vc = [[WARPageContentViewController alloc] init];
    vc.delegate = self;
    vc.pageLayout = [feedLayoutArr objectAtIndex:self.currentPageIndex];
    
    [self updateSlideLabel];
    return vc;
}
 
- (void)feedSliderChangeIndex:(NSInteger)currentIndex{
    
    if (self.currentPageIndex == currentIndex) {
        return;
    }
    
    NSArray* feedLayoutArr = self.modelProtocol.feedLayoutArr;
    
    self.currentPageIndex = currentIndex;
    self.modelProtocol.currentPageIndex = currentIndex;
    
    WARPageContentViewController *vc = [[WARPageContentViewController alloc] init];
    vc.delegate = self;
    vc.pageLayout = [feedLayoutArr objectAtIndex:self.currentPageIndex];
    [self.coverVC setController:vc];
}

#pragma mark - WARPageContentViewControllerDelegate

- (void)controller:(id)controller didLink:(WARFeedLinkComponent *)link {
    if ([self.delegate respondsToSelector:@selector(feedMainContentView:didLink:)]) {
        [self.delegate feedMainContentView:self didLink:link];
    }
}

- (void)controller:(id)controller didGameLink:(WARFeedLinkComponent *)didGameLink {
    if ([self.delegate respondsToSelector:@selector(feedMainContentView:didLink:)]) {
        [self.delegate feedMainContentView:self didGameLink:didGameLink];
    }
}

- (void)controller:(WARPageContentViewController *)controller didIndex:(NSInteger)index imageComponents:(NSArray <WARFeedImageComponent *>*) imageComponents magicImageView:(UIView *)magicImageView {
    if ([self.delegate respondsToSelector:@selector(feedMainContentView:didIndex:imageComponents:magicImageView:)]) {
        [self.delegate feedMainContentView:self didIndex:index imageComponents:imageComponents magicImageView:magicImageView];
    }
}

- (void)updateSlideLabel{
    
    NSArray* feedLayoutArr = self.modelProtocol.feedLayoutArr;
    [UIView animateWithDuration:0.2 animations:^{
        NSInteger pageCount = feedLayoutArr.count;
        [self.sliderView updateSliderCurrentPage:self.currentPageIndex pageCount:pageCount];
    }];
}


- (void)addPageBgLayers {
    self.pageLayers = [NSMutableArray arrayWithCapacity:2];
    for (int i = 0; i < 2; i ++) {
        CALayer *pageLayer = [CALayer layer];
        pageLayer.borderWidth = PixelOne;
        pageLayer.borderColor = [UIColor colorWithHexString:@"ADB1BE"].CGColor;
        pageLayer.cornerRadius = 5.0;
        pageLayer.shouldRasterize = YES;
        pageLayer.rasterizationScale = KScreenScale;
        pageLayer.backgroundColor = [UIColor whiteColor].CGColor;
        pageLayer.shadowColor = [UIColor colorWithHexString:@"484848"].CGColor;
        pageLayer.shadowOpacity = 1;
        pageLayer.shadowOffset = CGSizeMake(0, 0);
        pageLayer.shadowRadius = 1;
        [self.layer addSublayer:pageLayer];
        [self.pageLayers addObject:pageLayer];
    }
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat padding = 0;
    
    CGFloat margin = 3;
    CGFloat count = self.pageLayers.count;
    CGFloat layerPaddingTop = 0;
    CGRect lastRect =  CGRectZero;
    
    for (int i = 0; i < count; i ++) {
        CALayer *pageLayer = self.pageLayers[i];
        CGFloat layerX = (count - i - 1) * margin + padding;
        CGFloat layerY = (count - i - 1) * margin + padding + layerPaddingTop;
        CGFloat layerW = self.width - layerX - i * margin - padding;
        CGFloat layerH = self.height - layerY - (count - i - 1) * margin - 40;
        pageLayer.frame = CGRectFlatMake(layerX, layerY, layerW, layerH);
        
        lastRect = CGRectFlatMake(layerX, layerY, layerW, layerH);
    }
    
    self.coverVC.view.frame = lastRect;
    
    
    CGFloat btnW = 45;
    CGFloat btnH = 20;
    
    
    CGFloat sliderWidth = 180;
    CGFloat sliderHeight = 30;
    
    CGFloat preX = (self.width - sliderWidth - 2 * btnW) * 0.5;
    CGFloat preY = self.height - sliderHeight;
    CGFloat preW = btnW;
    CGFloat preH = btnH;
    self.preButton.frame = CGRectFlatMake(preX, preY, preW, preH);
    
    CGFloat nextX = preX + preW + sliderWidth;
    CGFloat nextY = self.height - sliderHeight;
    CGFloat nextW = btnW;
    CGFloat nextH = btnH;
    self.nextButton.frame = CGRectFlatMake(nextX, nextY, nextW, nextH);
    
    CGFloat sliderX = preX + btnW;
    self.sliderView.frame = CGRectFlatMake(sliderX, 0, sliderWidth, self.preButton.height);
    self.sliderView.centerY = self.preButton.centerY;
}




#pragma mark - Getter

- (WARPageCoverController *)coverVC {
    if (!_coverVC) {
        _coverVC = [[WARPageCoverController alloc] init];
        _coverVC.delegate = self;
        _coverVC.view.backgroundColor = [UIColor whiteColor];
        _coverVC.view.layer.cornerRadius = 5.0;
        _coverVC.view.clipsToBounds = YES;
    }
    return _coverVC;
}

- (UIView *)progressView{
    if (!_progressView) {
        _progressView = [[UIView alloc] init];
        _progressView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _progressView.layer.cornerRadius = 0.75;
        _progressView.clipsToBounds = YES;
    }
    return _progressView;
}


- (UILabel *)sliderLabel{
    if (!_sliderLabel) {
        _sliderLabel = [[UILabel alloc] init];
        _sliderLabel.backgroundColor = [UIColor colorWithHexString:@"E3E3E3"];
        _sliderLabel.textAlignment = NSTextAlignmentCenter;
        _sliderLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:10];
        _sliderLabel.textColor = [UIColor colorWithHexString:@"ADB1BE"];
        _sliderLabel.userInteractionEnabled = YES;
    }
    return _sliderLabel;
}

- (CAShapeLayer *)shadowLayer{
    if (!_shadowLayer) {
        //UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *shadowLayer = [CAShapeLayer new];
        //shadowLayer.path = path.CGPath;
        shadowLayer.fillColor = [UIColor clearColor].CGColor;
        //shadowLayer.shadowPath = path.CGPath;
        shadowLayer.shadowColor = [UIColor colorWithHexString:@"E3E3E3"].CGColor;
        shadowLayer.shadowOffset = CGSizeMake(0.5, 0.5);
        shadowLayer.shadowOpacity = 1.0;
//        shadowLayer.shadowRadius = 2.0;
        _shadowLayer = shadowLayer;
    }
    return _shadowLayer;
}


- (UIButton *)preButton {
    if (!_preButton) {
        _preButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_preButton setTitle:@"上一页" forState:UIControlStateNormal];
        _preButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        [_preButton setTitleColor:[UIColor colorWithHexString:@"c1c4cb"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [[_preButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            strongSelf.currentPageIndex --;
            if (strongSelf.currentPageIndex < 0) {
                strongSelf.currentPageIndex = 0;
            }else{
                WARPageContentViewController *vc = [[WARPageContentViewController alloc] init];
                vc.pageLayout = [strongSelf.modelProtocol.feedLayoutArr objectAtIndex:strongSelf.currentPageIndex];
                [strongSelf updateSlideLabel];
                [strongSelf.coverVC setController:vc animated:YES isAbove:YES];
            }
            strongSelf.modelProtocol.currentPageIndex = strongSelf.currentPageIndex;
        }];
    }
    return _preButton;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一页" forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:11];
        [_nextButton setTitleColor:[UIColor colorWithHexString:@"c1c4cb"] forState:UIControlStateNormal];
        __weak typeof(self) weakSelf = self;
        [[_nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            NSArray* feedLayoutArr = strongSelf.modelProtocol.feedLayoutArr;
            
            strongSelf.currentPageIndex ++;
            if (strongSelf.currentPageIndex > feedLayoutArr.count - 1) {
                strongSelf.currentPageIndex = feedLayoutArr.count - 1;
            }else{
                WARPageContentViewController *vc = [[WARPageContentViewController alloc] init];
                vc.pageLayout = [feedLayoutArr objectAtIndex:strongSelf.currentPageIndex];
                [strongSelf updateSlideLabel];
                [strongSelf.coverVC setController:vc animated:YES isAbove:NO];
            }
            strongSelf.modelProtocol.currentPageIndex = strongSelf.currentPageIndex;
        }];
    }
    return _nextButton;
}

@end
