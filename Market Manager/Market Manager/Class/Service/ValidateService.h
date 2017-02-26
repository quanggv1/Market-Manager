//
//  ValidateService.h
//  Canets
//
//  Created by Quang on 12/2/16.
//  Copyright © 2016 Quang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ValidateService : NSObject
+ (NSString *)validEmail:(NSString*)emailString;
+ (NSString *)validPhone:(NSString*)phoneString;
+ (NSString *)validName:(NSString*)nameString;
+ (NSString *)validPassword:(NSString*)passwordString;
@end
