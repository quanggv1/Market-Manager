#import <UIKit/UIKit.h>


@interface CallbackAlertView : NSObject


+ (void)setCallbackTaget:(NSString *)title message:(NSString *)message target:(id)target okTitle:(NSString *)okTitle okCallback:(SEL)okSelector cancelTitle:(NSString *)cancelTitle cancelCallback:(SEL)cancelSelector;

+ (void)setBlock:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okBlock:(void (^)())okBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelBlock;

@end
