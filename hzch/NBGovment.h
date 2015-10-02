//
//  NBGovment.h
//  hzch
//
//  Created by xtturing on 15/10/2.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionaryAdditions.h"
@interface NBGovment : NSObject
@property (nonatomic, assign) NSInteger CATALOGID;
@property (nonatomic, strong) NSString *ALIASNAME;
@property (nonatomic, strong) NSString *NAME;
@property (nonatomic, strong) NSString *DESCRIPTION;
@property (nonatomic, strong) NSString *CCODE;
@property (nonatomic, assign) NSInteger CORDER;
@property (nonatomic, assign) NSInteger AFFAIRPARENTID;
@property (nonatomic, assign) NSInteger CSTATUS;
@property (nonatomic, assign) NSInteger CTYPE;
@property (nonatomic, strong) NSString *UPDATETIME;
@property (nonatomic, strong) NSString *CREATETIME;
@property (nonatomic, strong) NSString *USERID;
@property (nonatomic, strong) NSString *ADMINUSERID;
@property (nonatomic, assign) NSInteger RN;
@property (nonatomic, assign) NSInteger COUNTS;
@property (nonatomic, assign) NSInteger MADATACOUNTS;
@property (nonatomic, strong) NSString *CTYPEDESC;
@property (nonatomic, strong) NSString *UPDATETIMESTR;
@property (nonatomic, strong) NSString *CREATETIMESTR;
@property (nonatomic, strong) NSString *PHOTOGRAPHDATESTR;

- (NBGovment *)initWithJsonDictionary:(NSDictionary*)dic;

+ (NBGovment *)govmentWithJsonDictionary:(NSDictionary*)dic;

@end
