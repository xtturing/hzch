//
//  NBGovment.m
//  hzch
//
//  Created by xtturing on 15/10/2.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBGovment.h"

@implementation NBGovment
- (NBGovment *)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        _CATALOGID=[dic getIntValueForKey:@"CATALOGID" defaultValue:0];
        _NAME=[dic getStringValueForKey:@"NAME" defaultValue:@""];
        _ALIASNAME=[dic getStringValueForKey:@"ALIASNAME" defaultValue:@""];
        _DESCRIPTION=[dic getStringValueForKey:@"DESCRIPTION" defaultValue:@""];
        _CCODE=[dic getStringValueForKey:@"CCODE" defaultValue:@""];
        _CORDER=[dic getIntValueForKey:@"CORDER" defaultValue:0];
        _AFFAIRPARENTID=[dic getIntValueForKey:@"AFFAIRPARENTID" defaultValue:0];
        _CSTATUS=[dic getIntValueForKey:@"CSTATUS" defaultValue:0];
        _CTYPE=[dic getIntValueForKey:@"CTYPE" defaultValue:0];
        _UPDATETIME=[dic getStringValueForKey:@"UPDATETIME" defaultValue:@""];
        _CREATETIME=[dic getStringValueForKey:@"CREATETIME" defaultValue:@""];
        _USERID=[dic getStringValueForKey:@"USERID" defaultValue:@""];
        _ADMINUSERID=[dic getStringValueForKey:@"ADMINUSERID" defaultValue:@""];
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

+ (NBGovment *)govmentWithJsonDictionary:(NSDictionary*)dic{
    return [[NBGovment alloc ] initWithJsonDictionary:dic];
}
@end
