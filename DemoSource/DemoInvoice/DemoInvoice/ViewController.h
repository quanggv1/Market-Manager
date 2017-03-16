//
//  ViewController.h
//  DemoInvoice
//
//  Created by Nguyen Hanh on 3/16/17.
//  Copyright © 2017 Nguyen Hanh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)createPDF:(id)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webview;


@end

