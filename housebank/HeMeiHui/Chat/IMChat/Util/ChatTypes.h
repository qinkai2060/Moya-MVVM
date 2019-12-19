//
//  ChatTypes.h
//  Pods
//
//  Created by zhangwenchao on 16/12/8.
//
//

#ifndef ChatTypes_h
#define ChatTypes_h

typedef NS_OPTIONS(NSUInteger, DXChatBarMoreItemOption) {
    DXChatBarMoreItemTypeTakePic = 1 << 0,
    DXChatBarMoreItemTypePhoto = 1 << 1,
    DXChatBarMoreItemTypeVideo = 1 << 2,
    DXChatBarMoreItemTypeLocation = 1 << 3,
    DXChatBarMoreItemTypeBasic = 0xF,
    DXChatBarMoreItemTypeRedPaper = 1 << 4,
    DXChatBarMoreItemTypeCoupon = 1 << 5,
    DXChatBarMoreItemTypeWeiTui = 1 << 6,
    DXChatBarMoreItemTypeGoods = 1 << 7,
    DXChatBarMoreItemTypeReceipt = 1 << 8,
    DXChatBarMoreItemTypeSpeakSkill = 1 << 9,
    DXChatBarMoreViewTypeAll = 0x3FF
};


#endif /* ChatTypes_h */
