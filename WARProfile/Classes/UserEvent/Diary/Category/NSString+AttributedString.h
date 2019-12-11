//
//  NSString+AttributedString.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/5.
//

#import <Foundation/Foundation.h> 
#import <UIKit/UIKit.h>

@interface NSString (AttributedString)

+ (CGSize)getStringRect:(NSAttributedString *)aString width:(CGFloat)width height:(CGFloat)height;

@end
