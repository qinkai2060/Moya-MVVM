//
//  HFUserLoginAlertView.m
//  HeMeiHui
//
//  Created by usermac on 2019/8/26.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFUserLoginAlertView.h"
#import "UIView+addGradientLayer.h"
#import "HFTextCovertImage.h"
@interface HFUserLoginAlertView ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UITextViewDelegate>
@property(nonatomic,strong)UIView *cornerView;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)WKWebView *contentViewTX;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UITextView *bottomViewTX;

@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *sureBtn;

@property(nonatomic,strong)UIButton *errorBtn;
//匹配纪录
@property(nonatomic,strong)NSArray *bottomRangeList;
@property(nonatomic,strong)NSString *bottomTX;
@end
@implementation HFUserLoginAlertView
+ (void)showAlertViewType:(HFUserLoginAlertViewType)type title:(NSString*)title contextTX:(NSString *)contentUrl bottomTX:(NSString*)bottomTX bottomRangeList:(NSArray*)bottomRangeList cancelTitle:(NSString*)cancelText  cancelBlock:(cancelUserBlock)cancel sureTitle:(NSString*)sureText sureBlock:(sureUserBlock)sure  didTextView:(didTextView)didTextViewBlock{
    HFUserLoginAlertView *alertV = [[HFUserLoginAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds withType:type title:title contextTX:contentUrl  bottomTX:bottomTX bottomRangeList:bottomRangeList cancelTitle:cancelText cancelBlock:cancel sureTitle:sureText sureBlock:sure didTextView:didTextViewBlock];
    [[UIApplication sharedApplication].keyWindow addSubview:alertV];
}
- (instancetype)initWithFrame:(CGRect)frame withType:(HFUserLoginAlertViewType)type  title:(NSString*)title contextTX:(NSString *)contentUrl  bottomTX:(NSString*)bottomTX bottomRangeList:(NSArray*)bottomRangeList cancelTitle:(NSString*)cancelText  cancelBlock:(cancelUserBlock)cancel sureTitle:(NSString*)sureText sureBlock:(sureUserBlock)sure  didTextView:(didTextView)didTextViewBlock{
    if (self = [super initWithFrame:frame]) {
//        [self clearWebCache];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.25];
        if (type == HFUserLoginAlertViewTypeRegsiterProtocol) {
            self.titleLb.text = title;
            self.bottomTX = bottomTX;
         
            self.bottomViewTX.attributedText = [HFTextCovertImage nodeAttributesStringText:bottomTX TextColor:[UIColor colorWithHexString:@"333333"] Font:[UIFont systemFontOfSize:14]];
            NSMutableAttributedString *bottomAtrrubute = [[NSMutableAttributedString alloc] initWithAttributedString:self.bottomViewTX.attributedText];
            self.bottomRangeList = bottomRangeList;
            for (NSString *rangeStr in bottomRangeList) {
                
                [bottomAtrrubute addAttribute:NSLinkAttributeName
                                        value:[NSString stringWithFormat:@"%@://",[HFUserLoginAlertView urlStr:rangeStr]]
                                        range:[[bottomAtrrubute string] rangeOfString:rangeStr]];
                [bottomAtrrubute addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor colorWithHexString:@"4D88FF"]
                                         range:[[bottomAtrrubute string] rangeOfString:rangeStr]];
                
            }
            self.bottomViewTX.attributedText  = [bottomAtrrubute copy];
            self.didTextView = didTextViewBlock;
      
            [self.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
            [self hh_setupViews_rp];
            [self.contentViewTX loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentUrl]]];
            [self.sureBtn setTitle:sureText forState:UIControlStateNormal];
        }else {
            self.titleLb.text = title;
//            [self initWKWebView];/
            [self hh_setupViews_rp1];
       
            [self.cancelBtn setTitle:cancelText forState:UIControlStateNormal];
            [self.contentViewTX loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentUrl]]];
            [self.sureBtn setTitle:sureText forState:UIControlStateNormal];
        }
        self.sureblock = sure;
        self.cancelblock = cancel;
        [HFUserLoginAlertView exChangeOut:self.cornerView dur:0.3];
    }
    return self;
}
- (void)initWKWebView {
    
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    preferences.javaScriptEnabled = YES;
    configuration.preferences = preferences;
    self.contentViewTX = [[WKWebView alloc] initWithFrame:CGRectMake(20, self.titleLb.bottom+15, self.cornerView.width-40, 175) configuration:configuration];
    
    NSString *encodedString = [@"https://m.hfhomes.cn/html/common/agreement-app2.html?hideTitle=1" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *weburl = [NSURL URLWithString:encodedString];
    [self.contentViewTX loadRequest:[NSURLRequest requestWithURL:weburl]];
    self.contentViewTX.UIDelegate = self;
    self.contentViewTX.navigationDelegate = self;
    [self.contentViewTX.scrollView setContentOffset:CGPointMake(0, 0)];

    
}
- (void)clearWebCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        NSSet *websiteDataTypes
        
        = [NSSet setWithArray:@[
                                WKWebsiteDataTypeDiskCache,
                                
                                WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                
                                WKWebsiteDataTypeLocalStorage,
                                
                                WKWebsiteDataTypeCookies,
                                
                                WKWebsiteDataTypeSessionStorage,
                                
                                WKWebsiteDataTypeIndexedDBDatabases,
                                
                                WKWebsiteDataTypeWebSQLDatabases
                                ]];
        
        //// All kinds of data
        
        //NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        
        //// Date from
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        
        //// Execute
        
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            // Done
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}
+ (NSString*)urlStr:(NSString*)rangeStr {
    if ([rangeStr isEqualToString:@"《合美惠用户注册协议》"]) {
        return @"clickRegProtocol";
    }else if ([rangeStr isEqualToString:@"《合美惠隐私政策》"]){
        return @"clickPrivate";
    }else if ([rangeStr isEqualToString:@"《订单共享与安全》"]) {
        return @"clickOrder";
    }
    return @"";
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange{
    NSString *URLSchem = [URL scheme];
    if (URLSchem.length >0) {
        if (self.didTextView) {
            self.didTextView([URL scheme]);
        }
        return NO;
    }
    return YES;
}
- (void)hh_setupViews_rp{
    [self addSubview:self.cornerView];
    [self.cornerView addSubview:self.titleLb];
    [self.cornerView addSubview:self.contentViewTX];
    [self.cornerView addSubview:self.lineView];
    [self.cornerView addSubview:self.bottomViewTX];
    [self.cornerView addSubview:self.cancelBtn];
    [self.cornerView addSubview:self.sureBtn];
    self.cornerView.frame = CGRectMake(30, 0, ScreenW-60, 440);
    
    self.titleLb.frame = CGRectMake(10, 15, self.cornerView.width-20, 25);
    self.contentViewTX.frame = CGRectMake(20, self.titleLb.bottom+15, self.cornerView.width-40, 175);
    self.lineView.frame = CGRectMake(0, self.contentViewTX.bottom+15, self.cornerView.width, 1);
    CGFloat height = [self.bottomViewTX sizeThatFits:CGSizeMake(self.cornerView.width-40, MAXFLOAT)].height;
    
    self.bottomViewTX.frame = CGRectMake(20, self.lineView.bottom+15, self.cornerView.width-40, height);
    
    CGFloat btnW = (self.cornerView.width - 40-10)*0.5;
    self.cancelBtn.frame = CGRectMake(20, self.bottomViewTX.bottom+20, btnW, 40);
    self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.cornerRadius = 20;
    self.cancelBtn.layer.masksToBounds = YES;
    self.sureBtn.frame = CGRectMake(self.cancelBtn.right+10, self.bottomViewTX.bottom+20, btnW, 40);
    [self.sureBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    self.sureBtn.layer.cornerRadius = 20;
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn bringSubviewToFront:self.sureBtn.titleLabel];
    
    self.cornerView.frame = CGRectMake(30, 0, ScreenW-60, self.cancelBtn.bottom+20);
    self.cornerView.center = self.center;
}
- (void)hh_setupViews_rp1{
    [self addSubview:self.cornerView];
    [self.cornerView addSubview:self.titleLb];
    [self.cornerView addSubview:self.contentViewTX];
    [self.cornerView addSubview:self.cancelBtn];
    [self.cornerView addSubview:self.sureBtn];
    
    self.cornerView.frame = CGRectMake(30, 0, ScreenW-60, 440);
    
    self.titleLb.frame = CGRectMake(10, 15, self.cornerView.width-20, 25);
    self.contentViewTX.frame = CGRectMake(20, self.titleLb.bottom+15, self.cornerView.width-40, 175);
    CGFloat btnW = (self.cornerView.width - 40-10)*0.5;
    self.cancelBtn.frame = CGRectMake(20, self.contentViewTX.bottom+20, btnW, 40);
    self.cancelBtn.layer.borderColor = [UIColor colorWithHexString:@"DDDDDD"].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    self.cancelBtn.layer.cornerRadius = 20;
    self.cancelBtn.layer.masksToBounds = YES;
    self.sureBtn.frame = CGRectMake(self.cancelBtn.right+10, self.contentViewTX.bottom+20, btnW, 40);
    [self.sureBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    self.sureBtn.layer.cornerRadius = 20;
    self.sureBtn.layer.masksToBounds = YES;
    [self.sureBtn bringSubviewToFront:self.sureBtn.titleLabel];
    
    self.cornerView.frame = CGRectMake(30, 0, ScreenW-60, self.sureBtn.bottom+20);
    self.cornerView.center = self.center;
}
- (void)sureClickEvent:(UIButton*)btn {

    [HFUserLoginAlertView exChangeDisappear:self.cornerView dur:0.3];
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.sureblock) {
            self.sureblock(self);
        }
        UIView *v = self;
        [v removeFromSuperview];
    }];
}

