//
//  NBSpatialData.m
//  hzch
//
//  Created by xtturing on 15/9/28.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSpatialData.h"

@implementation NBSpatialData

- (NBSpatialData *)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        _name=[dic getStringValueForKey:@"name" defaultValue:@""];
        _updatetime=[dic getStringValueForKey:@"updatetime" defaultValue:@""];
        _url=[dic getStringValueForKey:@"url" defaultValue:@""];
        _news=[dic getStringValueForKey:@"news" defaultValue:@""];
        _note=[dic getStringValueForKey:@"note" defaultValue:@""];
    }
    return self;
}

+ (NBSpatialData *)spatialDataWithJsonDictionary:(NSDictionary*)dic{
    return [[NBSpatialData alloc ] initWithJsonDictionary:dic];
}

@end
