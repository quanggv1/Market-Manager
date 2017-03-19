//
//  InvoiceViewController.m
//  Market Manager
//
//  Created by Hanhnn1 on 3/17/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "InvoiceViewController.h"

@interface InvoiceViewController () {
    NSMutableArray *productsInvoice, *cratesInvoice;
}
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation InvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self download:API_INVOICE_PRODUCT];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)download:(NSString *)apiName {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{kOrderID:_order.ID};
    [manager GET:apiName
      parameters:params
        progress:nil
         success:^(NSURLSessionDataTask * task, id responseObject) {
             if ([[responseObject objectForKey:kCode] integerValue] == 200) {
                 if([apiName isEqualToString:API_INVOICE_PRODUCT]){
                     productsInvoice = [NSMutableArray arrayWithArray:[responseObject objectForKey:kData]];
                     [self download:API_INVOICE_CRATES];
                 } else {
                     cratesInvoice = [NSMutableArray arrayWithArray:[responseObject objectForKey:kData]];
                     [self createPDF];
                 }
             } else {
                 [CallbackAlertView setCallbackTaget:titleError
                                             message:msgSomethingWhenWrong
                                              target:self
                                             okTitle:btnOK
                                          okCallback:nil
                                         cancelTitle:nil
                                      cancelCallback:nil];
             }
             [self hideActivity];
         } failure:^(NSURLSessionDataTask * task, NSError * error) {
             [self hideActivity];
             [CallbackAlertView setCallbackTaget:titleError
                                         message:msgConnectFailed
                                          target:self
                                         okTitle:btnOK
                                      okCallback:nil
                                     cancelTitle:nil
                                  cancelCallback:nil];
         }];
}

- (void)createPDF {
    NSMutableArray *pdName, *pdPrice, *pdQuantity, *pdTotal;
    NSMutableArray *crName, *crPrice, *crQuantity, *crTotal;
    pdName = [NSMutableArray new];
    pdPrice = [NSMutableArray new];
    pdQuantity = [NSMutableArray new];
    pdTotal = [NSMutableArray new];
    crName = [NSMutableArray new];
    crPrice = [NSMutableArray new];
    crQuantity = [NSMutableArray new];
    crTotal = [NSMutableArray new];
    for (NSDictionary *item in productsInvoice) {
        [pdName addObject:item[@"name"]];
        [pdQuantity addObject:item[@"quantity"]];
        [pdPrice addObject:item[@"price"]];
        [pdTotal addObject:item[@"total"]];
    }
    for (NSDictionary *item in cratesInvoice) {
        [crName addObject:item[@"name"]];
        [crQuantity addObject:item[@"quantity"]];
        [crPrice addObject:item[@"price"]];
        [crTotal addObject:item[@"total"]];
    }

    
    NSDictionary *products = @{@"name":pdName,@"quantity":pdQuantity, @"price":pdPrice, @"total":pdTotal};
    
    NSDictionary *crates = @{@"name":crName,@"quantity":crQuantity, @"price":crPrice, @"total":crTotal};
    
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
