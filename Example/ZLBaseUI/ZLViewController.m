//
//  ZLViewController.m
//  ZLBaseUI
//
//  Created by ExistOrLive on 09/13/2021.
//  Copyright (c) 2021 ExistOrLive. All rights reserved.
//

#import "ZLViewController.h"

@interface ZLPageModel : NSObject
// 展示的控制器名字
@property (nonatomic, copy) NSString *displayName;
// 要跳转的控制器的名称
@property (nonatomic, copy) NSString *destinationControllerName;
- (instancetype)initWithDisplayName:(NSString *)displayName destinationControllerName:(NSString *)destinationControllerName;
@end

@implementation ZLPageModel
- (instancetype)initWithDisplayName:(NSString *)displayName destinationControllerName:(NSString *)destinationControllerName {
    self = [super init];
    if (self) {
        self.displayName = displayName;
        self.destinationControllerName = destinationControllerName;
    }
    return self;
}
@end

@interface ZLViewController () <UITableViewDataSource, UITableViewDelegate>

@end


@interface ZLViewController ()

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<ZLPageModel *> *pageModels;

@end

@implementation ZLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"测试页面";
    // 初始化页面模型数组
    self.pageModels = @[
        [[ZLPageModel alloc] initWithDisplayName:@"First Page" destinationControllerName:@"ZLFirstViewController"],
        [[ZLPageModel alloc] initWithDisplayName:@"Second Page" destinationControllerName:@"ZLSecondViewController"]
    ];
    
    // 创建 tableView
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.pageModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    ZLPageModel *pageModel = self.pageModels[indexPath.row];
    cell.textLabel.text = pageModel.displayName;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ZLPageModel *pageModel = self.pageModels[indexPath.row];
    NSString *controllerName = pageModel.destinationControllerName;
    // 根据类名创建对应的类
    Class destinationClass = NSClassFromString(controllerName);
    if (destinationClass && [destinationClass isSubclassOfClass:[UIViewController class]]) {
        UIViewController *destinationVC = [[destinationClass alloc] init];
        [self.navigationController pushViewController:destinationVC animated:YES];
    }
}

@end
