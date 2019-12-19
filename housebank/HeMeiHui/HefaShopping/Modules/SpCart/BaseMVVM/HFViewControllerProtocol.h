//
//  HFViewControllerProtocol.h


#import <Foundation/Foundation.h>

@protocol HFViewModelProtocol;

@protocol HFViewControllerProtocol <NSObject>

@optional
- (instancetype)initWithViewModel:(id <HFViewModelProtocol>)viewModel;

- (void)hh_bindViewModel;
- (void)hh_addSubviews;
- (void)hh_layoutNavigation;
- (void)hh_getNewData;
- (void)recoverKeyboard;


@end
