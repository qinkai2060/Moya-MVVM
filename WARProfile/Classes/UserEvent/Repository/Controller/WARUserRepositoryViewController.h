//
//  WARUserRepositoryViewController.h
//  WARProfile
//
//  Created by HermioneHu on 2018/1/22.
//

#import <UIKit/UIKit.h>
typedef void (^pushblock)();
@interface WARUserRepositoryViewController : UITableViewController
@property (assign, nonatomic) BOOL canScroll;
@property (nonatomic,weak)pushblock block;
@property(nonatomic,assign)BOOL isRefreshing;
@end
