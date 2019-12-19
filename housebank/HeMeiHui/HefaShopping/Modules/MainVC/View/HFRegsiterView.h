//
//  HFRegsiterView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFRegsiterView : HFView
@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *codeView;
@property(nonatomic,strong)UIImageView *iconHImgV;
+ (void)show:(NSDictionary*)dict;
- (void)code:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
