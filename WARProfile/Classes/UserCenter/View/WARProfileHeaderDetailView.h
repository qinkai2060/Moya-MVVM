//
//  WARProfileHeaderDetailView.h
//  WARProfile
//
//  Created by 秦恺 on 2018/6/20.
//

#import <UIKit/UIKit.h>
#import "WARProfileUserModel.h"
@interface WARProfileHeaderDetailView : UIImageView
/** icon */
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UIImageView *borderView;

@property (nonatomic, strong) UIImageView *maskView;

@property (nonatomic, strong) UILabel *nickNamelb;

@property (nonatomic, strong) UILabel *scoreLb;

@property (nonatomic, strong) UILabel *homelb;

@property (nonatomic, strong) UIButton *cameraBtn;

@property (nonatomic, strong) UIButton *publish;

@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, strong) UILabel *agelb;

@property (nonatomic, strong) UIImageView *genderBtn;

@property (nonatomic, strong) UILabel *signBtn;

@property (nonatomic, strong) UILabel *accoutlb;

@property (nonatomic, strong) UIButton *enterDataInfoBtn;

@property (nonatomic, strong) WARProfileUserModel *model;
@property (nonatomic, strong) WARProfileUserModel *otherModel;
@property (nonatomic, strong) WARProfileMasksModel *defaultModel;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, assign) BOOL isOherWindow;

@property (nonatomic, copy)   void(^didPushToEditVC)();
@end
