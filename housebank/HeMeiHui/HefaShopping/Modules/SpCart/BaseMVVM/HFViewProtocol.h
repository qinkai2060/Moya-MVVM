//
//  HFViewProtocol.h


#import <Foundation/Foundation.h>

@protocol HFViewModelProtocol;

@protocol HFViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <HFViewModelProtocol>)viewModel;
- (id)initWithFrame:(CGRect)frame  WithViewModel:(id<HFViewModelProtocol>)viewModel;
- (void)hh_bindViewModel;
- (void)hh_setupViews;
- (void)hh_addReturnKeyBoard;

@end
