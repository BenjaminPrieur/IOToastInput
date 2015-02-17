//
//  IOToastInput.m
//  IOToastInput
//
//  Created by ben on 12/02/2015.
//  Copyright (c) 2015 ben. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "IOToastInput.h"

typedef NS_ENUM(NSInteger, IOToastState) {
    IOToastStateWaiting,
    IOToastStateEntering,
    IOToastStateDisplaying,
    IOToastStateExiting,
    IOToastStateCompleted
};

#pragma mark - Layout Helper Functions

static CGFloat const IOStatusBarDefaultHeight = 44.0f;

static CGSize IONotificationViewSize() {
    return CGSizeMake([UIScreen mainScreen].bounds.size.width,
                      [[UIApplication sharedApplication] statusBarFrame].size.height + IOStatusBarDefaultHeight + 74);
}

#pragma mark - Option Constant Definitions

NSString *const kIOToastNotificationPresentationTypeKey     = @"kIOToastNotificationPresentationTypeKey";

NSString *const kIOToastTextKey                             = @"kIOToastTextKey";
NSString *const kIOToastFontKey                             = @"kIOToastFontKey";

#pragma mark - Option Defaults

static IOToastPresentationType      kIONotificationPresentationTypeDefault  = IOToastPresentationTypeCover;

static NSString *                   kIOTextDefault                          = @"";
static UIFont   *                   kIOFontDefault                          = nil;

static NSDictionary *               kIOToastKeyClassMap                     = nil;

#pragma mark - IOToastInput

@interface IOToastInputView : UIView
@end

@interface IOToastInput : NSObject

@property (strong, nonatomic) NSUUID *uuid;
@property (assign, nonatomic) IOToastState state;


@property (nonatomic, strong) NSDictionary *options;
@property (copy, nonatomic) void(^completion)(NSInteger index, NSString *text);

@property (nonatomic, readonly) IOToastInputView *notificationView;
@property (nonatomic, retain) UIDynamicAnimator *animator;

@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;


@property (nonatomic, readonly) IOToastPresentationType presentationType;

- (void)initiateAnimator:(UIView*)view;
@end

@interface IOToastInputView ()
@property (strong, nonatomic) IOToastInput *toast;
@end

@implementation IOToastInput

+ (void)initialize
{
    if (self == [IOToastInput class])
    {
        kIOToastKeyClassMap = @{
                                kIOToastNotificationPresentationTypeKey : NSStringFromClass([@(kIONotificationPresentationTypeDefault) class])
                                };
    }
}

+ (instancetype)notificationWithOptions:(NSDictionary *)options
                        completionBlock:(void(^)(NSInteger index, NSString *text))completion
{
    IOToastInput *notification = [[self alloc] init];
    notification.textColor = [UIColor whiteColor];
    notification.options = options;
    notification.completion = completion;
    notification.state = IOToastStateWaiting;
    notification.uuid = [NSUUID UUID];
    
    return notification;
}

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions
{
    //TODO Validate Types of Default Options

    if (defaultOptions[kIOToastNotificationPresentationTypeKey])    kIONotificationPresentationTypeDefault  = [defaultOptions[kIOToastNotificationPresentationTypeKey] integerValue];
    
    if (defaultOptions[kIOToastTextKey])                            kIOTextDefault                          = defaultOptions[kIOToastTextKey];
    if (defaultOptions[kIOToastFontKey])                            kIOFontDefault                          = defaultOptions[kIOToastFontKey];
    
}

#pragma mark - Notification View Helpers

