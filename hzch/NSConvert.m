//
//  NSConvert.m
//  RapidReport_P
//
//  Created by hvit-pc on 14-3-20.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import "NSConvert.h"

@implementation NSConvert

-(NSData*)NSDictionaryToNsData:(NSMutableDictionary*)p_dic{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:p_dic forKey:@"Root"];
    [archiver finishEncoding];
    return  data;
}

-(NSDictionary*)NsDataToNSDictionary:(NSData*)p_data{
    NSDictionary *myDictionary;
    if (p_data.length>0) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:p_data];
        myDictionary = [unarchiver decodeObjectForKey:@"Root"];;
        [unarchiver finishDecoding];

    }else{
        myDictionary = nil;
    }
        return  myDictionary;
}

@end
