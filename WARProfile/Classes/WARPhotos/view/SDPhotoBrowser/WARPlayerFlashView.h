//
//  WARPlayerFlashView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/6/7.
//

#import <UIKit/UIKit.h>

@interface WARPlayerFlashView : UIView
+ (instancetype)playerWithVideoURL:(NSURL *)videoURL ;
- (void)stop;
@end
