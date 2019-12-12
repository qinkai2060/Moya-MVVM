//
//  WARUploadListView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/5/7.
//

#import <UIKit/UIKit.h>
@class WARGroupModel;
@interface WARUploadListView : UIView
- (void)cleanData;
- (instancetype)initWithFrame:(CGRect)frame atGroupModel :(WARGroupModel*)groupModel;
@end
