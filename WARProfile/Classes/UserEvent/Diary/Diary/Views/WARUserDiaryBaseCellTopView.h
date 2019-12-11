//
//  WARUserDiaryBaseCellTopView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/2.
//

/**
 <#Description#>
 - <#value1#>: <#Description#>
 */
typedef NS_ENUM(NSUInteger, WARUserDiaryPlatformType) {
    WARUserDiaryPlatformTypeFriend = 1,
    WARUserDiaryPlatformTypeDouBan,
};

#import <UIKit/UIKit.h>

@class WARNewUserDiaryMoment;

@interface WARUserDiaryBaseCellTopView : UIView

@property (nonatomic, strong) WARNewUserDiaryMoment *moment;


@end
