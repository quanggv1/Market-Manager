//
//  ViewController.m
//  DemoInvoice
//
//  Created by Nguyen Hanh on 3/16/17.
//  Copyright © 2017 Nguyen Hanh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)createPDF:(id)sender {
    NSString *html = @"<b>Invoice</b> <br> <p>Product Name:</p> <br> <p>Price</p>";
    UIMarkupTextPrintFormatter *fmt = [[UIMarkupTextPrintFormatter alloc]
                                       initWithMarkupText:html];
    UIPrintPageRenderer *render = [[UIPrintPageRenderer alloc] init];
    [render addPrintFormatter:fmt startingAtPageAtIndex:0];
    CGRect page;
    page.origin.x=0;
    page.origin.y=0;
    page.size.width=792;
    page.size.height=612;
    
    
    CGRect printable=CGRectInset( page, 0, 0 );
    [render setValue:[NSValue valueWithCGRect:page] forKey:@"paperRect"];
    [render setValue:[NSValue valueWithCGRect:printable] forKey:@"printableRect"];
    
    NSLog(@"number of pages %d",[render numberOfPages]);
    
    NSMutableData * pdfData = [NSMutableData data];
    UIGraphicsBeginPDFContextToData( pdfData, CGRectZero, nil );
    
    for (NSInteger i=0; i < [render numberOfPages]; i++)
    {
        UIGraphicsBeginPDFPage();
        CGRect bounds = UIGraphicsGetPDFContextBounds();
        [render drawPageAtIndex:i inRect:bounds];
        
    }
    
    UIGraphicsEndPDFContext();
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * pdfFile = [documentsDirectory stringByAppendingPathComponent:@"test.pdf"];
    [pdfData writeToFile:pdfFile atomically:YES];
    NSURL * url=[NSURL fileURLWithPath:pdfFile];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    [_webview loadRequest:request];

}
@end
