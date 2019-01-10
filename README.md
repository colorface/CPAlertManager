# CPAlertManager
Wrapper of UIAlertController with  UIAlertAction using block and delegate

// usage Example 1：

    // step 1 : 引入#import "CPAlertManager.h"
    // step 2 : 遵循 CPAlertManagerDelegate 协议，建议在扩展分类里使用
    // step 3 :
    CPAlertManager *manager = [[CPAlertManager alloc] initWithTitle:@"123"
                                                        message:nil
                                                          style:CPAlertStyleDefault
                                                       delegate:self
                                                    cancelTitle:nil otherTitles:@"nihao",@"mazhe",@"lihao",@"xuzheng", nil];
    // you may add textfield in view
    // you should use self, not weakSelf
    [manager addTextFieldWithConfigurationHandler:nil];
    [manager show];
    
    // setp 4 : 实现可选协议方法
    
// usage Example 2:
    
    [CPAlertManager showWithTitle:@"123" message:nil style:CPAlertStyleSheet delegate:self cancelTitle:nil otherTitle:@"OK" otherHandler:^{
        // code you need handler after click 'OK'
        // you should use self, not weakSelf
        [self actionMethod];
    }];
