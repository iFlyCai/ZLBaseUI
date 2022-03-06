//
//  ZLBaseViewController.m
//  StewardGather
//
//  Created by 朱猛 on 2018/10/9.
//  Copyright © 2018年 朱猛. All rights reserved.
//

#import "ZLBaseViewController.h"
#import "ZLBaseViewController+Notification.h"
#import "ZLKeyboardNotificationPayload.h"

#import "ZLBaseUIConfig.h"

#import "ZLBaseNavigationBar.h"

#import "ZLBaseViewModel.h"

#import <objc/Runtime.h>
#import <objc/message.h>

#import <Masonry/Masonry.h>

@interface ZLBaseViewController ()
    
@property(nonatomic, strong) NSMutableSet * realSubViewModels;

@end

@implementation ZLBaseViewController

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]){
        self.realSubViewModels = [NSMutableSet new];
    }
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)coder{
    if(self = [super initWithCoder:coder]) {
        self.realSubViewModels = [NSMutableSet new];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    // 初始化UI
    [self setBaseUpUI];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];

    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewWillAppear];
    }

    [self _registerNotificationWhenViewWillAppear];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewDidAppear];
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewWillDisappear];
    }
    
    
}

- (void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_viewDidDisappear];
    }
    [self _unregisterNotificationWhenViewDidDisappear];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

    for(ZLBaseViewModel *viewModel in self.realSubViewModels){
        [viewModel VCLifeCycle_didReceiveMemoryWarning];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id <UIViewControllerTransitionCoordinator>)coordinator{
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.zlNavigationBar setNeedsUpdateConstraints];
}


#pragma mark - 初始化UI

- (void) setBaseUpUI{
    
    self.view.backgroundColor = [ZLBaseUIConfig sharedInstance].viewControllerBackgoundColor;
    
    [self setUpCustomNavigationbar];
    
    [self setUpContentView];
}


#pragma mark - 设置Navigation Bar
// 这里不使用系统的UINavigationBar，自定义导航栏
- (void) setUpCustomNavigationbar{
    
    self.zlNavigationBar = [[ZLBaseNavigationBar alloc] init];
    [self.view addSubview:self.zlNavigationBar];
    [self.zlNavigationBar.backButton addTarget:self action:@selector(onBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.zlNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset([ZLBaseUIConfig sharedInstance].navigationBarHeight);
    }];
    
    if(self.navigationController == nil)   // 如果是model弹出
    {
        [self.zlNavigationBar setZlNavigationBarHidden:YES];
    }
    else
    {
        NSArray * controllers = self.navigationController.viewControllers;
        
        if(controllers.firstObject == self)  // 如果是UINavigationController的根VC
        {
            [self.zlNavigationBar.backButton setHidden:YES];
        }
        else
        {
            [self.zlNavigationBar.backButton setHidden:NO];
        }
    }
}

- (void) setTitle:(NSString *)title
{
    [super setTitle:title];
    [self.zlNavigationBar.titleLabel setText:title];
}


- (void) setZLNavigationBarHidden:(BOOL)hidden
{
    [self.zlNavigationBar setZlNavigationBarHidden:hidden];
}

