//
//  OGCParser.m
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-8.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "OGCParser.h"
#import "XMLDictionary.h"

@implementation OGCParser


DEF_SINGLETON(OGCParser)

-(NSDictionary*) encodeOGCFilter:(NSDictionary*)ogcEncoding
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:Filter" forKey:@"__name"];
    [data setValue:ogcEncoding forKey:[ogcEncoding objectForKey:@"__name"]];
    
    return data;
}

-(NSDictionary*) encodeOGCSortBy:(NSString *)fieldName
{
    NSMutableDictionary* sortProperty = [NSMutableDictionary dictionary];
    [sortProperty setValue:@"ogc:SortProperty" forKey:@"__name"];
    [sortProperty setValue:fieldName forKey:@"ogc:PropertyName"];
    [sortProperty setValue:@"ASC" forKey:@"ogc:SortOrder"];
    
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:SortBy" forKey:@"__name"];
    [data setValue:sortProperty forKey:@"ogc:SortProperty"];
    
    return data;
}

-(NSDictionary*) encodeOGCFid:(NSString *)fid
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    
    [data setValue:@"ogc:FeatureId" forKey:@"__name"];
    [data setValue:fid forKey:@"_fid"];    
    
    return data;
}

#pragma ComparisionOps  比较操作

-(NSDictionary*) encodeOGCPropertyIsEqualTo:(NSString*)propertyName literal:(NSString*)literal
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsEqualTo" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:literal forKey:@"ogc:Literal"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsNotEqualTo:(NSString*)propertyName literal:(NSString*)literal
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsNotEqualTo" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:literal forKey:@"ogc:Literal"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsLessThan:(NSString*)propertyName literal:(NSString*)literal
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsLessThan" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:literal forKey:@"ogc:Literal"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsGreaterThan:(NSString*)propertyName literal:(NSString*)literal
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsGreaterThan" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:literal forKey:@"ogc:Literal"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsLessThanOrEqualTo:(NSString*)propertyName literal:(NSString*)literal
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsLessThanOrEqualTo" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:literal forKey:@"ogc:Literal"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsGreaterThanOrEqualTo:(NSString*)propertyName literal:(NSString*)literal
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsGreaterThanOrEqualTo" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:literal forKey:@"ogc:Literal"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsLike:(NSString*)propertyName literal:(NSString*)literal
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsLike" forKey:@"__name"];
    [data setValue:@"*" forKey:@"_wildCard"];
    [data setValue:@"#" forKey:@"_singleChar"];
    [data setValue:@"!" forKey:@"_escapeChar"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:literal forKey:@"ogc:Literal"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsNull:(NSString*)propertyName
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsBetween" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    
    return data;
}

-(NSDictionary*) encodeOGCPropertyIsBetween:(NSString*)propertyName lowerLiteral:(NSString*)lowerLiteral upperLiteral:(NSString*)upperLiteral
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:PropertyIsBetween" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    
    NSMutableDictionary* lowerBoundary = [NSMutableDictionary dictionary];
    [lowerBoundary setValue:@"ogc:LowerBoundary" forKey:@"__name"];
    [lowerBoundary setValue:lowerLiteral forKey:@"ogc:Literal"];
    [data setValue:lowerBoundary forKey:@"ogc:LowerBoundary"];
    
    NSMutableDictionary* upperBoundary = [NSMutableDictionary dictionary];
    [upperBoundary setValue:@"ogc:UpperBoundary" forKey:@"__name"];
    [upperBoundary setValue:upperLiteral forKey:@"ogc:Literal"];
    [data setValue:upperBoundary forKey:@"ogc:UpperBoundary"];
    
    return data;
}

#pragma SpatialOps  空间操作



-(NSDictionary*) encodeOGCIntersects:(NSString*)propertyName gmlGeometry:(NSDictionary*)gmlGeometry
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:Intersects" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:gmlGeometry forKey:[gmlGeometry objectForKey:@"__name"]];
    
    return data;
}




-(NSDictionary*) encodeOGCBBox:(NSString*)propertyName gmlEnvelope:(NSDictionary*)gmlEnvelope
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"ogc:BBox" forKey:@"__name"];
    [data setValue:propertyName forKey:@"ogc:PropertyName"];
    [data setValue:gmlEnvelope forKey:@"gml:Envelope"];
    
    return data;
}

#pragma LogicalOps  逻辑操作

@end
