//
//  HFIConView.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HFIConViewStatus) {
    HFIConViewStatusNoneFllow,
    HFIConViewStatusFllowed,
    HFIConViewStatusOneSelf,
};
@protocol HFIConViewDelegate <NSObject>

- (void)avatarClick:(HFIConViewStatus)status;
- (void)followClick;


@end
NS_ASSUME_NONNULL_BEGIN

@interface HFIConView : UIView
@property(nonatomic,weak)id<HFIConViewDelegate> delegate;
- (void)status:(HFIConViewStatus)status avatarUrl:(NSString*)url;
@end

NS_ASSUME_NONNULL_END
