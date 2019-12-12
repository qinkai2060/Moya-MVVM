//
//  WARPhotoGroupEditingViewController.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/22.
//

#import "WARPhotoBaseViewController.h"
#import "WARFinshCreatViewController.h"
#import "WARPhotoDetailsViewController.h"
#import "WARUploadingViewController.h"

@interface WARPhotoGroupEditingViewController : WARPhotoBaseViewController
@property(nonatomic,strong)WARFinshCreatViewController *finshVC;
@property(nonatomic,strong)WARPhotoDetailsViewController *DetailVC;

@property(nonatomic,strong)WARUploadingViewController *uploadVC;

@end
