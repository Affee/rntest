//
//  BookManager.m
//  weishang_vip
//
//  Created by zichenfang on 16/6/29.
//  Copyright © 2016年 zichenfang. All rights reserved.
//

#import "BookManager.h"
#import <AddressBook/AddressBook.h>
#import "ProgressHUD.h"

@implementation BookManager

+ (id)defaultManager
{
    static BookManager *manager ;
    if (manager ==nil) {
        manager = [[BookManager alloc] init];
        manager.books = [NSMutableArray array];
    }
    return manager;
}
#pragma mark - 通讯录操作
+ (void)writeBooksInVC :( UIViewController * _Nonnull )vc Books :( NSArray * _Nonnull )books
{
    NSLog(@"%@",books);
    BookManager *manager = [BookManager defaultManager];
    manager.parentVC = vc;
    [manager.books removeAllObjects];
    [manager.books addObjectsFromArray:books];
    [manager writeBooks];
    
}

- (void)writeBooks
{
    self.parentVC.view.userInteractionEnabled = NO;
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                [self performSelector:@selector(justWriteNow) withObject:nil];
            } else {
                // User denied access
                // Display an alert telling user the contact could not be added
                NSLog(@"打开允许");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ProgressHUD dismiss];
                    [[[UIAlertView alloc] initWithTitle:nil message:@"该功能需要获得通讯录授权" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
                    self.parentVC.view.userInteractionEnabled = YES;
                });
                
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self performSelector:@selector(justWriteNow) withObject:nil];
    }
    else {
        // The user has previously denied access
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
            [[[UIAlertView alloc] initWithTitle:nil message:@"该功能需要获得通讯录授权" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
            self.parentVC.view.userInteractionEnabled = YES;
        });
    }
}
- (void)justWriteNow
{
    for (int i=0; i<self.books.count; i++) {
        //创建一个通讯录操作对象
        [self creatNewRecordWithPhone:self.books[i] Name:self.books[i] ];
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *ale =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"添加通讯录成功，请前往微信-通讯录-新的朋友中添加微信好友" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
//        [ale show];
        if (self.books.count == 1) {
            [ProgressHUD showSuccess:@"导入成功"];
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddPhoneSuccessed" object:nil];
        }
        self.parentVC.view.userInteractionEnabled = YES;
        [self.books removeAllObjects];
        [ProgressHUD dismiss];
    });

}
- (void)creatNewRecordWithPhone :(NSString *)thePhone Name :(NSString *)theName
{
    CFErrorRef error = NULL;
    
    //创建一个通讯录操作对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    //创建一条新的联系人纪录
    ABRecordRef newRecord = ABPersonCreate();
    
    //为新联系人记录添加属性值
    ABRecordSetValue(newRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)theName, &error);
    ABRecordSetValue(newRecord, kABPersonOrganizationProperty, (__bridge CFTypeRef)@"weishang", &error);
    //创建一个多值属性
    ABMutableMultiValueRef multi = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)thePhone, kABPersonPhoneMobileLabel, NULL);
    //    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"weishang", kABPersonInstantMessageServiceMSN, NULL);
    
    //    ABMultiValueAddValueAndLabel(multi, (__bridge CFTypeRef)@"11234567890", kABPersonPhoneIPhoneLabel, NULL);
    
    //将多值属性添加到记录
    ABRecordSetValue(newRecord, kABPersonPhoneProperty, multi, &error);
    CFRelease(multi);
    //添加记录到通讯录操作对象
    ABAddressBookAddRecord(addressBook, newRecord, &error);
    NSLog(@"name = %@;   phone = %@ error =%@",theName,thePhone,error);
    //保存通讯录操作对象
    ABAddressBookSave(addressBook, &error);
    CFRelease(newRecord);
    CFRelease(addressBook);
    NSLog(@"创建联系人 %@",error);
}
+ (void)clearnBooks
{
    [[BookManager defaultManager] clearnBooks];
}
- (void)clearnBooks
{
    NSMutableArray* personArray =[[NSMutableArray alloc] init];
    ABAddressBookRef addressBook =ABAddressBookCreate();
    personArray =(__bridge NSMutableArray*)ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFErrorRef *error;
    
    
    for(id  person in personArray)
    {
        NSString * organization =(__bridge NSString*)ABRecordCopyValue((__bridge ABRecordRef)(person), kABPersonOrganizationProperty);
        if ([organization isEqualToString:@"weishang"])
        {
            ABAddressBookRemoveRecord(addressBook,(__bridge ABRecordRef)(person),error);
        }
    }
    ABAddressBookSave(addressBook,nil);
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD showSuccess:@"删除成功"];
    });

    
}
@end