- (void)cancelClickEvent:(UIButton*)btn {

    [HFUserLoginAlertView exChangeDisappear:self.cornerView dur:0.3];
    self.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (self.cancelblock) {
            self.cancelblock(self);
        }
        UIView *v = self;
        [v removeFromSuperview];
        
    }];
}

- (UIView *)cornerView {
    if (!_cornerView) {
        _cornerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW-48*2, 150)];
        _cornerView.center = CGPointMake(ScreenW*0.5, ScreenH*0.5);
        _cornerView.layer.cornerRadius = 10;
        _cornerView.layer.masksToBounds = YES;
        _cornerView.backgroundColor = [UIColor whiteColor];
    }
    return _cornerView;
}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] init];
        _titleLb.textColor = [UIColor blackColor];
        _titleLb.font = [UIFont boldSystemFontOfSize:18];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.numberOfLines = 0;
    }
    return _titleLb;
}
- (WKWebView *)contentViewTX {
    if (!_contentViewTX) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.javaScriptEnabled = YES;
        configuration.preferences = preferences;
        _contentViewTX = [[WKWebView alloc] initWithFrame:CGRectMake(20, self.titleLb.bottom+15, self.cornerView.width-40, 175) configuration:configuration];
        _contentViewTX.UIDelegate = self;
        _contentViewTX.navigationDelegate = self;
        [_contentViewTX.scrollView setContentOffset:CGPointMake(0, 0)];
    }
    return _contentViewTX;
}
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _lineView;
}
- (UITextView *)bottomViewTX {
    if (!_bottomViewTX) {
        _bottomViewTX = [[UITextView alloc] init];
        _bottomViewTX.delegate = self;
        _bottomViewTX.editable = NO;
    }
    return _bottomViewTX;
}