- (IOToastInputView*)notificationView {
    CGSize size = IONotificationViewSize();
    IOToastInputView *notificationView = [[IOToastInputView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    notificationView.toast = self;
    return notificationView;
}

- (void)initiateAnimator:(UIView*)view {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:view];
}

#pragma mark - Overrides

- (IOToastPresentationType)presentationType {
    IOToastPresentationType presentationType = _options[kIOToastNotificationPresentationTypeKey]?[self.options[kIOToastNotificationPresentationTypeKey] integerValue]:kIONotificationPresentationTypeDefault;
    return presentationType;
}

- (NSString*)text {
    return _options[kIOToastTextKey] ?: kIOTextDefault;
}

- (UIFont*)font {
    return _options[kIOToastFontKey] ?: kIOFontDefault;
}

@end

#pragma mark - IOToastInputView

@interface IOToastInputView ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIView *viewBgTF;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnValidate;
@end

@implementation IOToastInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.userInteractionEnabled = NO;
        [self addSubview:label];
        self.label = label;
        
        UIView *viewBgTF = [[UIView alloc] initWithFrame:CGRectZero];
        viewBgTF.userInteractionEnabled = NO;
        [self addSubview:viewBgTF];
        self.viewBgTF = viewBgTF;
        
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectZero];
        [textfield setBorderStyle:UITextBorderStyleNone];
        [self addSubview:textfield];
        self.textField = textfield;
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btnCancel];
        self.btnCancel = btnCancel;
        
        UIButton *btnValidate = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:btnValidate];
        self.btnValidate = btnValidate;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentFrame = self.bounds;
    
    self.label.frame = CGRectMake(10, 10, contentFrame.size.width - 20, 20);
    
    self.viewBgTF.frame = CGRectMake(10, CGRectGetMaxY(self.label.frame)+12, contentFrame.size.width - 20, 40);
    self.viewBgTF.layer.cornerRadius = 3.f;
    
    self.textField.frame = CGRectMake(16, self.viewBgTF.frame.origin.y+2, contentFrame.size.width - 32, 36);
    
    self.btnCancel.frame = CGRectMake(0, CGRectGetMaxY(self.textField.frame)+8, contentFrame.size.width/2, contentFrame.size.height - CGRectGetMaxY(self.textField.frame)-8);
    
    self.btnValidate.frame = CGRectMake(contentFrame.size.width/2, self.btnCancel.frame.origin.y, contentFrame.size.width/2, self.btnCancel.frame.size.height);
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                  byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                                        cornerRadii:CGSizeMake(10.0, 10.0)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    self.layer.mask = shape;
}

#pragma mark - IBAction

- (void)action_cancel
{
    self.toast.completion(0, nil);
    [IOToastInputManager dismissNotification:YES];
}

- (void)action_validate
{
    self.toast.completion(1, self.textField.text);
}

#pragma mark - Overrides

- (void)setToast:(IOToastInput *)toast {
    _toast = toast;
    self.label.text = toast.text;
    self.label.font = toast.font;
    self.label.textColor = toast.textColor;
    self.label.textAlignment = NSTextAlignmentCenter; //toast.textAlignment;
//    self.label.numberOfLines = toast.textMaxNumberOfLines;
    
    self.viewBgTF.backgroundColor = [UIColor whiteColor];
    
    self.textField.placeholder = toast.text;
    
    [self.btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.btnCancel addTarget:self action:@selector(action_cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [self.btnValidate setTitle:@"Validate" forState:UIControlStateNormal];
    [self.btnValidate addTarget:self action:@selector(action_validate) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundColor =  [UIColor colorWithWhite:0 alpha:0.8]; /*toast.backgroundColor;*/
}

@end

#pragma mark - IOToastInputViewController

@interface IOToastInputViewController : UIViewController
- (void)statusBarStyle:(UIStatusBarStyle)newStatusBarStyle;
@end

@implementation IOToastInputViewController

UIStatusBarStyle statusBarStyle;

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return statusBarStyle;
}

- (void)statusBarStyle:(UIStatusBarStyle)newStatusBarStyle {
    statusBarStyle = newStatusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

@end

#pragma mark - IOToastInputManager

@interface IOToastInputManager () <UICollisionBehaviorDelegate>

@property (nonatomic) BOOL showingNotification;
@property (strong, nonatomic) UIWindow *notificationWindow;
@property (strong, nonatomic) IOToastInputView *notificationView;
@property (strong, nonatomic) IOToastInput *notification;
@property (nonatomic, copy) void (^gravityAnimationCompletionBlock)(BOOL finished);
@end

typedef void (^IOToastAnimationCompletionBlock)(BOOL animated);

static NSString *const kIOToastManagerCollisionBoundryIdentifier = @"kIOToastManagerCollisionBoundryIdentifier";

@implementation IOToastInputManager

+ (instancetype)manager {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        UIWindow *notificationWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        notificationWindow.backgroundColor = [UIColor clearColor];
        notificationWindow.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        notificationWindow.windowLevel = UIWindowLevelStatusBar;
        notificationWindow.rootViewController = [IOToastInputViewController new];
        notificationWindow.rootViewController.view.clipsToBounds = YES;
        self.notificationWindow = notificationWindow;
        
    }
    return self;
}

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions {
    [IOToastInput setDefaultOptions:defaultOptions];
}

+ (void)showNotificationWithMessage:(NSString *)message completionBlock:(void (^)(NSInteger index, NSString *text))completion
{
    [[self manager] addNotification:[IOToastInput notificationWithOptions:@{kIOToastTextKey:message} completionBlock:completion]];
}

- (void)addNotification:(IOToastInput *)notification
{
    if (!self.showingNotification)
    {
        [self displayNotification:notification];
    }
}

+ (void)dismissNotification:(BOOL)animated
{
    [[self manager] dismissNotification:animated];
}

- (void)dismissNotification:(BOOL)animated
{
    if (!self.notification) return;
    
    if (animated && (self.notification.state == IOToastStateEntering || self.notification.state == IOToastStateDisplaying)) {
        self.notification.state = IOToastStateExiting;
        [self.notification.animator removeAllBehaviors];
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc]initWithItems:@[self.notificationView]];
        gravity.gravityDirection = CGVectorMake(0, -1);
        gravity.magnitude = 1.;
        NSMutableArray *collisionItems = [@[self.notificationView] mutableCopy];
        UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
        collision.collisionDelegate = self;
        [collision addBoundaryWithIdentifier:kIOToastManagerCollisionBoundryIdentifier
                                   fromPoint:CGPointMake(0, -self.notificationView.frame.size.height)
                                     toPoint:CGPointMake(self.notificationView.frame.size.width, -self.notificationView.frame.size.height)];
        UIDynamicItemBehavior *rotationLock = [[UIDynamicItemBehavior alloc] initWithItems:collisionItems];
        rotationLock.allowsRotation = NO;
        [self.notification.animator addBehavior:gravity];
        [self.notification.animator addBehavior:collision];
        [self.notification.animator addBehavior:rotationLock];
    } else {
        
    }
}

