//
//  WARFavriteShowViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/4.
//

#import "WARFavriteShowViewController.h"
#import "WARFavriteGenarlView.h"
@interface WARFavriteShowViewController ()
/**rootVC*/
@property (nonatomic,strong) UIViewController *rootVC;
@end

@implementation WARFavriteShowViewController
- (instancetype)initWithViewController:(UIViewController*)rootVC {
    if (self = [super init] ) {
        self.rootVC = rootVC;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [WARFavriteGenarlView show:self.rootVC atVC:self  withUrl:@"1111"];
}




@end
