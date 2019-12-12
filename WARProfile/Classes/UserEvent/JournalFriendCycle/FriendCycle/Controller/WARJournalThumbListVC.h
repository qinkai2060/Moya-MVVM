//
//  WARThumbListViewController.h
//  WARProfile
//
//  Created by Hao on 2018/6/8.
//

#import "WARBaseViewController.h" 

@interface WARJournalThumbListVC : WARBaseViewController

- (instancetype)initWithMomentId:(NSString *)momentId thumbTotalCount:(NSInteger)thumbTotalCount isPMoment:(BOOL)isPMoment;

@end
