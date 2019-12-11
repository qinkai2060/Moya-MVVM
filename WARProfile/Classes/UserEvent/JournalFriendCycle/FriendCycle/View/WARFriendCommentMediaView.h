//
//  WARFriendCommentMediaView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/7.
//

#import <UIKit/UIKit.h>
#import "WARFriendCommentLayout.h"
#import "WARMomentMedia.h"

typedef void(^FriendPlayVideoBlock)(WARMomentMedia *video);
typedef void(^FriendShowPhotoBrowerBlock)(NSArray *photos, NSInteger index);

@interface WARFriendCommentMediaView : UIView
@property (nonatomic, strong) WARFriendCommentLayout* layout;
@property (copy, nonatomic) FriendShowPhotoBrowerBlock showPhotoBrower;
@property (copy, nonatomic) FriendPlayVideoBlock playVideo;
@end
