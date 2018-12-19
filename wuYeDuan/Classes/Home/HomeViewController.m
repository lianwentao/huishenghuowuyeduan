//
//  HomeViewController.m
//  wuYeDuan
//
//  Created by admin on 2018/12/19.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "HomeViewController.h"
#import "shifuliebiaoViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate>{
    UITableView *_TableView;
    NSArray *dataArr;
}

@end

@implementation HomeViewController
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
//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#5D69FD"];
     self.view.backgroundColor = [UIColor whiteColor];
    [self getdata];
}
- (void)getdata
{
    dataArr = [NSArray array];
    
    //初始化进度框，置于当前的View当中
    static MBProgressHUD *_HUD;
    _HUD =[MBProgressHUD showHUDAddedTo:self.view animated:YES]; //HUD效果添加哪个视图上
    _HUD.delegate = self;
    _HUD.mode =MBProgressHUDModeIndeterminate;   //加载效果的显示样式
    [self.view addSubview:_HUD];
    
    //如果设置此属性则当前的view置于后台
    //_HUD.dimBackground = YES;
    
    //设置对话框文字
    _HUD.label.text = @"加载中...";
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
        NSUserDefaults *userinfo = [NSUserDefaults standardUserDefaults];
        WBLog(@"%@-------%@",[userinfo objectForKey:@"token"],[userinfo objectForKey:@"tokenSecret"]);
        NSDictionary *dict = @{@"token":[userinfo objectForKey:@"token"],@"tokenSecret":[userinfo objectForKey:@"tokenSecret"]};
        NSString *strurl = [API stringByAppendingString:@"/Api/AppMenu/menu"];
        [manager POST:strurl parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            WBLog(@"---%@--%@",responseObject,[responseObject objectForKey:@"msg"]);
            if ([[responseObject objectForKey:@"status"] integerValue]==1) {
                
                self->dataArr = [responseObject objectForKey:@"data"];
                [self createtableview];
            }else{
                [MBProgressHUD showToastToView:self.view withText:[responseObject objectForKey:@"msg"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WBLog(@"failure--%@",error);
            [MBProgressHUD showToastToView:self.view withText:@"加载失败"];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_HUD hideAnimated:YES];
        });
    });
}
- (void)createtableview
{
    _TableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Main_width, Main_Height)];
    _TableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _TableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _TableView.delegate = self;
    _TableView.dataSource = self;
    //_TableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(post1)];
    [self.view addSubview:_TableView];
}
#pragma mark - TableView的代理方法
//cell 的数量
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return (dataArr.count+3)/4+1;
    }
}

// 分组的数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//headview的高度和内容
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"   ";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @"  ";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIndetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndetifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;    //点击的时候无效果
    }
    if (indexPath.section==0) {
        tableView.rowHeight = Main_width/2.14;
        cell.contentView.backgroundColor = QIColor;
    }else{
        if (indexPath.row==0) {
            tableView.rowHeight = 50;
        }else{
            CGFloat width = (Main_width-40-45*3)/4;
            if ((dataArr.count-(indexPath.row-1)*4)/4>=1) {
                for (int i=0; i<4; i++) {
                    UILabel *backlabel = [[UILabel alloc] initWithFrame:CGRectMake(20+i*width+45*i, 10, width, 40)];
                    backlabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
                    backlabel.text = [[dataArr objectAtIndex:i+(indexPath.row-1)*4] objectForKey:@"title"];
                    backlabel.font = Font(14);
                    backlabel.textAlignment = NSTextAlignmentCenter;
                    [cell.contentView addSubview:backlabel];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(15+i*width+45*i, 10, width, 40);
                    but.tag = [[[dataArr objectAtIndex:i+(indexPath.row-1)*4] objectForKey:@"id"] integerValue];
                    [but setTitle:[[dataArr objectAtIndex:i+(indexPath.row-1)*4] objectForKey:@"title"] forState:UIControlStateNormal];
                    but.titleLabel.font = Font(0.1);
                    [but addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:but];
                }
            }else{
                for (int i=0; i<(dataArr.count-(indexPath.row-1)*4); i++) {
//                    UILabel *backlabel = [[UILabel alloc] initWithFrame:CGRectMake(20+i*width+45*i, 10, width, 40)];
//                    backlabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
//                    backlabel.text = [[dataArr objectAtIndex:i+indexPath.row*4] objectForKey:@"title"];
//                    backlabel.font = Font(14);
//                    backlabel.textAlignment = NSTextAlignmentCenter;
//                    [cell.contentView addSubview:backlabel];
                    
                    UILabel *backlabel = [[UILabel alloc] initWithFrame:CGRectMake(20+i*width+45*i, 10, width, 40)];
                    backlabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1];
                    backlabel.text = [[dataArr objectAtIndex:i+(indexPath.row-1)*4] objectForKey:@"title"];
                    backlabel.font = Font(14);
                    backlabel.textAlignment = NSTextAlignmentCenter;
                    [cell.contentView addSubview:backlabel];
                    
                    UIButton *but = [UIButton buttonWithType:UIButtonTypeCustom];
                    but.frame = CGRectMake(20+i*width+45*i, 10, width, 40);
                    but.tag = [[[dataArr objectAtIndex:i+(indexPath.row-1)*4] objectForKey:@"id"] integerValue];
                    [but setTitle:[[dataArr objectAtIndex:i+(indexPath.row-1)*4] objectForKey:@"title"] forState:UIControlStateNormal];
                    but.titleLabel.font = Font(0.1);
                    [but addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:but];
                }
            }
        }
    }
    return cell;
}
- (void)push
{
    [self.navigationController pushViewController:[shifuliebiaoViewController new] animated:YES];
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
