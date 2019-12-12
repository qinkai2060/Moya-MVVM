//
//  WARTagItem.h
//  Pods
//
//  Created by huange on 2017/8/29.
//
//

#import <Foundation/Foundation.h>

//typedef NS_ENUM(NSInteger,TagStatus) {
//    TagStatus
//};

@interface WARTagItem : NSObject

@property (nonatomic, copy) NSString *tagName;
@property (nonatomic, assign) BOOL isSelected;

@end
