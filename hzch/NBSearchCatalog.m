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
        [self CatalogShowDictionary:dic];
    }
    return self;
}

+ (NBSearchCatalog *)searchCatalogWithJsonDictionary:(NSDictionary*)dic{
    return [[NBSearchCatalog alloc ] initWithJsonDictionary:dic];
}

- (void)CatalogShowDictionary:(NSDictionary *)dic{
    _catalogDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    for(NSString *key in dic.allKeys){
        if([dic objectForKey:key] == nil || [dic objectForKey:key] == [NSNull null])
        {
            [_catalogDic removeObjectForKey:key];
        }else{
            if([[dic objectForKey:key] isKindOfClass:[NSString class]]){
                NSString *value = [dic objectForKey:key];
                if([value stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0 || [value isEqualToString:@"<null>"]){
                    [_catalogDic removeObjectForKey:key];
                }
            }
            if([key isEqualToString:@"fcode"] || [key isEqualToString:@"updatestatus"]
               || [key isEqualToString:@"refsource"] || [key isEqualToString:@"techmethod"]|| [key isEqualToString:@"featureguid"]|| [key isEqualToString:@"labelx"]|| [key isEqualToString:@"labely"]|| [key isEqualToString:@"minx"]|| [key isEqualToString:@"miny"]|| [key isEqualToString:@"centerx"]|| [key isEqualToString:@"centery"]|| [key isEqualToString:@"maxx"]|| [key isEqualToString:@"maxy"]|| [key isEqualToString:@"note"]||[key isEqualToString:@"aliasname"]|| [key isEqualToString:@"remark"]|| [key isEqualToString:@"updatetime"]|| [key isEqualToString:@"destroytime"]|| [key isEqualToString:@"destroytim"]|| [key isEqualToString:@"updatetim"]|| [key isEqualToString:@"destroyti"]|| [key isEqualToString:@"featuregui"]|| [key isEqualToString:@"techmetho"]|| [key isEqualToString:@"updatesta"]|| [key isEqualToString:@"featuregu"]){
                [_catalogDic removeObjectForKey:key];
            }
        }
    }
}

@end
