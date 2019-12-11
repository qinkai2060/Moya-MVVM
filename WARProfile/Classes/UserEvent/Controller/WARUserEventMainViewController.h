//
//  WARUserEventMainViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import <UIKit/UIKit.h>
#import "WARCPageTitleView.h"
#import "WARCPageContentView.h"
@class WARUserEventMainViewController;
@protocol WARUserEventMainViewControllerDelegete <NSObject>
- (void)UserEventMainViewController:(WARUserEventMainViewController*)vc scrollindex:(NSInteger)pageContentViewindex progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex;
@end
@interface WARUserEventMainViewController : UIViewController
//@property (nonatomic,retain) WARCPageTitleView *pageTitleView;
@property (nonatomic,assign) NSInteger currentControllerIndex;
@property (nonatomic,assign) NSInteger currentControllerIndex2;
@property (nonatomic,retain)  WARCPageContentView *pageContentView;
@property (nonatomic,weak)id <WARUserEventMainViewControllerDelegete> delegete;

@end
