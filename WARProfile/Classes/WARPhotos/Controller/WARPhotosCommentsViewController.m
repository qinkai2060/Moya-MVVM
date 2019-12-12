//
//  WARPhotosCommentsViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/4/11.
//

#import "WARPhotosCommentsViewController.h"
#import "WARMacros.h"
@interface WARPhotosCommentsViewController ()

@end

@implementation WARPhotosCommentsViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = WARLocalizedString(@"评论");
}
- (WARCommentModuleType)commentModuleType{
    return WARCommentPhotoType;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)inputViewWillSendMsgWithParam {
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    if (self.accountid.length >0) {
        [paramDict setObject:self.accountid forKey:@"repliedAcctId"];
    }
    return paramDict;
}

@end
