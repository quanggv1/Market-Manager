

#import "ActivityView.h"

// Part ID
typedef NS_ENUM(NSInteger, kActivityViewParts) {
    kActivityViewPartsIndicator = 0,
    kActivityViewPartsProgress,
    kActivityViewPartsMessage,
    kActivityViewPartsCancelButton,
};

// Top and bottom margins
static CGFloat kActivityViewVerticalMargin = 30;

@interface ActivityView ()

// Target of cancel processing
@property (nonatomic, assign) id cancelTarget;
// selector for cancel processing
@property (nonatomic, assign) SEL cancelSelector;

@end

@implementation ActivityView {
    kActivityViewStyle style_;
    BOOL isCancelable_;
    UIView *activityBaseView_;
    UIView *markBase_;
    UIActivityIndicatorView *activityMark_;
    UIProgressView *progressView_;
    NSString *message_;
    UILabel *messageLabel_;
    UIButton *cancelButton_;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        style_ = kActivityViewStyleDefault;
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setAlpha:1.0f];
        [self setHidden:YES];
        
        // Variable up and down by Autolayout so that it is always displayed full screen (corresponding to screen rotation)
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth|
                                 UIViewAutoresizingFlexibleHeight);
        

        // generate a visible part
        activityBaseView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kActivityViewBaseWidth, kActivityViewBaseHeight)];
        activityBaseView_.center = CGPointMake(self.frame.size.width/2,
                                               self.frame.size.height/2);
        activityBaseView_.layer.cornerRadius = 12;
        [activityBaseView_ setBackgroundColor:[UIColor blackColor]];
        [activityBaseView_ setAlpha:1.0f];
        
        // Make the margin variable with Autolayout so that it is always displayed in the center (corresponding to screen rotation)
        activityBaseView_.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin|
                                              UIViewAutoresizingFlexibleRightMargin|
                                              UIViewAutoresizingFlexibleTopMargin|
                                              UIViewAutoresizingFlexibleBottomMargin);
        
        // Set label, progress bar, cancel button
        [self settingSubviews];
        [self addSubview:activityBaseView_];
        
        // Set the layout for each Activity type
        [self setLayout];
    }
    return self;
}

