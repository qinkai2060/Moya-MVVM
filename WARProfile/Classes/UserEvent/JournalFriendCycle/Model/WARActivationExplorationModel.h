//
//  WARActivationExplorationModel.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import <Foundation/Foundation.h>
#import "WARActivationExploration.h"

@interface WARActivationExplorationModel : NSObject
@property (nonatomic, copy) NSString *lastFindId; 
@property (nonatomic, copy) NSArray <WARActivationExploration *> *trackLists;
@end
