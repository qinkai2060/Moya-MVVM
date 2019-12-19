//
//  HFCollectionView.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#define erroImageStr @"SpType_search_noContent"
NS_ASSUME_NONNULL_BEGIN

@interface HFTableViewnView : UITableView<UIScrollViewDelegate>
@property(nonatomic,strong)UIImageView *noContentView;
@property(nonatomic,strong)UILabel *noContentLb;
- (void)setErrorImage:(NSString *)imageStr text:(NSString*)textStr;
- (void)haveData;
@end

NS_ASSUME_NONNULL_END
