//
//  WFSHelper.h
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-21.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface TiandituQueryHelper : NSObject

/** 搜索 兴趣点名称
 */
+(void) requestTiandituQuery:(NSString*)uri queryString:(NSString*)queryString responder:(id)responder;

/** 搜索 兴趣点名称 带分页
 */
+(void) requestTiandituQueryWithPaging:(NSString*)uri layerName:(NSString*)layerName fieldName:(NSString*)fieldName queryString:(NSString*)queryString sortByFieldName:(NSString*)sortByFieldName responder:(id)responder startIndex:(NSInteger)startIndex maxFeatures:(NSInteger)maxFeatures;

+(void) requestTiandituZJQueryWithPaging:(NSString*)key pageIndex:(NSInteger)pageIndex pageStep:(NSInteger)pageStep responder:(id)responder;

@end
