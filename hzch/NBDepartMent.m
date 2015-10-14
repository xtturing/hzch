//
//  NBDepartMent.m
//  hzch
//
//  Created by xtturing on 15/9/30.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBDepartMent.h"

@implementation NBDepartMent

- (NBDepartMent *)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        _CATALOGID=[dic getIntValueForKey:@"CATALOGID" defaultValue:0];
        _NAME=[dic getStringValueForKey:@"NAME" defaultValue:@""];
        _DESCRIPTION=[dic getStringValueForKey:@"DESCRIPTION" defaultValue:@""];
        _CCODE=[dic getStringValueForKey:@"CCODE" defaultValue:@""];
        _CORDER=[dic getIntValueForKey:@"CORDER" defaultValue:0];
        _DEPARTMENTPARENTID=[dic getIntValueForKey:@"DEPARTMENTPARENTID" defaultValue:0];
        _CSTATUS=[dic getIntValueForKey:@"CSTATUS" defaultValue:0];
        _CTYPE=[dic getIntValueForKey:@"CTYPE" defaultValue:0];
        _UPDATETIME=[dic getStringValueForKey:@"UPDATETIME" defaultValue:@""];
        _CREATETIME=[dic getStringValueForKey:@"CREATETIME" defaultValue:@""];
        _USERID=[dic getStringValueForKey:@"USERID" defaultValue:@""];
        _RN=[dic getIntValueForKey:@"RN" defaultValue:0];
        _COUNTS=[dic getIntValueForKey:@"COUNTS" defaultValue:0];
        _MADATACOUNTS=[dic getIntValueForKey:@"MADATACOUNTS" defaultValue:0];
        _CTYPEDESC=[dic getStringValueForKey:@"CTYPEDESC" defaultValue:@""];
        _UPDATETIMESTR=[dic getStringValueForKey:@"UPDATETIMESTR" defaultValue:@""];
        _CREATETIMESTR=[dic getStringValueForKey:@"CREATETIMESTR" defaultValue:@""];
        _PHOTOGRAPHDATESTR=[dic getStringValueForKey:@"PHOTOGRAPHDATESTR" defaultValue:@""];
        NSDictionary *SERVICES = [dic objectForKey:@"SERVICES"];
        if(SERVICES && [[SERVICES allKeys] count] > 0){
            _WMS=[SERVICES getStringValueForKey:@"wms" defaultValue:@""];
            _WMTS=[SERVICES getStringValueForKey:@"wmts" defaultValue:@""];
        }
    }
    return self;
}

+ (NBDepartMent *)departMentWithJsonDictionary:(NSDictionary*)dic{
    return [[NBDepartMent alloc ] initWithJsonDictionary:dic];
}

@end
