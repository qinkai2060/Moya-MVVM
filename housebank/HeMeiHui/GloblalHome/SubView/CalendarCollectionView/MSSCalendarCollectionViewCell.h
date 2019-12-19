//
//  MSSCalendarCollectionViewCell.h
//  MSSCalendar
//
//  Created by zhuchaoji on 2019/4/17.
//  Copyright © 2019年 合发全球. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSSCircleLabel.h"

@interface MSSCalendarCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)MSSCircleLabel *tagLabel;
@property (nonatomic,strong)MSSCircleLabel *dateLabel;
@property (nonatomic,strong)UILabel *subLabel;
@property (nonatomic,assign)BOOL isSelected;

@end