// Set label, progress bar, cancel button
- (void)settingSubviews
{
    // Indicator
    activityMark_ = [[UIActivityIndicatorView alloc] init];
    activityMark_.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [activityMark_ stopAnimating];
    
    // Prepare the foundation
    // Prepare base here because UIActivityIndicatorView can not handle in frame
    markBase_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 37, 37)];
    [markBase_ addSubview:activityMark_];
    
    activityMark_.center = CGPointMake(markBase_.frame.size.width/2,
                                       markBase_.frame.size.height/2);
    
    [activityBaseView_ addSubview:markBase_];
    
    // Label
    messageLabel_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [messageLabel_ setFont:[UIFont systemFontOfSize:16]];
    [messageLabel_ setTextColor:[UIColor whiteColor]];
    [messageLabel_ setTextAlignment:NSTextAlignmentCenter];
    [messageLabel_ setHidden:YES];
    [activityBaseView_ addSubview:messageLabel_];
    
    // progress bar
    progressView_ = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView_.frame = CGRectMake(0, 0, kActivityViewBaseWidth - 20, 40);
    [progressView_ setHidden:YES];
    [activityBaseView_ addSubview:progressView_];
    
    // Cancel button
    cancelButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 24)];
    [cancelButton_ setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton_.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [cancelButton_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton_.layer setCornerRadius:12.0f];
    [cancelButton_.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [cancelButton_.layer setBorderWidth:1.0f];
    [cancelButton_ addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton_ setHidden:YES];
    [activityBaseView_ addSubview:cancelButton_];
}

// Set the style of ActivityView
- (void)setActivityStyle:(kActivityViewStyle)style isCancelable:(BOOL)isCancelable
{
    style_ = style;
    isCancelable_ = isCancelable;
    [self setLayout];
}

// Set the message
- (void)setMessage:(NSString *)message
{
    if ([message length] == 0) {
        message_ = @"";
    } else {
        message_ = message;
    }
    [self setLayout];
}

// Clear the message
- (void)removeMessage
{
    message_ = @"";
    [messageLabel_ setHidden:YES];
}

// Set the value of the progress bar
- (void)setProgress:(CGFloat)progress
{
    [progressView_ setProgress:progress animated:YES];
}

// Set action on cancel button
- (void)setCancelActionWithTarget:(id)target selector:(SEL)selector
{
    if (target == nil || selector == nil) return;
    
    self.cancelTarget = target;
    self.cancelSelector = selector;
}

// Set the layout for each Activity type
- (void)setLayout
{
    NSArray *parts = [self partsForStyle:style_ isCancelable:isCancelable_];
    
    // Define the order
    NSArray *orderArray = @[@(kActivityViewPartsIndicator),  @(kActivityViewPartsMessage), @(kActivityViewPartsProgress), @(kActivityViewPartsCancelButton)];
    
    CGFloat startY = kActivityViewVerticalMargin;
    
    for (NSNumber *type in orderArray) {
        if (![parts containsObject:type]) {
            switch (type.integerValue) {
                case kActivityViewPartsIndicator:
                    [markBase_ setHidden:YES];
                    break;
                case kActivityViewPartsProgress:
                    [progressView_ setProgress:0];
                    [progressView_ setHidden:YES];
                    break;
                case kActivityViewPartsMessage:
                    [self removeMessage];
                    break;
                case kActivityViewPartsCancelButton:
                    isCancelable_ = NO;
                    self.cancelTarget = nil;
                    self.cancelSelector = nil;
                    [cancelButton_ setHidden:YES];
                    break;
                default:
                    break;
            }
            continue;
        }
        
        switch (type.integerValue) {
            case kActivityViewPartsIndicator:
            {
                [markBase_ setHidden:NO];
                CGRect frame = markBase_.frame;
                frame.origin.y = startY;
                markBase_.frame = frame;
                startY += frame.size.height;
            }
                break;
            case kActivityViewPartsMessage:
            {
                [messageLabel_ setText:message_];
                [messageLabel_ setHidden:NO];
                [messageLabel_ sizeToFit];
                startY += 10;
                CGRect frame = messageLabel_.frame;
                frame.origin.y = startY;
                messageLabel_.frame = frame;
                startY += frame.size.height;
            }
                break;
            case kActivityViewPartsProgress:
            {
                [progressView_ setHidden:NO];
                startY += 5;
                CGRect frame = progressView_.frame;
                frame.origin.y = startY;
                progressView_.frame = frame;
                startY += frame.size.height;
            }
                break;
            case kActivityViewPartsCancelButton:
            {
                [cancelButton_ setHidden:NO];
                startY += 15;
                CGRect frame = cancelButton_.frame;
                frame.origin.y = startY + 5;
                cancelButton_.frame = frame;
                startY += frame.size.height;
            }
                break;
            default:
                break;
        }
    }
    
    CGFloat baseWidth = MAX(kActivityViewBaseWidth, messageLabel_.frame.size.width + 20);
    CGRect frame = activityBaseView_.frame;
    frame.size.width = baseWidth;
    frame.size.height = startY + kActivityViewVerticalMargin;
    activityBaseView_.frame = frame;
    
    activityBaseView_.center = CGPointMake(self.frame.size.width/2,
                                           self.frame.size.height/2);
    
    markBase_.center = CGPointMake(activityBaseView_.frame.size.width/2,
                                   markBase_.center.y);
    
    progressView_.center = CGPointMake(activityBaseView_.frame.size.width/2,
                                       progressView_.center.y);
    
    messageLabel_.center = CGPointMake(activityBaseView_.frame.size.width/2,
                                       messageLabel_.center.y);
    
    cancelButton_.center = CGPointMake(activityBaseView_.frame.size.width/2,
                                       cancelButton_.center.y);
    
    // Interrupt screen update
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.0f]];
}

// Set the style of the alert to be displayed
- (NSArray *)partsForStyle:(kActivityViewStyle)style isCancelable:(BOOL)isCancelable
{
    NSMutableArray *parts = [NSMutableArray array];
    switch (style_) {
        case kActivityViewStyleDefault:
            [parts addObjectsFromArray:@[@(kActivityViewPartsIndicator)]];
            break;
        case kActivityViewStyleMessage:
            [parts addObjectsFromArray:@[@(kActivityViewPartsIndicator), @(kActivityViewPartsMessage)]];
            break;
        case kActivityViewStyleProgress:
            [parts addObjectsFromArray:@[@(kActivityViewPartsProgress), @(kActivityViewPartsMessage)]];
            break;
        default:
            break;
    }
    
    if (isCancelable_) {
        [parts addObject:@(kActivityViewPartsCancelButton)];
    }
    
    return parts;
}

- (void)show
{
    [self setFrame:[[self superview] frame]];
    [self setLayout];
    [self setHidden:NO];
    [activityMark_ startAnimating];
}

- (void)hide
{
    [self setHidden:YES];
    [activityMark_ stopAnimating];
    style_ = kActivityViewStyleDefault;
    isCancelable_ = NO;
}


- (void)onCancel
{
    if (self.cancelTarget == nil || self.cancelSelector == nil) return;
    if ([self.cancelTarget respondsToSelector:self.cancelSelector]) {
		[self.cancelTarget performSelector:self.cancelSelector withObject:nil afterDelay:0.0];
	}
    [self hide];
}

- (void)removeCancelButton
{
    isCancelable_ = NO;
    [cancelButton_ setHidden:YES];
    
    [self setLayout];
}

@end
