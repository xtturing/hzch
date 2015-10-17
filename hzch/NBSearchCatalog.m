//
//  NBSearchCatalog.m
//  hzch
//
//  Created by xtturing on 15/10/5.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchCatalog.h"

@implementation NBSearchCatalog
- (NBSearchCatalog *)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        _fbjj=[dic getStringValueForKey:@"fbjj" defaultValue:@""];
        _metadataid=[dic getStringValueForKey:@"metadataid" defaultValue:@""];
        _tablename=[dic getStringValueForKey:@"tablename" defaultValue:@""];
        _address=[dic getStringValueForKey:@"address" defaultValue:@""];
        _objectid=[dic getStringValueForKey:@"objectid" defaultValue:@""];
        _type=[dic getStringValueForKey:@"type" defaultValue:@""];
        _labely=[dic getStringValueForKey:@"labely" defaultValue:@""];
        _labelx=[dic getStringValueForKey:@"labelx" defaultValue:@""];
        
        _name=[dic getStringValueForKey:@"name" defaultValue:@""];
        _shape_leng=[dic getStringValueForKey:@"shape_leng" defaultValue:@""];
        _entiid=[dic getStringValueForKey:@"entiid" defaultValue:@""];
        _clasid=[dic getStringValueForKey:@"clasid" defaultValue:@""];
        _elemid=[dic getStringValueForKey:@"elemid" defaultValue:@""];
        _shape_le_1=[dic getStringValueForKey:@"shape_le_1" defaultValue:@""];
    }
    return self;
}

+ (NBSearchCatalog *)searchCatalogWithJsonDictionary:(NSDictionary*)dic{
    return [[NBSearchCatalog alloc ] initWithJsonDictionary:dic];
}

@end
