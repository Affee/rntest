//
//  BookManager.h
//  weishang_vip
//
//  Created by zichenfang on 16/6/29.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookManager : NSObject
@property(nonnull,strong)NSMutableArray *books;
@property(nonnull,strong)UIViewController *parentVC;
+ (void)writeBooksInVC :( UIViewController * _Nonnull )vc Books :( NSArray * _Nonnull )books;
+ (void)clearnBooks;

@end
