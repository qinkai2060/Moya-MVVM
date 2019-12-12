//
//  WARPhotoTempBrowserViewController.m
//  WARProfile
//
//  Created by 秦恺 on 2018/5/4.
//

#import "WARPhotoTempBrowserViewController.h"
#import "SDPhotoBrowser.h"
#import "UIImage+WARBundleImage.h"
#import "UIMessageInputView.h"
#import "WARCommentTheme.h"
#import "WARProgressHUD.h"
#import "ReactiveObjC.h"
#import "WARActionSheet.h"
#import "WARBaseMacros.h"
#import "WARPhotoBrowserToolView.h"
#import "WARProfileNetWorkTool.h"
#import "WARPhotosCommentsViewController.h"
#import "WARPhotoMiaoshuKeyView.h"
#import "UIColor+WARCategory.h"
#import "SDBrowserImageView.h"
#import "WARPhotoKeyBordSiginView.h"
#import "WARDownPhotoManger.h"
@interface WARPhotoTempBrowserViewController ()
@property(nonatomic,strong) SDPhotoBrowser *photoBrowser;
//@property(nonatomic,strong) UICollectionView *currentImgV;
@property(nonatomic,assign) NSInteger currimageIndex;
//@property(nonatomic,strong) WARGroupModel *model;
@property(nonatomic,strong) WARPictureInfoCommentModel *commentModel;
@property (nonatomic, strong) UIMessageInputView *myMsgInputView;
@property (nonatomic, strong) NSMutableArray  *pictureArray;
@property (nonatomic, strong) UIView  *superView;
@property (nonatomic,strong) WARPhotoBrowserToolView *toolView;
@property (nonatomic,strong) WARPhotoMiaoshuKeyView *keyBordInputView;
@property (nonatomic,strong) WARPhotoKeyBordSiginView *bordSignView;
@property (nonatomic,strong) UIView *miaoshuV;
@property (nonatomic,strong) UILabel *miaoslb;
@property (nonatomic,strong) NSString *accoutId;
@end

@implementation WARPhotoTempBrowserViewController

