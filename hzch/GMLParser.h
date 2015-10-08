//
//  GMLParser.h
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
//  GMLParser           将字符串编码成GML
//  GMLParser(AGS)      将ArcGIS的几何数据编码成GML


#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}
@interface GMLParser : NSObject

AS_SINGLETON(GMLParser)

#pragma 基本几何图形

/**获取 Point 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param coordinates :   点坐标           如:120.0,30.0
 */
-(NSDictionary*) encodeGMLPoint:(NSString*)srsName coordinates:(NSString*)coordinates;

/**获取 Box 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param coordinates :   两个点组成的包围盒         
 */
-(NSDictionary*) encodeGMLBox:(NSString*)srsName coordinates:(NSString*)coordinates;

/**获取 Envelope 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param lowerCorner :   
 @param upperCorner :   
 */
-(NSDictionary*) encodeGMLEnvelope:(NSString*)srsName lowerCorner:(NSString*)lowerCorner upperCorner:(NSString*)upperCorner;

/**获取 LineString 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param coordinates :   两个或两个以上的点串   
 */
-(NSDictionary*) encodeGMLLineString:(NSString*)srsName coordinates:(NSString*)coordinates;

/**获取 LinearRing 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param coordinates :   第一个点和最后一个点一样的点串，用于构建多边形       
 */
-(NSDictionary*) encodeGMLLinearRing:(NSString*)srsName coordinates:(NSString*)coordinates;

/**获取 Polygon 编码 由内边界和外边界的LinearRing组成的多边形 
 @param srsName             :   参考系名称        如:EPSG:4326
 @param outerBundaryList    :   多边形的外边界     NSArray<NSDictionary>
 @param innerBundaryList    :   多边形的内边界
 */
-(NSDictionary*) encodeGMLPolygon:(NSString*)srsName outerBundaryList:(NSArray*)outerBundaryList innerBundaryList:(NSArray*)innerBundaryList;

#pragma 同质几何图形

/**获取 MultiPoint 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param pointList :   pointList的集合  
 */
-(NSDictionary*) encodeGMLMultiPoint:(NSString*)srsName pointList:(NSArray*)pointList;

/**获取 MultiLineString 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param lineStringList :   lineStringList的集合  
 */
-(NSDictionary*) encodeGMLMultiLineString:(NSString*)srsName lineStringList:(NSArray*)lineStringList;

/**获取 MultiPolygon 编码
 @param srsName     :   参考系名称        如:EPSG:4326
 @param PolygonList :   PolygonList的集合  
 */
-(NSDictionary*) encodeGMLMultiPolygon:(NSString*)srsName PolygonList:(NSArray*)PolygonList;

@end

@interface GMLParser(AGSEncoder)

/**获取 Point 编码
 @param srs     :   参考系名称      
 @param point   :   点坐标    
 */
-(NSDictionary*) encodeGMLPoint:(AGSSpatialReference*)srs point:(AGSPoint*)point;

/**获取 Box 编码       
 */
-(NSDictionary*) encodeGMLBox:(AGSSpatialReference*)srs lowerPoint:(AGSPoint*)lowerPoint upperPoint:(AGSPoint*)upperPoint;

/**获取 Envelope 编码       
 */
-(NSDictionary*) encodeGMLEnvelope:(AGSSpatialReference*)srs lowerPoint:(AGSPoint*)lowerPoint upperPoint:(AGSPoint*)upperPoint;

/**获取 LineString 编码
 @param srsName     :  
 @param coordinates :   
 */
-(NSDictionary*) encodeGMLLineString:(AGSSpatialReference*)srs pointList:(NSArray*)pointList;

/**获取 LineString 编码
 @param srsName     :  
 @param coordinates :   
 */
-(NSDictionary*) encodeGMLLineString:(AGSSpatialReference*)srs polyline:(AGSPolyline*)polyline;

/**获取 LinearRing 编码
 */
-(NSDictionary*) encodeGMLLinearRing:(AGSSpatialReference*)srs pointList:(NSArray*)pointList;

/**获取 LinearRing 编码
 */
-(NSDictionary*) encodeGMLLinearRing:(AGSSpatialReference*)srs polygon:(AGSPolygon*)polygon;

/**获取 Polygon 编码 由内边界和外边界的LinearRing组成的多边形 
 @param srsName             :   参考系名称        如:EPSG:4326
 */
-(NSDictionary*) encodeGMLPolygon:(AGSSpatialReference*)srs polygon:(AGSPolygon*)polygon;

@end

@interface GMLParser(AGSDecoder)

/**将gml:Point 解码成AGSPoint
 */
-(AGSPoint*) decodeGMLPoint:(NSDictionary*)gmlPoint;

/**将gml:LineString 解码成AGSPolyline
 */
-(AGSPolyline*) decodeGMLLineString:(NSDictionary*)gmlLineString;

/**将gml:Polygon 解码成AGSPolygon
 */
-(AGSPolyline*) decodeGMLPolygon:(NSDictionary*)gmlPolygon;

/**将MultiPoint 解码成 ?
 */
//-(id) decodeGMLMultiPoint:(NSString*)srsName pointList:(NSArray*)pointList;

/**将 MultiLineString 解码成 AGSPolyline
 */
-(AGSPolyline*) decodeGMLMultiLineString:(NSDictionary*)gmlMultiPolyline;

/**将 MultiPolygon 解码成 AGSPolygon
 */
//-(NSDictionary*) decodeGMLMultiPolygon:(NSString*)srsName PolygonList:(NSArray*)PolygonList;

/**将 GML:FeatureMember 解码成 AGSGraphic
 @param gmlFeatureMember    : 
 */
-(AGSGraphic*) decodeGMLFeatureMember:(NSDictionary*)gmlFeatureMember geometryFieldName:(NSString*)geometryFieldName;

@end