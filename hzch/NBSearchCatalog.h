//
//  NBSearchCatalog.h
//  hzch
//
//  Created by xtturing on 15/10/5.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"

@interface NBSearchCatalog : NSObject

@property (nonatomic, strong) NSString *fbjj;
@property (nonatomic, strong) NSString *metadataid;
@property (nonatomic, strong) NSString *tablename;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *objectid;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *labely;
@property (nonatomic, strong) NSString *labelx;
@property (nonatomic, strong) NSString *shape_leng;
@property (nonatomic, strong) NSString *entiid;
@property (nonatomic, strong) NSString *clasid;
@property (nonatomic, strong) NSString *elemid;
@property (nonatomic, strong) NSString *shape_le_1;
@property (nonatomic, strong) NSMutableDictionary *catalogDic;

- (NBSearchCatalog *)initWithJsonDictionary:(NSDictionary*)dic;

+ (NBSearchCatalog *)searchCatalogWithJsonDictionary:(NSDictionary*)dic;

@end
