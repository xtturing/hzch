//
//  NSConvert.h
//  RapidReport_P
//
//  Created by hvit-pc on 14-3-20.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSConvert : NSObject
-(NSData*)NSDictionaryToNsData:(NSMutableDictionary*)p_dic;
-(NSMutableDictionary*)NsDataToNSDictionary:(NSData*)p_data;
@end
