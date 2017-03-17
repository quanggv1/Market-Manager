//
//  InvoiceViewController.m
//  Market Manager
//
//  Created by Hanhnn1 on 3/17/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "InvoiceViewController.h"

@interface InvoiceViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPDF];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createPDF {
    
    
    
    NSDictionary *products = @{@"name":@[@"AAAA", @"BBBB", @"CCC"],@"quantity":@[@10, @12, @13], @"price":@[@10,@12,@5], @"total":@[@100, @144, @65]};
    NSDictionary *crates = @{@"name":@[@"KKK", @"EEE", @"TT"],@"quantity":@[@10, @1, @2], @"price":@[@10,@12,@5], @"total":@[@100, @12, @10]};
    
    NSString *html = [Utils stringHTML:products crates:crates];
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
    
    NSLog(@"number of pages %ld",[render numberOfPages]);
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
