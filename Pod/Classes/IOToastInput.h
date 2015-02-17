//
//  IOToastInput.h
//  IOToastInput
//
//  Created by ben on 12/02/2015.
//  Copyright (c) 2015 ben. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `IOToastPresentationType` defines whether a notification will cover the contents of the status/navigation bar or whether the content will be under navigation bar.
 */

typedef NS_ENUM(NSInteger, IOToastPresentationType){
    IOToastPresentationTypeCover,
    IOToastPresentationTypeUnder
};

/**
 The presentation type for the notification. Expects type `IOToastPresentationType`.
 */

extern NSString *const kIOToastNotificationPresentationTypeKey;

/**
 The main text to be shown in the notification. Expects type `NSString`.
 */

extern NSString *const kIOToastTextKey;

/**
 The font to be used for the `kIOToastTextKey` value . Expects type `UIFont`.
 */

extern NSString *const kIOToastFontKey;



@interface IOToastInputManager : NSObject

/**
 Sets the default options that IOToastInput will use when displaying a notification
 @param defaultOptions A dictionary of the options that are to be used as defaults for all subsequent
 showNotificationWithOptions:completionBlock and showNotificationWithMessage:completionBlock: calls
 */

+ (void)setDefaultOptions:(NSDictionary*)defaultOptions;

/**
 Queues a notification to be shown with a given message
 @param options The notification message to be shown. Defaults will be used for all other notification
 properties
 @param completion A completion block to be fired at the completion of the dismisall of the notification
 */

+ (void)showNotificationWithMessage:(NSString*)message completionBlock:(void (^)(NSInteger index,NSString *text))completion;

/**
 Immidiately begins the (un)animated dismisal of a notification
 @param animated If YES the notification will dismiss with its configure animation, otherwise it will immidiately disappear
 */

+ (void)dismissNotification:(BOOL)animated;

@end
