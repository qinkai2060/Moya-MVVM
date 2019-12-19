//
//  YunDianRefundSelectImgView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianRefundSelectImgView.h"
#import "RefundSelectImgCollectionViewCell.h"
#import "UpLoadImageTool.h"
#import "MBProgressHUD+QYExtension.h"
@interface YunDianRefundSelectImgView() <RefundSelectImgCollectionViewCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@end

@implementation YunDianRefundSelectImgView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSDictionary *dic = @{
                              @"img":[UIImage imageNamed:@"icon_selectImg.jpg"],
                              @"flag":@"add",
                              @"url":@""
                              };
        self.arr = [NSMutableArray arrayWithObject:dic];
        [self setUI];
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
    }
    return self;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    
    [self upload:image];
    
    
    
    //    获取图片后返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)upload:(UIImage *)image{
    [SVProgressHUD show];
    @weakify(self);
    [[[UpLoadImageTool shareInstance]uploadImage:image]subscribeNext:^(NSString * x) {
        @strongify(self);
        [SVProgressHUD dismiss];
        if ([x isEqualToString:@"失败"]) {
            [SVProgressHUD showErrorWithStatus:@"图片上传失败"];
        }else {
            NSDictionary *dic = @{
                                  @"img":image,
                                  @"flag":@"added",
                                  @"url":x
                                  };
            if (self.arr.count != 6 && self.arr.count > 1) {
                [self.arr insertObject:dic atIndex:self.arr.count - 1];
            } else if (self.arr.count == 1) {
                [self.arr insertObject:dic atIndex:0];
            } else if (self.arr.count == 6) {
                self.arr[5] = dic;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.collectionView reloadData];
            });
        }
    }];
}
//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    返回
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)buttonAction:(NSInteger)index {
    
    BOOL isPicker = NO;
    
    switch (index) {
        case 10000:
            //            打开相机
            isPicker = true;
            //            判断相机是否可用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                isPicker = true;
            }
            break;
            
        case 10001:
            //            打开相册
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            isPicker = true;
            break;
            
        default:
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            isPicker = true;
            break;
    }
    
    if (isPicker) {
        [[self findCurrentViewController] presentViewController:self.picker animated:YES completion:nil];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"相机不可用" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action];
        
        [[self findCurrentViewController] presentViewController:alert animated:YES completion:nil];
    }
}
- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
    }
    return _picker;
}
- (void)setUI{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 15;
    flowLayout.minimumLineSpacing = 15;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.bounces = NO;
    [self addSubview:self.collectionView];
    [self.collectionView registerClass:[RefundSelectImgCollectionViewCell class] forCellWithReuseIdentifier:@"RefundSelectImgCollectionViewCell"];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - sectionNuw
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
#pragma mark - item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenW - 75) / 4 , (ScreenW - 75) / 4);
}
#pragma mark - cell个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arr.count;
}
#pragma mark - 返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RefundSelectImgCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RefundSelectImgCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *dic = (NSDictionary *) self.arr[indexPath.item];
   
    cell.imgView.image = [dic objectForKey:@"img"];
    if ([[dic objectForKey:@"flag"] isEqualToString:@"added"]) {
        cell.btnClose.hidden = NO;
    } else {
      //add
        cell.btnClose.hidden = YES;
    }
    cell.btnClose.tag = 10000 + indexPath.item;
    cell.delegate = self;
    return cell;
}
- (void)refundSelectImgCollectionViewCellCloseIndex:(NSInteger)Index{
    if (self.arr.count > 1) {
        if (self.arr.count == 6) {
            NSDictionary *dic1 = (NSDictionary *)self.arr[5];
            if ([[dic1 objectForKey:@"flag"] isEqualToString:@"added"]) {
                NSDictionary *dic = @{
                                      @"img":[UIImage imageNamed:@"icon_selectImg.jpg"],
                                      @"flag":@"add",
                                      @"url":@""
                                      };
                [self.arr addObject:dic];
            }
        }
        
        [self.arr removeObjectAtIndex:Index];
    
        [self.collectionView reloadData];
    }
}
#pragma mark - 上左下右
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    //上左下右
    return UIEdgeInsetsMake(15 ,15, 15, 15);
}

#pragma mark - cell点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *dic = self.arr[indexPath.item];
    if ([[dic objectForKey:@"flag"] isEqualToString:@"add"]) {
        [self takePhone:indexPath];
    } else {
        if ([self.delegate respondsToSelector:@selector(yunDianRefundSelectImgViewDelegateAtction:)]) {
            [self.delegate yunDianRefundSelectImgViewDelegateAtction:indexPath.item];
        }
    }
   
}
- (void)takePhone:(NSIndexPath *)indexPatch{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                      message:nil
                                                               preferredStyle:UIAlertControllerStyleActionSheet];
       
      
       
       UIAlertAction *moreAction1 = [UIAlertAction actionWithTitle:@"相册"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              [self buttonAction:10001];
                                                          }];
       [alert addAction:moreAction1];
       UIAlertAction *moreAction2 = [UIAlertAction actionWithTitle:@"相机"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               [self buttonAction:10000];
                                                           }];
                                                       
       [alert addAction:moreAction2];
       
       UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                              style:UIAlertActionStyleCancel
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                [self buttonAction:10001];
                                                            }];
       [alert addAction:cancelAction];
       
       
       //  3.显示alertController
       [[self findCurrentViewController] presentViewController:alert animated:YES completion:nil];
}
- (UIViewController *)findCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}
@end
