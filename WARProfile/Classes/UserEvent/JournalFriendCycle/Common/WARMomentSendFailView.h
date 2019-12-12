//
//  WARMomentSendFailView.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/26.
//

#import <UIKit/UIKit.h>

typedef void(^WARMomentSendFailViewBlock)(void);

@interface WARMomentSendFailView : UIView
/** didDeleteBlock */
@property (nonatomic, strong) WARMomentSendFailViewBlock didDeleteBlock;
/** didSendBlock */
@property (nonatomic, strong) WARMomentSendFailViewBlock didSendBlock;
@end
