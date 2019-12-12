//
//  WARActivationExplorationLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import <Foundation/Foundation.h>

#import "WARActivationExploration.h"
#import "WARMomentTrackInfoLayout.h"

@interface WARActivationExplorationLayout : NSObject

+ (WARActivationExplorationLayout *)layoutWithActivationExploration:(WARActivationExploration *)activationExploration;

/** activationExploration */
@property (nonatomic, strong) WARActivationExploration *activationExploration;
/** trackInfoLayout */
@property (nonatomic, strong) WARMomentTrackInfoLayout *trackInfoLayout;


/** userHeaderF */
@property (nonatomic, assign) CGRect userHeaderF;
/** userNameF */
@property (nonatomic, assign) CGRect userNameF;
/** timeF */
@property (nonatomic, assign) CGRect timeF;
/** trackF */
@property (nonatomic, assign) CGRect trackF;
/** lineF */
@property (nonatomic, assign) CGRect lineF;
@end
