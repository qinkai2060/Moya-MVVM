//
//  WARMomentTools.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/23.
//

#import "WARMomentTools.h"

#import "WARMacros.h"
#import "WARActionSheet.h"

@implementation WARMomentTools

+ (void)showDeleteActionSheetWithActionHandler:(ActionSheetCompleteHandler)actionHandler {
    [WARActionSheet actionSheetWithButtonTitles:@[WARLocalizedString(@"删除")]
                                    cancelTitle:WARLocalizedString(@"取消")
                                  actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
                                      if (index == 0) {
                                          if (actionHandler) {
                                              actionHandler(index);
                                          }
                                      }
                                  } cancelHandler:^(LGAlertView * _Nonnull alertView) {} completionHandler:^{ }];
}

@end
