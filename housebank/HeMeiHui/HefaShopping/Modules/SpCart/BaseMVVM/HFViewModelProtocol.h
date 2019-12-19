//
//  HFViewModelProtocol.h

#import <Foundation/Foundation.h>
//#import "RACRequest.h"
@protocol HFViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

//@property (strong, nonatomic)RACRequest *request;

/**
 *  初始化
 */
- (void)hh_initialize;

@end
