//
//  MAPUserAnnotion.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAPUserAnnotion : NSObject<MAAnnotation>
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@end

NS_ASSUME_NONNULL_END
