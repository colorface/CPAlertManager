//
//  CPAlertView.h
//  CPAlertView
//
//  Created by AIR on 2019/1/10.
//  Copyright © 2019 Nestor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CPAlertStyle) {
    CPAlertStyleSheet = UIAlertControllerStyleActionSheet,
    CPAlertStyleDefault = UIAlertControllerStyleAlert,
};
@class CPAlertView;
@protocol CPAlertViewDelegate <NSObject>

@optional
- (void)alertView:(CPAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface CPAlertView : NSObject

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;


/**
 instance method, create alertView with title, message, style ...

 @param title :title
 @param message :message
 @param alertStyle :CPAlertStyle
 @param delegate :must be UIViewController
 @param cancelTitle :cancelTitle
 @param otherTitles :otherTitles
 @return instance
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                        style:(CPAlertStyle)alertStyle
                     delegate:(nonnull UIViewController<CPAlertViewDelegate>*)delegate
                  cancelTitle:(nullable NSString *)cancelTitle
                  otherTitles:(nullable NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 class method, create alertView with title, message, style ...
 
 @param title :title
 @param message :message
 @param alertStyle :CPAlertStyle
 @param delegate :must be UIViewController
 @param cancelTitle :cancelTitle
 @param otherTitle :otherTitle
 @param handler other handler block
 */
+ (void)showWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                         style:(CPAlertStyle)alertStyle
                      delegate:(nonnull UIViewController<CPAlertViewDelegate>*)delegate
                   cancelTitle:(nullable NSString *)cancelTitle
                    otherTitle:(nullable NSString *)otherTitle
                  otherHandler:(nullable void (^)(void))handler;
/**
 alertView show
 */
- (void)show;

/**
 add textField

 @param configurationHandler : configuration textField handler
 */
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@end

NS_ASSUME_NONNULL_END
