//
//  LoginViewController.m
//  wuYeDuan
//
//  Created by 晋中华晟 on 2018/12/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
@interface LoginViewController ()<MBProgressHUDDelegate,UINavigationControllerDelegate>

@end

@implementation LoginViewController
#pragma mark - 隐藏导航栏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createUi];
    // Do any additional setup after loading the view.
}
- (void)createUi
{
    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.backgroundColor = QIColor;
    but.frame = CGRectMake(100, 200, 100, 50);
    [but addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
}
- (void)login
{
    //初始化进度框，置于当前的View当中
    static MBProgressHUD *_HUD;
    _HUD =[MBProgressHUD showHUDAddedTo:self.view animated:YES]; //HUD效果添加哪个视图上
    _HUD.delegate = self;
    _HUD.mode =MBProgressHUDModeIndeterminate;   //加载效果的显示样式
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.label.text = @"登录中...";
    _HUD.label.font = [UIFont systemFontOfSize:14];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        float progress = 0.0f;
        while (progress < 1.0f) {
            progress += 0.01f;
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD HUDForView:self.view].progress = progress;
                
            });
            
        }
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        //2.封装参数
        NSDictionary *dict = @{@"username":@"liuxiaohong",@"password":@"123456"};
        NSString *strurl = [API stringByAppendingString:@"/Api/Login/login"];
        [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
                // 存储数据
                [userinfo setObject:[[responseObject objectForKey:@"data"] objectForKey:@"username"] forKey:@"username"];
                [userinfo setObject:[[responseObject objectForKey:@"data"] objectForKey:@"token"] forKey:@"token"];
                [userinfo setObject:[[responseObject objectForKey:@"data"] objectForKey:@"tokenSecret"] forKey:@"tokenSecret"];
                [userinfo setObject:[[responseObject objectForKey:@"data"] objectForKey:@"pwdmd5"] forKey:@"pwdmd5"];
                [userinfo setObject:[[responseObject objectForKey:@"data"] objectForKey:@"id"] forKey:@"id"];
                // 立刻同步
                [userinfo synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil userInfo:nil];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"登录失败"];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD hideAnimated:YES];
        });
    });
}
#pragma mark -MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [hud removeFromSuperview];
    hud = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
