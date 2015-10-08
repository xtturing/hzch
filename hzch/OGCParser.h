//
//  OGCParser.h
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-8.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@interface OGCParser : NSObject

AS_SINGLETON(OGCParser)

/**获取 ogc:Filter 编码
 */
-(NSDictionary*) encodeOGCFilter:(NSDictionary*)ogcEncoding; 

/**获取 wfs:SortBy 编码
 @param fieldName   :   排列的字段
 */
-(NSDictionary*) encodeOGCSortBy:(NSString *)fieldName;

/**获取 wfs:fid 编码
 @param fid   :   排列的字段
 */
-(NSDictionary*) encodeOGCFid:(NSString *)fid;

#pragma ComparisionOps  比较操作

/**获取 PropertyIsEqualTo 编码
 @param propertyName    :   属性名称
 @param literal         :   属性值
 */
-(NSDictionary*) encodeOGCPropertyIsEqualTo:(NSString*)propertyName literal:(NSString*)literal;

/**获取 PropertyIsNotEqualTo 编码
 @param propertyName    :   属性名称
 @param literal         :   属性值
 */
-(NSDictionary*) encodeOGCPropertyIsNotEqualTo:(NSString*)propertyName literal:(NSString*)literal;

/**获取 PropertyIsLessThan 编码
 @param propertyName    :   属性名称
 @param literal         :   属性值
 */
-(NSDictionary*) encodeOGCPropertyIsLessThan:(NSString*)propertyName literal:(NSString*)literal;

/**获取 PropertyIsGreaterThan 编码
 @param propertyName    :   属性名称
 @param literal         :   属性值
 */
-(NSDictionary*) encodeOGCPropertyIsGreaterThan:(NSString*)propertyName literal:(NSString*)literal;

/**获取 PropertyIsLessThanOrEqualTo 编码
 @param propertyName    :   属性名称
 @param literal         :   属性值
 */
-(NSDictionary*) encodeOGCPropertyIsLessThanOrEqualTo:(NSString*)propertyName literal:(NSString*)literal;

/**获取 PropertyIsGreaterThanOrEqualTo 编码
 @param propertyName    :   属性名称
 @param literal         :   属性值
 */
-(NSDictionary*) encodeOGCPropertyIsGreaterThanOrEqualTo:(NSString*)propertyName literal:(NSString*)literal;

/**获取 PropertyIsLike 编码
 @param propertyName    :   属性名称
 @param literal         :   属性值
 */
-(NSDictionary*) encodeOGCPropertyIsLike:(NSString*)propertyName literal:(NSString*)literal;

/**获取 PropertyIsNull 编码
 @param propertyName    :   属性名称
 */
-(NSDictionary*) encodeOGCPropertyIsNull:(NSString*)propertyName;

/**获取 PropertyIsBetween 编码
 @param propertyName    :   属性名称
 @param lowerLiteral    :   下限
 @param upperLiteral    :   上限
 */
-(NSDictionary*) encodeOGCPropertyIsBetween:(NSString*)propertyName lowerLiteral:(NSString*)lowerLiteral upperLiteral:(NSString*)upperLiteral;

#pragma SpatialOps  空间操作

/**获取 Equals 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCEquals:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 Disjoint 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCDisjoint:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 Touches 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCTouches:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 Within 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCWithin:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 Overlaps 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCOverlaps:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 Crosses 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCCrosses:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 Intersects 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCIntersects:(NSString*)propertyName gmlGeometry:(NSDictionary*)gmlGeometry;

/**获取 Contains 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCContains:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 DWithin 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCDWithin:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 Beyond 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCBeyond:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

/**获取 BBox 编码
 @param propertyName    :   属性名称
 @param gmlEnvelope     :   GML描述的Envelope
 */
-(NSDictionary*) encodeOGCBBox:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope;

#pragma LogicalOps  逻辑操作

-(NSDictionary*) encodeOGCAnd;

-(NSDictionary*) encodeOGCOr;

-(NSDictionary*) encodeOGCNot;

@end
