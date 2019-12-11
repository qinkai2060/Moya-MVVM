//
//  WARPlayViewController.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/8.
//

#import "WARPlayViewController.h"
#import "WARPlayerFlashView.h"
#import "Masonry.h"

@interface WARPlayViewController ()
/** videoUrl */
@property (nonatomic, strong) NSURL *videoUrl;

/** flashView */
@property (nonatomic, strong) WARPlayerFlashView *flashView;
@end

@implementation WARPlayViewController
 
- (instancetype)initWithVideoUrl:(NSURL *)videoUrl {
    if (self = [super init]) {
        self.videoUrl = videoUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    WARPlayerFlashView *flashView = [WARPlayerFlashView playerWithVideoURL:self.videoUrl];
    self.flashView = flashView;
    [self.view addSubview:flashView];
    
    [self.flashView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.bottom.mas_equalTo(0);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.flashView stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
