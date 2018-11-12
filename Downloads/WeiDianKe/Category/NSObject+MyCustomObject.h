//
//  NSObject+MyCustomObject.h
//  DressIn3D
//
//  Created by zichenfang on 15/10/17.
//  Copyright (c) 2015年 Timo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MyCustomObject)

//递归方式处理掉object中的空值
- (id)noNullObject;

@end
