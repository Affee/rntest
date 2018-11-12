//
//  MyBlockMthod.h
//  vrControl
//
//  Created by zichenfang on 16/2/16.
//  Copyright © 2016年 zichenfang. All rights reserved.
//





#import <Foundation/Foundation.h>
/**
 *  block传参
 */
typedef void (^TTBlock)();
typedef void (^TTBlockWithInteger)(NSInteger index);
typedef void (^TTBlockWithdDictionary)(NSDictionary *info);
typedef void (^TTBlockWithdBOOL)(BOOL whether);
typedef void (^TTBlockWithString)(NSString *string);
typedef void (^TTBlockWithdArray)(NSArray *info);

@interface TTBlockClass : NSObject

@end
