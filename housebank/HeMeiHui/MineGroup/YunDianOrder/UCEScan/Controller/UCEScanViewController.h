//
//  UCEScanViewController.h
//  BMS
//
//  Created by ws on 2017/5/26.
//  Copyright © 2017年 余尚祥. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^scanComplete)(NSString *str);

typedef NS_ENUM(NSInteger, ScanCodeType) {
    ScanCodeTypeBarcode,
    ScanCodeTypeQRcode,
    ScanCodeTypeAll
};


@interface UCEScanViewController : UIViewController
@property (nonatomic, weak) UINavigationController *nvController;

@property (nonatomic, copy)NSString *orderNo;
/**
 *  自定义的提示信息，可以为空
 */
@property (nonatomic,copy) NSString *customInfo;
/**
 *  二维码四个边角的颜色，默认为橙色
 */
@property (nonatomic,strong) UIColor *rectColor;
/**
 *  扫描成功后的回调函数 返回一个字符串
 */
@property (nonatomic, copy) scanComplete complete;

@property (nonatomic, assign) ScanCodeType scanCodeType;//扫描条码类型

@property (nonatomic, assign) BOOL isbackBill;
@property (nonatomic, assign) BOOL autoGoBack;//扫描完成是否返回


/*标题*/
- (void)setTitleText:(NSString *)text;

- (void)gotoNextPage:(UIViewController *)vc;
- (void)clearNo;
- (void)startScan;

@end
