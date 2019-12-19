//
//  CLPictureAmplifyViewController.h
//  CLPictureAmplify
//
//  Created by darren on 16/8/25.
//  Copyright © 2016年 shanku. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLPictureAmplifyViewController : UIViewController
// 此处传的是image类型的 图片数组
@property (nonatomic,strong) NSArray *picArray;

// 此处传的是图片的url 数组
@property (nonatomic, strong) NSArray *picUrlArray;

@property (nonatomic,assign) NSInteger touchIndex;

/**是否要展示下面的lable*/
@property (nonatomic,assign) BOOL hiddenTextLable;

@end
