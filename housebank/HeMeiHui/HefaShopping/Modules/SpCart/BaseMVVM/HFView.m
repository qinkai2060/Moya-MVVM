//
//  HFView.m

#import "HFView.h"


@implementation HFView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        [self hh_setupViews];
        [self hh_bindViewModel];
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame  WithViewModel:(id<HFViewModelProtocol>)viewModel
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        [self hh_setupViews];
        [self hh_bindViewModel];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self hh_setupViews];
        [self hh_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<HFViewModelProtocol>)viewModel {
    
    self = [super init];
    if (self) {
        
        [self hh_setupViews];
        [self hh_bindViewModel];
    }
    return self;
}

- (void)hh_bindViewModel {
}

- (void)hh_setupViews {
}

- (void)hh_addReturnKeyBoard {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        

    }];
    [self addGestureRecognizer:tap];
}


@end
