//
//  WFSParser.h
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-8.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLParser.h"
#import "OGCParser.h"

@interface WFS : NSObject

@property(nonatomic,copy) NSString* version;
@property(nonatomic,copy) NSString* service;
@property(nonatomic,retain) NSMutableDictionary* xmlNamespaceList;
@property(nonatomic,retain) NSMutableDictionary* wfsData;

/**初始化WFS
 @param service :   服务 默认 WFS
 @param version :   版本 默认 1.0.0
 @param namespaceList   :   命名空间 默认 wfs,ogc,gml
 */
+(id) wfsWithGetFeature:(NSString*)service version:(NSString*)version namespaceList:(NSMutableDictionary*)namespaceList;

+(id) wfsWithTransaction:(NSString*)service version:(NSString*)version namespaceList:(NSMutableDictionary*)namespaceList;

/**设置 WFS 分页 编码
 @param startIndex   :   
 @param maxFeatures   : 
 */
-(void) setPaging:(NSInteger)startIndex maxFeatures:(NSInteger)maxFeatures;

-(void) addQuery:(NSDictionary*)wfsQuery;

-(void) addInsert:(NSDictionary*)wfsInsert;

-(void) addUpdate:(NSDictionary*)wfsUpdate;

/**获取 wfs:Query 编码
 @param layerName   :   图层名称
 @param ogcFilter   :   查询条件
 */
-(NSDictionary*) encodeWFSQuery:(NSString*)layerName ogcFilter:(NSDictionary*)ogcFilter;

/**获取 wfs:Query 编码
 @param layerName   :   图层名称
 @param ogcFilter   :   查询条件 包括wfs:PropertyName wfs:SortBy 等
 */
-(NSDictionary*) encodeWFSQuery:(NSString*)layerName queryCondition:(NSArray*)queryCondition;

/** 获取 wfs:Insert 编码
 @param layerName   :   图层名称
 @param geometry    :
 @param attributes  :
 */
-(NSDictionary*) encodeWFSInsert:(NSString*)layerName geomFieldName:(NSString*)geomFieldName geometry:(NSDictionary*)geometry attributes:(NSDictionary*)attributes;

/** 获取 wfs:Insert 编码
 @param layerName   :   图层名称
 @param graphic    :
 */
-(NSDictionary*) encodeWFSInsert:(NSString*)layerName geomFieldName:(NSString*)geomFieldName graphic:(AGSGraphic*)graphic;

/** 更新
 @param layerName   :
 @param filter      :
 @param attributes  :
 */
-(NSDictionary*) encodeWFSUpdateAttributes:(NSString*)layerName filter:(NSDictionary*)filter attributes:(NSDictionary*)attributes;

#pragma 更高层次的接口

/**进行Identify查询 (多边形相交查询)
 @param layerName       :   图层名
 @param geomFieldName   :   几何字段的名称
 @param polygon         :   相交的多边形
 */
-(NSDictionary*) encodeWFSIdentify:(NSString*)layerName geomFieldName:(NSString*)geomFieldName polygon:(AGSPolygon*)polygon;

-(NSDictionary*) encodeWFSProperty:(NSString*)name value:(NSString*)value;


/**解析天地图查询WFS返回的结果
 */
+(NSArray*) decodeQueryResultWithString:(NSString*)responseString geometryFieldName:(NSString*)geometryFieldName;

@end

@interface WFS(AGS)



@end
