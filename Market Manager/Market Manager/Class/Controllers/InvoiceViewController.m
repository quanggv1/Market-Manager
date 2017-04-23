//
//  InvoiceViewController.m
//  Market Manager
//
//  Created by Hanhnn1 on 3/17/17.
//  Copyright © 2017 Market Manager. All rights reserved.
//

#import "InvoiceViewController.h"
#import "ProductManager.h"

@interface InvoiceViewController () <UIWebViewDelegate> {
    NSMutableArray *productsInvoice, *cratesInvoice;
    NSString *pdfFileName;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareBarButton;
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
    NSDictionary *params = @{kOrderID:_order.ID,
                             kProduct: @([[ProductManager sharedInstance] getProductType])};
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
    
    float productSum;
    for (NSNumber * n in pdTotal) {
        productSum += [n doubleValue];
    }
    float crateSum;
    for (NSNumber * n in crTotal) {
        crateSum += [n doubleValue];
    }
    
    NSDictionary *products = @{@"name":pdName,@"quantity":pdQuantity, @"price":pdPrice, @"total":pdTotal};
    
    NSDictionary *crates = @{@"name":crName,@"quantity":crQuantity, @"price":crPrice, @"total":crTotal};
    
    NSString *html = [Utils stringHTML:products crates:crates productSum:productSum crateSum:crateSum];
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * pdfFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"invoice_%@.pdf",[Utils stringTodayDateTime]]];
    
    pdfFileName = [NSString stringWithFormat:@"invoice_%@.pdf",[Utils stringTodayDateTime]];
    [pdfData writeToFile:pdfFile atomically:YES];
    NSURL * url=[NSURL fileURLWithPath:pdfFile];
    NSURLRequest * request=[[NSURLRequest alloc] initWithURL:url];
    [_webview setDelegate:self];
    [_webview loadRequest:request];
}

#pragma mark - webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
     [self hideActivity];
}

- (IBAction)shareInvoice:(id)sender {
    NSString *string = @"invoice";
    NSURL *URL = [[_webview request] URL];
    UIActivityViewController *activityViewController =
    [[UIActivityViewController alloc] initWithActivityItems:@[string, URL]
                                      applicationActivities:nil];
    
    activityViewController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popController = [activityViewController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = (UIBarButtonItem *)sender;
    popController.sourceView = (UIView *)sender;
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (IBAction)printInvoice:(id)sender {
    [self uploadPDF];
}

- (void)uploadPDF {
    [self showActivity];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    NSData *data = [NSData dataWithContentsOfURL:[[_webview request] URL]];
    
    
    [manager POST:API_INVOICE_UPLOAD  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data
                                    name:@"files"
                                fileName:pdfFileName mimeType:@"application/pdf"];
        
        // etc.
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if([[responseObject objectForKey:kData] isEqualToString:@"success"]) {
            [CallbackAlertView setCallbackTaget:@""
                                    message:titleSuccess
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];
            
        }
        [self hideActivity];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        [CallbackAlertView setCallbackTaget:titleError
                                    message:msgSomethingWhenWrong
                                     target:self
                                    okTitle:btnOK
                                 okCallback:nil
                                cancelTitle:nil
                             cancelCallback:nil];

         [self hideActivity];
    }];}

@end
