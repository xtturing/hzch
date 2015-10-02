//
//  NBSearch.m
//  hzch
//
//  Created by xtturing on 15/10/2.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearch.h"

@implementation NBSearch

- (NBSearch *)initWithJsonDictionary:(NSDictionary*)dic{
    if(self = [super init]){
        _tableid=[dic getStringValueForKey:@"tableid" defaultValue:@""];
        _tablename=[dic getStringValueForKey:@"tablename" defaultValue:@""];
        _objectid=[dic getStringValueForKey:@"objectid" defaultValue:@""];
        _entiid=[dic getStringValueForKey:@"entiid" defaultValue:@""];
        _industrycode=[dic getStringValueForKey:@"industrycode" defaultValue:@""];
        _name=[dic getStringValueForKey:@"name" defaultValue:@""];
        _classtype=[dic getStringValueForKey:@"classtype" defaultValue:@""];
        _divisiontype=[dic getStringValueForKey:@"divisiontype" defaultValue:@""];
        _sectiontype=[dic getStringValueForKey:@"sectiontype" defaultValue:@""];
        _province=[dic getStringValueForKey:@"province" defaultValue:@""];
        _city=[dic getStringValueForKey:@"city" defaultValue:@""];
        _town=[dic getStringValueForKey:@"town" defaultValue:@""];
        _county=[dic getStringValueForKey:@"county" defaultValue:@""];
        _address=[dic getStringValueForKey:@"address" defaultValue:@""];
        _labelx=[dic getStringValueForKey:@"labelx" defaultValue:@""];
        _labely=[dic getStringValueForKey:@"labely" defaultValue:@""];
        _minx=[dic getStringValueForKey:@"minx" defaultValue:@""];
        _miny=[dic getStringValueForKey:@"miny" defaultValue:@""];
        _maxx=[dic getStringValueForKey:@"maxx" defaultValue:@""];
        _maxy=[dic getStringValueForKey:@"maxy" defaultValue:@""];
        _centerx=[dic getStringValueForKey:@"centerx" defaultValue:@""];
        _centery=[dic getStringValueForKey:@"centery" defaultValue:@""];
        _geometry=[dic getStringValueForKey:@"geometry" defaultValue:@""];
    }
    return self;
}

+ (NBSearch *)searchWithJsonDictionary:(NSDictionary*)dic{
    return [[NBSearch alloc ] initWithJsonDictionary:dic];
}

@end
