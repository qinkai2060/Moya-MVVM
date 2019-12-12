//
//  WARPhotoMoveCell.h
//  WARProfile
//
//  Created by 秦恺 on 2018/3/23.
//

#import <UIKit/UIKit.h>
#import "WARGroupModel.h"
typedef void (^MoveIDBlock)(NSString*moveID);
@interface WARPhotoMoveCell : UITableViewCell
@property(nonatomic,strong)UIButton *selectImgBtn;
@property(nonatomic,strong)UIImageView *fenmianImgV;
@property(nonatomic,strong)UILabel *titlelb;
@property(nonatomic,strong)WARGroupModel *model;
@property(nonatomic,strong)NSMutableArray *selectArr;
@property(nonatomic,copy)MoveIDBlock block;
- (void)SelectClick:(UIButton*)btn;
@end
