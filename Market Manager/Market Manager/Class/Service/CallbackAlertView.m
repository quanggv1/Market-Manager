
#import "CallbackAlertView.h"

@implementation CallbackAlertView

+ (void)setCallbackTaget:(NSString *)title message:(NSString *)message target:(id)target okTitle:(NSString *)okTitle okCallback:(SEL)okSelector cancelTitle:(NSString *)cancelTitle cancelCallback:(SEL)cancelSelector
{
    if(target == nil) return;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelSelector) {
                [target performSelectorOnMainThread:cancelSelector withObject:nil waitUntilDone:NO];
            }
        }]];
    }
    if (okTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okSelector) {
                [target performSelectorOnMainThread:okSelector withObject:nil waitUntilDone:NO];
            }
        }]];
    }
    [self show:alert];
}

+ (void)setBlock:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle okBlock:(void (^)())okBlock cancelTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (cancelTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }]];
    }
    if (okTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:okTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (okBlock) {
                okBlock();
            }
        }]];
    }
    
    [self show:alert];
}

+ (void)show:(UIAlertController *)alert
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    [topController presentViewController:alert animated:YES completion:nil];
}


@end
