//
//  WARFaceSignatureViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/23.
//

#import <UIKit/UIKit.h>
#import "WARFaceBaseViewController.h"
#import "WARGroupHomeModel.h"

typedef NS_ENUM(NSInteger, TextType) {
    FaceSignatureType,
    GroupDesType,
    GroupNoticeType
};

typedef void(^GroupDesBlock)(NSString *groupDes);

@interface WARFaceSignatureViewController : WARFaceBaseViewController

@property (nonatomic, strong) WARFaceMaskModel *currentFaceModel;

@property (nonatomic, copy) GroupDesBlock groupDesBlock;

- (id)initWithGroupHomeModel:(WARGroupHomeModel *)groupHomeModel title:(NSString *)title;

@end