- (void)displayNotification:(IOToastInput*)notification
{
    _notificationWindow.hidden = NO;
    self.showingNotification = YES;
    CGSize notificationSize = IONotificationViewSize();
    
    BOOL coverNavBar = notification.presentationType == IOToastPresentationTypeCover;
    BOOL navBar = NO;
    if (!coverNavBar)
    {
        if ([[[UIApplication sharedApplication] keyWindow].rootViewController isKindOfClass:[UINavigationController class]])
        {
            navBar = !((UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController).navigationBarHidden;
        }
    }
    
    CGRect containerFrame = CGRectMake(0, coverNavBar?0:[[UIApplication sharedApplication] statusBarFrame].size.height + (navBar?IOStatusBarDefaultHeight:0),
                                       notificationSize.width, notificationSize.height);
    
    IOToastInputViewController *controller = (IOToastInputViewController *)self.notificationWindow.rootViewController;
    [controller statusBarStyle:UIStatusBarStyleLightContent];
    
    self.notificationWindow.frame = containerFrame;
    self.notificationWindow.rootViewController.view.frame = CGRectMake(0, 0, containerFrame.size.width, containerFrame.size.height);
    
    IOToastInputView *notificationView = notification.notificationView;
    notificationView.frame = CGRectMake(0, -containerFrame.size.height, containerFrame.size.width, containerFrame.size.height);
    [self.notificationWindow.rootViewController.view addSubview:notificationView];
    self.notificationView = notificationView;
    
//    for (UIView *subview in self.notificationWindow.rootViewController.view.subviews) {
//        subview.userInteractionEnabled = NO;
//    }
    
    self.notificationWindow.rootViewController.view.userInteractionEnabled = YES;
    
    notification.state = IOToastStateEntering;
    [notification initiateAnimator:self.notificationWindow.rootViewController.view];
    [notification.animator removeAllBehaviors];
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[notificationView]];
    gravity.gravityDirection = CGVectorMake(0, 1);
    gravity.magnitude = 1.f;
    NSMutableArray *collisionItems = [@[notificationView] mutableCopy];
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:collisionItems];
    collision.collisionDelegate = self;
    [collision addBoundaryWithIdentifier:kIOToastManagerCollisionBoundryIdentifier
                               fromPoint:CGPointMake(0, containerFrame.size.height)
                                 toPoint:CGPointMake(containerFrame.size.width, containerFrame.size.height)];
    UIDynamicItemBehavior *rotationLock = [[UIDynamicItemBehavior alloc] initWithItems:collisionItems];
    rotationLock.allowsRotation = NO;
    [notification.animator addBehavior:gravity];
    [notification.animator addBehavior:collision];
    [notification.animator addBehavior:rotationLock];
    self.notification = notification;
}

#pragma mark - UICollisionBehaviorDelegate

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item
   withBoundaryIdentifier:(id <NSCopying>)identifier {
    
    if (self.notification.state == IOToastStateEntering)
    {
        self.notification.state = IOToastStateDisplaying;
        [self.notificationView.textField becomeFirstResponder];
    }
    else if (self.notification.state == IOToastStateExiting)
    {
        NSLog(@"exit");
        self.notificationWindow.rootViewController.view.gestureRecognizers = nil;
        self.notification.state = IOToastStateCompleted;
        [self.notificationView removeFromSuperview];
        self.notificationWindow.hidden = YES;
        self.showingNotification = NO;
    }
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      endedContactForItem:(id <UIDynamicItem>)item1
                 withItem:(id <UIDynamicItem>)item2 {
    if (self.gravityAnimationCompletionBlock) {
        self.gravityAnimationCompletionBlock(YES);
        self.gravityAnimationCompletionBlock = NULL;
    }
}

@end

