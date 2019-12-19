//
//  QRCodeImage.h
//  gcd
//
//  Created by 张磊 on 2019/4/26.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface QRCodeImage : NSObject

/**
 生成二维码方法

 @param barcode 二维码内容
 @param size 二维码大小
 @return 二维码img
 */
+(UIImage *)getQrImageWithBarcode:(NSString *)barcode Size:(float)size;
@end

NS_ASSUME_NONNULL_END
