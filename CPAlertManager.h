//
//  CPAlertManager.h
//  CPMain
//
//  Created by AIR on 2019/1/10.
//  Copyright © 2019 com.CP.home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIAlertController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CPAlertStyle) {
    CPAlertStyleSheet = UIAlertControllerStyleActionSheet,
    CPAlertStyleDefault = UIAlertControllerStyleAlert,
}NS_CLASS_AVAILABLE_IOS(8_0);

@class CPAlertManager;
@protocol CPAlertManagerDelegate <NSObject>

@optional

// maybe called when otherTitles count > 1
- (void)alertManager:(CPAlertManager *)manager clickedButtonAtIndex:(NSInteger)buttonIndex;
// called when added textFeild in alertController
- (void)textFields:(NSArray<UITextField *>*)textFields clickedButtonAtIndex:(NSInteger)buttonIndex;
@end


NS_CLASS_AVAILABLE_IOS(8_0) @interface CPAlertManager : NSObject

// unavailable
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;


/**
 Description : instance Method, create manager with title, message, style ...

 @param title       : alert title
 @param message     : alert message
 @param alertStyle  : style
 @param delegate    : must be subClass of UIViewController
 @param cancelTitle : cancel button title
 @param otherTitles : a lot of button titles ...
 @return            : manager instance
 */
- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                        style:(CPAlertStyle)alertStyle
                     delegate:(nonnull UIViewController<CPAlertManagerDelegate>*)delegate
                  cancelTitle:(nullable NSString *)cancelTitle
                  otherTitles:(nullable NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION;


/**
 Description : class Method, create manager with title, message, style ...
 
 @param title       : alert title
 @param message     : alert message
 @param alertStyle  : style
 @param delegate    : must be subClass of UIViewController
 @param cancelTitle : cancel button title
 @param otherTitle  : other button title
 @param handler     : called when click otherTitle button
 */
+ (void)showWithTitle:(nullable NSString *)title
              message:(nullable NSString *)message
                style:(CPAlertStyle)alertStyle
             delegate:(nonnull UIViewController<CPAlertManagerDelegate>*)delegate
          cancelTitle:(nullable NSString *)cancelTitle
           otherTitle:(nullable NSString *)otherTitle
         otherHandler:(nullable void (^)(void))handler;


/** alert popup  */
- (void)show;


/**
 Description : add textField to default style only.
        note : Available in the default style, if use sheet style does not work

 @param configurationHandler : custom textField style
 */
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *textField))configurationHandler;

@end

NS_ASSUME_NONNULL_END
