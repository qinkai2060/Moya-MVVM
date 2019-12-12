//
//  WARCategoriesForFaceViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/3/22.
//

#import <UIKit/UIKit.h>
#import "WARFaceBaseViewController.h"

typedef void(^WARCategoriesForFaceVCDidSaveBlock)(NSArray *array);

@interface WARCategoriesForFaceViewController : WARFaceBaseViewController


@property (nonatomic, copy)WARCategoriesForFaceVCDidSaveBlock didSaveBlock;

@property (nonatomic, copy)NSArray *categories;
@property (nonatomic, strong)WARFaceMaskModel *faceModel;


@end
