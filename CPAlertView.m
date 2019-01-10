//
//  CPAlertView.m
//  CPAlertView
//
//  Created by AIR on 2019/1/10.
//  Copyright © 2019 Nestor. All rights reserved.
//

#import "CPAlertView.h"

typedef void(^CPAlertViewHandler)(UIAlertAction *);

@interface CPAlertView ()
@property (nonatomic, weak) UIAlertController *alertController;
@property (nonatomic, weak) UIViewController<CPAlertViewDelegate> *delegate;
@property (nonatomic, assign) CPAlertStyle style;
@property (nonatomic, strong) NSMutableArray *otherButtonTitles;
@end

@implementation CPAlertView

- (instancetype)initWithTitle:(nullable NSString *)title
                      message:(nullable NSString *)message
                        style:(CPAlertStyle)alertStyle
                     delegate:(nonnull UIViewController<CPAlertViewDelegate>*)delegate
                  cancelTitle:(nullable NSString *)cancelTitle
                  otherTitles:(nullable NSString *)otherTitles, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSAssert(delegate, @"delegate is must be not nil");
    
    self = [super init];
    if(!self) return nil;
    
    self.delegate = delegate;
    self.style = alertStyle;
    UIAlertControllerStyle style = (UIAlertControllerStyle)alertStyle;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message preferredStyle:style];
    
    self.alertController = alertController;
    if(cancelTitle) {
        CPAlertViewHandler handler = ^(UIAlertAction *action) {
            [self disappear];
        };
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:handler];
        [alertController addAction:cancelAction];
    }
    
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
            
            CPAlertViewHandler handler = ^(UIAlertAction *action) {
                
                if ([self.delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)]) {
                    [self.delegate alertView:self clickedButtonAtIndex:number];
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
                      delegate:(nonnull UIViewController<CPAlertViewDelegate>*)delegate
                   cancelTitle:(nullable NSString *)cancelTitle
                    otherTitle:(nullable NSString *)otherTitle
                  otherHandler:(nullable void (^)(void))handler {
    
    
    CPAlertView *alertView = [[CPAlertView alloc] initWithTitle:title
                                                        message:message
                                                          style:alertStyle
                                                       delegate:delegate
                                                    cancelTitle:cancelTitle
                                                    otherTitles:nil];
    if (handler) {
        [handler copy];
        UIAlertAction *action = [UIAlertAction actionWithTitle:otherTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           handler();
                                                           [alertView disappear];
                                                       }];
        [alertView.alertController addAction:action];
    }
    
    [alertView show];
    
}

- (void)addTextFieldWithConfigurationHandler:(void (^)(UITextField * _Nonnull))configurationHandler {
    
    if (self.style) {
        [self.alertController addTextFieldWithConfigurationHandler:configurationHandler];
    }
   
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
