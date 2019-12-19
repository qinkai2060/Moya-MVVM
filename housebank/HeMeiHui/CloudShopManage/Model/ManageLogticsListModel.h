//
//  ManageLogticsListModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageLogticsListModel : NSObject<JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * context;
@property (nonatomic, copy) NSString * time;
@end

NS_ASSUME_NONNULL_END
