//
//  SpDetailOverFooterView.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import "SpDetailOverFooterView.h"

// Controllers

// Models

// Views
#import "DCLIRLButton.h"
// Vendors

// Categories

// Others

@interface SpDetailOverFooterView ()<WKNavigationDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger lastcontentOffset; //添加此属性的作用，根据差值，判断ScrollView是上滑还是下拉

@property (nonatomic, assign) CGFloat wkHeight;

@property (nonatomic, assign) BOOL isZCObserver;
@end

@implementation SpDetailOverFooterView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imgTitle = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_detail_title"]];
    [self addSubview:imgTitle];
    [imgTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(21);
        make.size.mas_equalTo(CGSizeMake(190, 14));
    }];
    
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 56, self.dc_width, self.dc_height-56)];
    _webView.navigationDelegate=self;
    _webView.scrollView.bounces = NO;
    _webView.scrollView.delegate = self;
    _webView.scrollView.scrollEnabled = NO;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView setNeedsLayout];
    if (@available(iOS 11.0, *)) {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        
    }
    [self addSubview:_webView];
//     [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
    [self resetDataView];
   
   

}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    NSLog(@"Height is changed! new=%f", [[change objectForKey:@"new"] CGPointValue].y);
    [_webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        NSLog(@"Height is changed! new=%f", [result floatValue]);

    }];

        if (self.wkHeight < [[change objectForKey:@"new"] CGPointValue].y) {
            self.wkHeight = [[change objectForKey:@"new"] CGPointValue].y;
            _webView.frame = CGRectMake(0, 56, self.dc_width, self.wkHeight);
            if (self.wkWebViewScrollViewFinshBlock) {
                self.wkWebViewScrollViewFinshBlock(self.wkHeight + 56);
            }
        }
    
    
    
    
    
}
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat hight = scrollView.frame.size.height;
//    CGFloat contentOffset = scrollView.contentOffset.y;
//    CGFloat distanceFromBottom = scrollView.contentSize.height - contentOffset;
//    CGFloat offset = contentOffset - self.lastcontentOffset;
//    self.lastcontentOffset = contentOffset;
//
//    if (offset > 0 && contentOffset > 0) {
//        NSLog(@"上拉行为");
//    }
//    if (offset < 0 && distanceFromBottom > hight) {
//        NSLog(@"下拉行为");
//    }
//    if (contentOffset == 0) {
//        NSLog(@"滑动到顶部");
//        if (self.wkWebViewScrollViewBlock) {
//            self.wkWebViewScrollViewBlock();
//        }
//
//    }
//    if (distanceFromBottom < hight) {
//        NSLog(@"滑动到底部");
//    }
//
//}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return nil;
}
- (NSString *)reSizeImageWithHTMLHadHead:(NSString *)html {
    //    CGFloat with=[UIScreen mainScreen].bounds.size.width;
    ManagerTools *manageTools =  [ManagerTools ManagerTools];
    return [html stringByReplacingOccurrencesOfString:@"src=\"" withString:[NSString stringWithFormat:@"src=\"%@", manageTools.appInfoModel.imageServerUrl]];
    
}
-(void)resetDataView
{
    NSString *str=self.detailModel.data.product.productDescription;
    //     NSString *str=@"<img src=\"/user/community/1544863103/ncddxs93tib23y72.jpg!PD750\" style=\"width:100%\">";
    NSString *htmlStr= [self reSizeImageWithHTMLHadHead:str];
    if (str!=nil&&![str isEqualToString:@""]) {
        [_webView loadHTMLString:htmlStr baseURL:nil];
    }
    
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //修改字体大小 300%
    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '300%'"completionHandler:nil];
    
    //    //修改字体颜色  #9098b8
    //    [ webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#222222'"completionHandler:nil];
    
    [webView evaluateJavaScript:@"document.body.scrollWidth"completionHandler:^(id _Nullable result,NSError * _Nullable error){
        
        NSLog(@"scrollWidth高度：%.2f",[result floatValue]);
        CGFloat ratio =  CGRectGetWidth(self.webView.frame) /[result floatValue];
        
        [webView evaluateJavaScript:@"document.body.scrollHeight"completionHandler:^(id _Nullable result,NSError * _Nullable error){
            NSLog(@"scrollHeight高度：%.2f",[result floatValue]);
            NSLog(@"scrollHeight计算高度：%.2f",[result floatValue]*ratio);
            CGFloat newHeight = [result floatValue]*ratio;
            
            
            if (self.wkHeight < newHeight) {
                self.wkHeight = newHeight;
            self.webView.frame = CGRectMake(0, 56, self.dc_width, self.wkHeight);
            
            if (self.wkWebViewScrollViewFinshBlock) {
                self.wkWebViewScrollViewFinshBlock(self.wkHeight + 56);
            }
        }
            //KVO监听网页内容高度变化
            if (newHeight < CGRectGetHeight(self.frame)) {
                
                //如果webView此时还不是满屏，就需要监听webView的变化  添加监听来动态监听内容视图的滚动区域大小
                [self.webView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
                self.isZCObserver = YES;
            }
        }];
        
    }];

    
}


- (void)setDetailModel:(GoodsDetailModel *)detailModel{
    _detailModel = detailModel;
    [self resetDataView];
}
#pragma mark - Setter Getter Methods
- (void)dealloc
{
    if (self.isZCObserver) {
        [self.webView removeObserver:self forKeyPath:@"contentSize"];
    }
}

@end
