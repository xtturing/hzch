//
//  NBTpk.m
//  nbtdt
//
//  Created by xtturing on 14-8-31.
//
//

#import "NBTpk.h"

@implementation NBTpk

- (NBTpk *)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        _tpkid=[dic getStringValueForKey:@"tpkid" defaultValue:@""];
        _name=[dic getStringValueForKey:@"name" defaultValue:@""];
        _type=[dic getStringValueForKey:@"type" defaultValue:@""];
        _content=[dic getStringValueForKey:@"content" defaultValue:@""];
        _updatetime=[dic getStringValueForKey:@"updatetime" defaultValue:@""];
        _tpkname=[dic getStringValueForKey:@"tpkname" defaultValue:@""];
        _url=[dic getStringValueForKey:@"url" defaultValue:@""];
        _news=[dic getStringValueForKey:@"news" defaultValue:@""];
    }
    return self;
}

+ (NBTpk *)tpkWithJsonDictionary:(NSDictionary*)dic{
    return [[NBTpk alloc ] initWithJsonDictionary:dic];
}

@end
