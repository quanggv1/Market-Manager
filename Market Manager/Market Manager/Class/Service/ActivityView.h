#import <UIKit/UIKit.h>


@interface ActivityView : UIView

/**
  Set the style of ActivityView
  @ Param style style
  @ Param isCancelable Cancelable?
 */
- (void)setActivityStyle:(kActivityViewStyle)style isCancelable:(BOOL)isCancelable;

/**
  Set up a message
  @ Param message Message
*/
- (void)setMessage:(NSString *)message;

/**
  Set the value of the progress bar
  @ Param progress value
 */
- (void)setProgress:(CGFloat)progress;

/**
  Set an action on the Cancel button
  @ Param target Target to perform cancel processing
  @ Param selector Cancellation selector
*/
- (void)setCancelActionWithTarget:(id)target selector:(SEL)selector;

/**
  Display ActivityView (full screen)
*/
- (void)show;

/**
  Hide ActivityView
*/
- (void)hide;

@end
