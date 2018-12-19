//
//  WJNaviController.m
//  UserSide
//
//  Created by weijhon on 16/9/10.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "WJNaviController.h"
@implementation WJNaviController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationBar.barTintColor = [UIColor colorWithHexString:@"#5D69FD"];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0 ) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.navigationBar.hidden = NO;
    }else {
//        self.navigationBar.hidden = YES;
        viewController.automaticallyAdjustsScrollViewInsets = false;
    }

    return [super pushViewController:viewController animated:animated];
}

- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count == 2) {
//        self.navigationBar.hidden = YES;
    }
    return [super popViewControllerAnimated:animated];
}


@end
