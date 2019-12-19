//
//  PersonInformationCommentFile.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#ifndef PersonInformationCommentFile_h
#define PersonInformationCommentFile_h


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,PersonInformationType) {
    PersonInformationType_Head         = 1,//头像
    PersonInformationType_NickName     = 2,// 昵称
    PersonInformationType_Name         = 3,//姓名
    PersonInformationType_Sex          = 4,//性别
    PersonInformationType_ContactPhone = 5,//联系电话
    PersonInformationType_RefillPhone  = 6,//备用电话
    PersonInformationType_Email        = 7,//电子邮箱
    PersonInformationType_Address      = 8,//通讯地址
    PersonInformationType_IDNumber     = 9,//证件号码
    PersonInformationType_IDPicture    = 10,//证件图片
    PersonInformationType_BankNubmer   = 11//银行卡号
};


#endif /* PersonInformationCommentFile_h */