- (void) onBackButtonClicked:(UIButton *) button
{
    if(self.navigationController)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

#pragma mark - 设置contentView
- (void) setUpContentView
{
    self.contentView = [UIView new];
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.zlNavigationBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}


#pragma mark - ZLBaseViewModel

- (ZLBaseViewController *) viewController{
    return self;
}

- (id<ZLBaseViewModel>) superViewModel{
    return nil;
}

- (NSArray *) subViewModels{
    return [_realSubViewModels allObjects];
}



/**
 * 添加子viewModel， 建立父子关系
 * @param subViewModel        子viewModel
 **/
- (void) addSubViewModel:(ZLBaseViewModel *) subViewModel
{
    if(!subViewModel){
        return;
    }
    [subViewModel setValue:self forKey:@"realSuperViewModel"];
    [self.realSubViewModels addObject:subViewModel];
}

- (void) addSubViewModels:(NSArray<ZLBaseViewModel *> *) subViewModels
{
    if(!subViewModels)
    {
        return;
    }
    [subViewModels setValue:self forKey:@"realSuperViewModel"];
    [self.realSubViewModels addObjectsFromArray:subViewModels];
}

- (void) removeSubViewModel:(ZLBaseViewModel *) subViewModel{
    if(!subViewModel){
        return;
    }
    if([self.realSubViewModels containsObject:subViewModel]){
        [subViewModel setValue:nil forKey:@"realSuperViewModel"];
        [self.realSubViewModels removeObject:subViewModel];
    }

}

/**
 * UIViewController 不需要
 */
- (void) removeFromSuperViewModel{
  
}

/**
 * 绑定 viewModel,View,model, 由superViewModel或者VC调用
 * @param targetModel           model
 * @param targetView         view
 **/
- (void) bindModel:(id) targetModel andView:(UIView *) targetView
{
    /**
     * code
     * 绑定 viewModel,View,model
     **/
}

- (void) updateModel:(id)targetModel{
    
}

/**
 * 子ViewModel给父vViewModel上报事件
 * @param event             事件内容
 * @param subViewModel      子viewModel
 **/
- (void) getEvent:(id)event  fromSubViewModel:(ZLBaseViewModel *) subViewModel
{
    /**
     * code
     * 父viewModel 处理event
     **/
}

#pragma mark - Notification

- (void) _registerNotificationWhenViewWillAppear {
    
    // application
    if([self watchApplicationStatusNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
    }
  
    // keyboard
    if([self watchKeyboardStatusNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardDidChangeFrameNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardWillChangeFrameNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_onNotificaitonArrived:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
    }
}

- (void) _unregisterNotificationWhenViewDidDisappear {
    
    // application
    if([self watchKeyboardStatusNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidBecomeActiveNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationDidEnterBackgroundNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillResignActiveNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillEnterForegroundNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIApplicationWillTerminateNotification
                                                      object:nil];
    }
    
    // keyboard
    if([self watchKeyboardStatusNotification]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidChangeFrameNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillChangeFrameNotification
                                                      object:nil];

        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardDidHideNotification
                                                      object:nil];
    }
    
}


- (void) _onNotificaitonArrived:(NSNotification *) notification {
    
    // KeyBoard
    if (notification.name == UIKeyboardDidChangeFrameNotification ||
        notification.name == UIKeyboardWillChangeFrameNotification ||
        notification.name == UIKeyboardWillShowNotification ||
        notification.name == UIKeyboardDidShowNotification ||
        notification.name == UIKeyboardWillHideNotification ||
        notification.name == UIKeyboardDidHideNotification )  {
        CGRect beginFrame;
        CGRect endFrame;
        double duration;
        UIViewAnimationCurve curve;
        
        NSValue *beginFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey];
        NSValue *endFrameValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        NSNumber *durationValue = [[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curveValue = [[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        [beginFrameValue getValue:&beginFrame size:sizeof(CGRect)];
        [endFrameValue getValue:&endFrame size:sizeof(CGRect)];
        duration = [durationValue doubleValue];
        curve = (UIViewAnimationCurve) [curveValue integerValue];
        ZLKeyboardNotificationPayload *payload = [[ZLKeyboardNotificationPayload alloc] init];
    
        payload.beginFrame = beginFrame;
        payload.endFrame = endFrame;
        payload.curve = curve;
        payload.duration = duration;
        
        if (notification.name == UIKeyboardDidChangeFrameNotification) {
            [self keyboardDidChangeFrame:payload];
        } else if (notification.name == UIKeyboardWillChangeFrameNotification) {
            [self keyboardWillChangeFrame:payload];
        } else if (notification.name == UIKeyboardWillShowNotification) {
            [self keyboardWillShow:payload];
        } else if (notification.name == UIKeyboardDidShowNotification) {
            [self keyboardDidShow:payload];
        } else if (notification.name == UIKeyboardWillHideNotification) {
            [self keyboardWillHide:payload];
        } else if (notification.name == UIKeyboardDidHideNotification) {
            [self keyboardDidHide:payload];
        }
    }
    
    // application
    if (notification.name == UIApplicationDidBecomeActiveNotification) {
        [self applicationDidBecomeActive];
    } else if (notification.name == UIApplicationDidEnterBackgroundNotification) {
        [self applicationDidEnterBackground];
    } else if (notification.name == UIApplicationWillResignActiveNotification) {
        [self applicationWillResignActive];
    } else if (notification.name == UIApplicationWillEnterForegroundNotification) {
        [self applicationWillEnterForeground];
    } else if (notification.name == UIApplicationWillTerminateNotification) {
        [self applicationWillTerminate];
    }
    
}




@end

