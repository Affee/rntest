//
//  NSDictionary+MyCustomDictionary.h
//  DressIn3D
//
//  Created by zichenfang on 15/11/17.
//  Copyright © 2015年 Timo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MyCustomDictionary)
-(NSString *)string_ForKey:(NSString *)theKey;
-(NSArray *)array_ForKey:(NSString *)theKey;
-(NSDictionary *)dictionary_ForKey:(NSString *)theKey;
-(NSString *)json_String;
- (NSMutableData *)xmlPostData;

@end