- (UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.cornerView.width*0.5, self.cornerView.height-45, self.cornerView.width*0.5, 45)];
        
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sureBtn addTarget:self action:@selector(sureClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.cornerView.height-45, self.cornerView.width*0.5, 45)];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        [_cancelBtn addTarget:self action:@selector(cancelClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}
+ (void)exChangeOut:(UIView*)changeOutView dur:(CFTimeInterval)dur
{
    
    CAKeyframeAnimation* animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = dur;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray* values = [NSMutableArray array];
    
    for (int m = 0; m<10; m++)
    {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale((m+1)*0.1,(m+1)*0.1,(m+1)*0.1)]];
    }
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1,1.1,1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,1.2,1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3,1.3,1.3)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2,1.2,1.2)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1,1.1,1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0,1.0,1.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [changeOutView.layer addAnimation:animation forKey:nil];
}
+ (void)exChangeDisappear:(UIView*)disappearView dur:(CFTimeInterval)time
{
    
    CAKeyframeAnimation* animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = time;
    
    //animation.delegate = self;
    
    animation.removedOnCompletion = NO;
    
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray* values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 0.6)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.4, 0.4, 0.4)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 0.2)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 0.0)]];
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [disappearView.layer addAnimation:animation forKey:nil];
    
}
@end
