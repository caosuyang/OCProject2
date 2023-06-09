//
//  SecurityUtil.h
//  Smile
//
//  Created by apple on 15/8/25.
//  Copyright (c) 2015年 Weconex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;

+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密
//将string转成带密码的data -- 128
+ (NSString*)encryptAESData:(NSString*)string;

//将带密码的data转成string -- 128
+ (NSString*)decryptAESData:(NSString*)string;


//AES加密将string转成带密码的data -- 256

+ (NSString*)encryptAESData256:(NSString*)string withKey:(NSString *)key withIv:(NSString *)iv;

//将带密码的data转成string -- 256
+ (NSString*)decryptAESData256:(NSString*)string withKey:(NSString *)key withIv:(NSString *)iv;

+(NSString*)encryptAESData128:(NSString*)string withKey:(NSString *)key withIv:(NSString *)iv;

@end
