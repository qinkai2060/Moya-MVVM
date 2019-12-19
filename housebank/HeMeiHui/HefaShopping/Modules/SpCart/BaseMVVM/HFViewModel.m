//
//  WARViewModel.m


#import "HFViewModel.h"

@implementation HFViewModel


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    HFViewModel *viewModel = [super allocWithZone:zone];
    
    if (viewModel) {
        
        [viewModel hh_initialize];
    }
    return viewModel;
}

- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
    }
    return self;
}

//- (RACRequest *)request {
//    
//    if (!_request) {
//        
//        _request = [RACRequest request];
//    }
//    return _request;
//}

- (void)hh_initialize {}


@end
