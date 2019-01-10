//
//  CPAlertManager.m
//  CPMain
//
//  Created by AIR on 2019/1/10.
//  Copyright © 2019 com.CP.home. All rights reserved.
//

#import "CPAlertManager.h"

typedef void(^CPAlertManaergHandler)(UIAlertAction *);

@interface CPAlertManager ()

@property (nonatomic, weak) UIAlertController *alertController;
@property (nonatomic, weak) UIViewController<CPAlertManagerDelegate> *delegate;
// 
@property (nonatomic, assign) CPAlertStyle style;
// other button titles
@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@end

@implementation CPAlertManager

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                        style:(CPAlertStyle)alertStyle
                     delegate:(nonnull UIViewController<CPAlertManagerDelegate>*)delegate
                  cancelTitle:(nullable NSString *)cancelTitle
                  otherTitles:(nullable NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSAssert(delegate, @"delegate is must be not nil");
    
    self = [super init];
    if(!self) return nil;
    
    self.delegate = delegate;
    self.style = alertStyle;
    
    //create alert controller
    UIAlertControllerStyle style = (UIAlertControllerStyle)alertStyle;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:style];
    
    self.alertController = alertController;
    
    // add title & action to the button
    if(cancelTitle) {
        CPAlertManaergHandler handler = ^(UIAlertAction *action) {
            [self disappear];
        };
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:handler];
        [alertController addAction:cancelAction];
    }
    
    // add titles and actions to the buttons
    // add titles to the otherButtonTitles
    if(otherTitles) {
        
        NSString * eachObject;
        va_list argumentList;
        [self.otherButtonTitles addObject:otherTitles];
        va_start(argumentList, otherTitles);
        while ((eachObject = va_arg(argumentList, NSString *)))
            [self.otherButtonTitles addObject:eachObject];
        va_end(argumentList);
        
        [self setupOtherButtonActions];
    }
    
    return self;
}

- (void)setupOtherButtonActions {
    
    NSUInteger count = self.otherButtonTitles.count;
    
    if (count) {
        for (NSInteger number = 0; number < count ; number++) {
            
            CPAlertManaergHandler handler = ^(UIAlertAction *action) {
                
                if ([self.delegate respondsToSelector:@selector(alertManager:clickedButtonAtIndex:)]) {
                    [self.delegate alertManager:self clickedButtonAtIndex:number];
                }
                if ([self.delegate respondsToSelector:@selector(textFields:clickedButtonAtIndex:)]) {
                    [self.delegate textFields:self.alertController.textFields clickedButtonAtIndex:number];
                }
                [self disappear];
            };
            UIAlertAction *action = [UIAlertAction actionWithTitle:self.otherButtonTitles[number]
                                                             style:UIAlertActionStyleDefault
                                                           handler:handler];
            [self.alertController addAction:action];
        }
    }
}

+ (void)showWithTitle:(nullable NSString *)title
              message:(nullable NSString *)message
                style:(CPAlertStyle)alertStyle
             delegate:(nonnull UIViewController<CPAlertManagerDelegate>*)delegate
          cancelTitle:(nullable NSString *)cancelTitle
           otherTitle:(nullable NSString *)otherTitle
         otherHandler:(nullable void (^)(void))handler {
    
    
    CPAlertManager *manager = [[CPAlertManager alloc] initWithTitle:title
                                                        message:message
                                                          style:alertStyle
                                                       delegate:delegate
                                                    cancelTitle:cancelTitle
                                                    otherTitles:nil];
    if(handler) {
        [handler copy];
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           handler();
                                                           [manager disappear];
                                                       }];
        [manager.alertController addAction:action];
    }
    
    [manager show];
    
}

- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(UITextField *))configurationHandler {
    
    if(self.style) {[self.alertController addTextFieldWithConfigurationHandler:configurationHandler];}
}

- (void)show {
    
    if (self.delegate && [self.delegate isKindOfClass:[UIViewController class]]) {
        UIViewController *vc = (UIViewController *)self.delegate;
        [vc presentViewController:self.alertController animated:YES completion:nil];
    }
}

- (void)disappear {
    
    [self.otherButtonTitles removeAllObjects];
    self.otherButtonTitles = nil;
    [self.alertController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - lazy initilaze

- (NSMutableArray *)otherButtonTitles {
    if (!_otherButtonTitles) {
        _otherButtonTitles = [NSMutableArray array];
    }
    return _otherButtonTitles;
}

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
}

@end