- (instancetype)initWithModel:(WARGroupModel *)model atCurrentindex:(NSInteger)currimgeindex  atImagePictureArray:(NSArray*)imageArray atAccountID:(NSString *)accountId {
    if (self = [super initWithModel:model]) {
        
        self.accoutId = accountId;
  
        self.currimageIndex = currimgeindex;
        
        [self.pictureArray addObjectsFromArray: imageArray];
  
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // [_myMsgInputView prepareToShow];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_myMsgInputView prepareToDismiss];
    [self.photoBrowser stop];
}
- (void)initSubViews{
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.photoBrowser];
    [self.view addSubview:self.customBar];
    self.toolView = [[WARPhotoBrowserToolView alloc] initWithFrame:CGRectMake(0, kScreenHeight-80, kScreenSize.width, 80)];
    self.toolView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.toolView];
    [self.view addSubview:self.keyBordInputView];
    [self.view addSubview:self.miaoshuV];
    [self.miaoshuV addSubview:self.miaoslb];
    [self.view addSubview:self.bordSignView];
    [self settingStyle];
    
    _myMsgInputView = [UIMessageInputView messageInputViewWithType:UIMessageInputViewContentTypeTweet];
    _myMsgInputView.isAlwaysShow = YES;
    _myMsgInputView.delegate = self;
    _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
    _myMsgInputView.moduleType =   WARCommentPhotoType;
    WARPictureModel *urlStr = self.pictureArray[self.currimageIndex];
    if ([urlStr.type isEqualToString:@"VIDEO"]) {
        _myMsgInputView.toId = urlStr.videoId ;
    }else{
        _myMsgInputView.toId = urlStr.pictureId;
    }

    [self settingFrame];
    [self addClickEvent];
}
- (void)settingFrame {
    
    
    WARPictureModel *model = self.pictureArray[self.currimageIndex];
    if (model.desc.length) {
        self.miaoslb.text = model.desc;
        CGSize textSize   =   [model.desc boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        
        self.miaoshuV.frame = CGRectMake(0, kScreenSize.height-80-textSize.height-20, kScreenWidth, textSize.height+20);
        self.miaoslb.frame = CGRectMake(10, 10, kScreenWidth-20, textSize.height);
    }
}
- (void)addClickEvent {
    [self.toolView.clickLikeBtn addTarget:self action:@selector(ClickLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView.goComentsBtn addTarget:self action:@selector(ClickComents:) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView.goDescrptionBtn addTarget:self action:@selector(ClickMiaoshEvent:) forControlEvents:UIControlEventTouchUpInside];
    //[self.toolView.goMoreBtn addTarget:self action:@selector(ClickMoreEvent:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBordShow:)];
    [self.bordSignView addGestureRecognizer:tap];
}
- (void)settingStyle {
    self.customBar.dl_alpha = 0;
    self.customBar.lineButton .hidden = YES;
    self.customBar.rightbutton .hidden = YES;
    self.customBar.backgroundColor = [UIColor clearColor];
    [self.customBar.button setImage:[UIImage war_imageName:@"chat_back" curClass:self curBundle:@"WARChat.bundle"]  forState:UIControlStateNormal];
    self.toolView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
}

- (void)loadCommentData {
    WS(weakself);
    WARPictureModel *model = self.pictureArray[self.currimageIndex];
    NSString *commentid = @"";
    if ([model.type isEqualToString:@"VIDEO"]) {
        commentid = model.videoId;
    }else{
        commentid = model.pictureId;
    }
    [WARProfileNetWorkTool getPhotoCommentCount:model.albumId atPictureId:commentid atWithAccountID:self.accoutId CallBack:^(id response) {
        WARPictureInfoCommentModel *commentModel = [[WARPictureInfoCommentModel alloc] init];
        [commentModel praseData:response];
        weakself.commentModel = commentModel;
        [self.toolView.clickLikeBtn setTitle:commentModel.thumbCount forState:UIControlStateNormal];
        [self.toolView.goComentsBtn setTitle:commentModel.commentCount forState:UIControlStateNormal];
        
    } failer:^(id response) {
        
    }];
    
}
- (void)keyBordShow:(id)sender{
    [_myMsgInputView prepareToShow];
    [self messageInputViewBecomeFirstResponder:YES];
    
    
}
- (WARPhotoKeyBordSiginView *)bordSignView{
    if (!_bordSignView) {
        _bordSignView = [[WARPhotoKeyBordSiginView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-50, kScreenSize.width, 50)];
    }
    return _bordSignView;
}
- (void)ClickComents:(UIButton*)btn{
    WARPictureModel *urlStr = self.pictureArray[self.currimageIndex];
    NSString *commentid = @"";
    if ([urlStr.type isEqualToString:@"VIDEO"]) {
        commentid = urlStr.videoId;
    }else{
        commentid = urlStr.pictureId;
    }
    WARPhotosCommentsViewController *photoComments = [[WARPhotosCommentsViewController alloc] initCommentsVCWithItemId:commentid];
    photoComments.accountid = self.accoutId;
    [self.navigationController pushViewController:photoComments animated:YES];
}
- (void)ClickMoreEvent:(UIButton*)btn {
    NSArray *array = @[];

        array = @[@"下载",@"分享",@"文字识别",@"删除"];

    [WARActionSheet actionSheetWithButtonTitles:array cancelTitle:@"取消" actionHandler:^(LGAlertView * _Nonnull alertView, NSUInteger index, NSString * _Nullable title) {
        if(index == 0){
            WARPictureModel *urlStr = self.pictureArray[self.currimageIndex];
            WARGroupModel *model = [[WARGroupModel alloc] init];
            model.albumId = urlStr.albumId;
            
            [[WARDownPhotoManger sharedDownManager] downDataCurrentGroupModel:model Source:self.pictureArray atIndex:self.currimageIndex];
            
        }
        if([title isEqualToString:@"删除"]) {
            WARPictureModel *urlStr = self.pictureArray[self.currimageIndex];
            NSString *commentid = @"";
            if ([urlStr.type isEqualToString:@"VIDEO"]) {
                commentid = urlStr.videoId;
            }else{
                commentid = urlStr.pictureId;
            }
            [WARProfileNetWorkTool deleteSelectPhotos:@[commentid] photoID:urlStr.albumId CallBack:^(id response) {
                [WARProgressHUD showSuccessMessage:@"删除成功"];
            } failer:^(id response) {
                [WARProgressHUD showSuccessMessage:@"删除失败"];
            }];
        }
    } cancelHandler:^(LGAlertView * _Nonnull alertView) {
        
    } completionHandler:^{
        
    }];
}
- (void)ClickMiaoshEvent:(UIButton*)btn{
    
    self.keyBordInputView.hidden = NO;
    self.bordSignView.hidden = YES;
    [self.keyBordInputView.textFiedView becomeFirstResponder];
}
- (void)ClickLike:(UIButton*)btn{
    btn.selected = !btn.selected;
    WARPictureModel *urlStr = self.pictureArray[self.currimageIndex];
    
    NSString *thumbState = @"";
    if (btn.selected) {
        thumbState = @"UP";
    }else{
        thumbState = @"DOWN";
    }
    NSString *commentid = @"";
    if ([urlStr.type isEqualToString:@"VIDEO"]) {
        commentid = urlStr.videoId;
    }else{
        commentid = urlStr.pictureId;
    }
   NSDictionary *params = @{@"bbsId":commentid,@"msgId":commentid,@"thumbState":thumbState,@"thumbedAcctId":self.accoutId};
    
    WS(weakself);
    [WARProfileNetWorkTool postthumbClickLikeWith:commentid atThumbState:thumbState params:params CallBack:^(id response){
        NSInteger thumbCount = [weakself.commentModel.thumbCount integerValue];
        if ([thumbState isEqualToString:@"UP"]) {
            
            thumbCount++;
            
        }else{
            thumbCount--;
        }
        weakself.commentModel.thumbCount = [NSString stringWithFormat:@"%ld",thumbCount];
        //        [self.pictureArray replaceObjectAtIndex:self.currimageIndex withObject:urlStr];
        [btn setTitle:weakself.commentModel.thumbCount forState:UIControlStateNormal];
    } failer:^(id response) {
        
    }];
}
- (void)rightAction{
    
}
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [WARProgressHUD showSuccessMessage:@"下载失败"];
        
    } else {
        
        [WARProgressHUD showSuccessMessage:@"下载成功"];
        
    }
    
    
}
- (WARPhotoMiaoshuKeyView *)keyBordInputView{
    if (!_keyBordInputView) {
        _keyBordInputView = [[WARPhotoMiaoshuKeyView alloc] initWithFrame:CGRectMake(0, kScreenSize.height-44, kScreenWidth, 44)];
        _keyBordInputView.hidden = YES;
        _keyBordInputView.textFiedView.delegate = self;
    }
    return _keyBordInputView;
}
- (SDPhotoBrowser *)photoBrowser{
    if (!_photoBrowser) {
        _photoBrowser = [[SDPhotoBrowser alloc] init];
        _photoBrowser.frame =self.view.bounds;
        _photoBrowser.delegate = self;
        
        
        _photoBrowser.currentImageIndex = self.currimageIndex;
        _photoBrowser.scrollendIndex = self.currimageIndex;

        _photoBrowser.urlID = @"";
        _photoBrowser.imageCount =  self.pictureArray.count;// 这边要变
        _photoBrowser.showArr = self.pictureArray;
    }
    return _photoBrowser;
}
- (NSMutableArray *)pictureArray{
    if (!_pictureArray) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    WARPictureModel *urlStr = self.pictureArray[self.currimageIndex];
    self.toolView.hidden= YES;
    self.miaoshuV.hidden = YES;
    textField.text = urlStr.desc.length==0?@"":urlStr.desc;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    WS(weakself);
    WARPictureModel *urlStr = self.pictureArray[self.currimageIndex];
    NSString *commentid = @"";
    if ([urlStr.type isEqualToString:@"VIDEO"]) {
        commentid = urlStr.videoId;
    }else{
        commentid = urlStr.pictureId;
    }
    [WARProfileNetWorkTool putPhotoDescritionWithAlbumId:urlStr.albumId atPictureId:commentid atDesc:textField.text CallBack:^(id response) {
        [WARProgressHUD showAutoMessage:@"成功"];
        
        weakself.keyBordInputView.hidden = YES;
        [weakself.keyBordInputView endEditing:YES];
        weakself.bordSignView.hidden = NO;
        urlStr.desc = textField.text;
        weakself.miaoslb.text = urlStr.desc;
        CGSize textSize   =   [urlStr.desc boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        
        weakself.miaoshuV.frame = CGRectMake(0, kScreenSize.height-80-textSize.height-20, kScreenWidth, textSize.height+20);
        weakself.miaoslb.frame = CGRectMake(10, 10, kScreenWidth-20, textSize.height);
        
        [weakself.pictureArray replaceObjectAtIndex:weakself.currimageIndex withObject:urlStr];
        weakself.toolView.hidden= NO;
        weakself.miaoshuV.hidden = NO;
        
    } failer:^(id response) {
        
    }];
    
    return YES;
}
- (void)photoBrowser:(SDPhotoBrowser *)browser CurrentIndex:(NSInteger)index{
    if (self.currimageIndex != index) {
        self.toolView.clickLikeBtn.selected = NO;
    }
    self.currimageIndex = index;
    WARPictureModel *urlStr = self.pictureArray[index];
    [self loadCommentData];
    if (urlStr.desc.length) {
        self.miaoslb.text = urlStr.desc;
        CGSize textSize   =   [urlStr.desc boundingRectWithSize:CGSizeMake(kScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        
        
        self.miaoshuV.frame = CGRectMake(0, kScreenSize.height-80-textSize.height-20, kScreenWidth, textSize.height+20);
        self.miaoslb.frame = CGRectMake(10, 10, kScreenWidth-20, textSize.height);
    }else{
        self.miaoslb.text = @"";
        self.miaoshuV.frame = CGRectZero;
        self.miaoslb.frame = CGRectZero;
    }
    
}
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
//  UIImageView *imgeV =  self.currentImgV.subviews[self.currimageIndex];
//    return imgeV.image;
//}
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    WS(weakself);
    // 高清图
    WARPictureModel *model = weakself.pictureArray[index];
    NSString *commentid = @"";
    if ([model.type isEqualToString:@"VIDEO"]) {
        commentid = model.videoId;
    }else{
        commentid = model.pictureId;
    }
    _myMsgInputView.toId = model.pictureId;
    NSURL *url = kCMPRPhotoUrl(commentid);
    if ([model.type isEqualToString:@"VIDEO"]) {
        url = kVideoCoverUrlWithImageSize(CGSizeMake(model.width , model.height),commentid);
    }
    
    return url;
}
- (void)photoBrowserWithKeyBordRegisnFirstResponder:(SDPhotoBrowser *)browser{
    self.toolView.hidden= NO;
    self.miaoshuV.hidden = NO;
    self.bordSignView .hidden = NO;
    self.keyBordInputView.hidden = YES;
    [self.keyBordInputView endEditing:YES];
    [_myMsgInputView prepareToDismiss];
    [self messageInputViewBecomeFirstResponder:NO];
}
#pragma mark - inputviewDelegate

- (void)inputViewWillSendMsg:(UIMessageInputView *)inputView{
    [WARProgressHUD showMessageToWindow:@"正在发送"];
}
- (void)messageInputView:(UIMessageInputView *)inputView sendText:(NSString *)text{
    
}

- (void)inputViewDidSendMsg:(UIMessageInputView *)inputView success:(BOOL)success commentId:(NSString *)commentId commentTime:(NSString *)commentTime{
    [WARProgressHUD hideHUD];
    if (success) {
        [self loadMoreComments];
        _myMsgInputView.placeHolder = WARLocalizedString(@"我也评论一句...");
        //        _myMsgInputView.toId = self.urlID;
        _myMsgInputView.actionType = UIMessageInputActionTypeComment;
        [_myMsgInputView prepareToDismiss];
        [self messageInputViewBecomeFirstResponder:NO];
        
        [WARProgressHUD showSuccessMessage:@"发送成功"];
    }
}

- (void)messageInputView:(UIMessageInputView *)inputView heightToBottomChenged:(CGFloat)heightToBottom{
    
    @weakify(self)
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        @strongify(self)
        
    } completion:nil];
}
- (void)loadMoreComments{
    
    NSInteger thumbCount = [self.commentModel.commentCount integerValue];
    
    
    
    thumbCount++;
    
    self.commentModel.commentCount = [NSString stringWithFormat:@"%ld",thumbCount];
    //    [self.pictureArray replaceObjectAtIndex:self.currimageIndex withObject:urlStr];
    [self.toolView.goComentsBtn setTitle:self.commentModel.commentCount forState:UIControlStateNormal];
}
- (void)messageInputViewHide:(BOOL)isHide{
    if (!_myMsgInputView) {
        return;
    }
    if (isHide) {
        [_myMsgInputView prepareToDismiss];
    }else{
        [_myMsgInputView prepareToShow];
    }
}

- (void)messageInputViewBecomeFirstResponder:(BOOL)isBecomeResponder{
    if (!_myMsgInputView) {
        return;
    }
    if (isBecomeResponder) {
        [_myMsgInputView notAndBecomeFirstResponder];
    }else{
        [_myMsgInputView isAndResignFirstResponder];
        
    }
}
- (UIView *)miaoshuV{
    if (!_miaoshuV) {
        _miaoshuV = [[UIView alloc] init];
        _miaoshuV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    }
    return _miaoshuV;
}
- (UILabel *)miaoslb{
    if (!_miaoslb) {
        _miaoslb = [[UILabel alloc] init];
        _miaoslb.font = [UIFont systemFontOfSize:15];
        _miaoslb.textColor = [UIColor colorWithHexString:@"FFFFFF" opacity:0.8];
        _miaoslb.numberOfLines = 0;
        
    }
    return _miaoslb;
}

@end
