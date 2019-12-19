//
//  HFTableViewCarBaseCell.h
//  housebank
//
//  Created by usermac on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFTableViewCell.h"
#import "HFCarBaseModel.h"
#import "HFShopingModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HFTableViewCarBaseCell;
@protocol HFTableViewCarBaseCellDelegate <NSObject>

- (void)cellBaseTextfiledBegainEditing:(HFTableViewCarBaseCell*)cell textfiled:(UITextField*)textField;
- (void)cellWithdidSelectWithSpecifications:(HFTableViewCarBaseCell*)cell;
- (void)cellWithResetSpecials:(HFTableViewCarBaseCell*)cell;
@end
@interface HFTableViewCarBaseCell : HFTableViewCell
@property (nonatomic, strong) HFStoreModel           *dataModel;
@property (nonatomic, weak) id <HFTableViewCarBaseCellDelegate>           delegate;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, copy) void (^didMinPhotoBlock)(HFTableViewCarBaseCell *);
@property (nonatomic, copy) void (^didPulsPhotoBlock)(HFTableViewCarBaseCell *);
+ (void)registerRenderCell:(Class)cellClass messageType:(int)mtype;
- (void)doMessageRendering;
+ (Class)getRenderClassByMessageType:(NSInteger)msgType;
@end

NS_ASSUME_NONNULL_END
