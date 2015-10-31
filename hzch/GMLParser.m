//
//  GMLParser.m
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "GMLParser.h"

@interface GMLParser(Private)

#pragma 要素特征模型方法

/**获取 OuterBundary 编码
 @param linearRing :    
 */
-(NSDictionary*) encodeGMLOuterBundary:(NSDictionary*)linearRing;

/**获取 InnerBundary 编码
 @param linearRing :    
 */
-(NSDictionary*) encodeGMLInnerBundary:(NSDictionary*)linearRing;

/**获取 pointMember 编码
 #param point  :   
 */
-(NSDictionary*) encodeGMLPointMember:(NSDictionary*)point;

/**获取 lineStringMember 编码
 #param lineString  :   
 */
-(NSDictionary*) encodeGMLLineStringMember:(NSDictionary*)lineString;

/**获取 polygonMember 编码
 #param polygon  :   
 */
-(NSDictionary*) encodeGMLPolygonMember:(NSDictionary*)polygon;

@end

@implementation GMLParser

DEF_SINGLETON(GMLParser)

-(NSDictionary*) encodeGMLPoint:(NSString*)srsName coordinates:(NSString*)coordinates
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:Point" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    [data setValue:coordinates forKey:@"gml:coordinates"];
    
    return data;
}

-(NSDictionary*) encodeGMLBox:(NSString*)srsName coordinates:(NSString*)coordinates
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:Box" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    [data setValue:coordinates forKey:@"gml:coordinates"];
    
    return data;
}

-(NSDictionary*) encodeGMLEnvelope:(NSString*)srsName lowerCorner:(NSString*)lowerCorner upperCorner:(NSString*)upperCorner
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:Envelope" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    [data setValue:lowerCorner forKey:@"gml:lowerCorner"];
    [data setValue:upperCorner forKey:@"gml:upperCorner"];
    
    return data;
}

-(NSDictionary*) encodeGMLLineString:(NSString*)srsName coordinates:(NSString*)coordinates
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:LineString" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    [data setValue:coordinates forKey:@"gml:coordinates"];
    
    return data;
}

-(NSDictionary*) encodeGMLLinearRing:(NSString*)srsName coordinates:(NSString*)coordinates
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:LinearRing" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    [data setValue:coordinates forKey:@"gml:coordinates"];
    
    return data;
}

-(NSDictionary*) encodeGMLPolygon:(NSString*)srsName outerBundaryList:(NSArray*)outerBundaryList innerBundaryList:(NSArray*)innerBundaryList
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:Polygon" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    
    for (NSDictionary* linearRing in outerBundaryList) 
    {
        [data setValue:[self encodeGMLOuterBundary:linearRing] forKey:@"gml:outerBoundaryIs"];
    }
    
    for (NSDictionary* linearRing in innerBundaryList) 
    {
        [data setValue:[self encodeGMLInnerBundary:linearRing] forKey:@"gml:innerBoundaryIs"];
    }
    
    return data;
}

-(NSDictionary*) encodeGMLMultiPoint:(NSString*)srsName pointList:(NSArray*)pointList
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:MultiPoint" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    
    for (NSDictionary* point in pointList)
    {
        [data setValue:[self encodeGMLPointMember:point] forKey:@"gml:PointMember"];
    }
    
    return data;
}

-(NSDictionary*) encodeGMLMultiLineString:(NSString*)srsName lineStringList:(NSArray*)lineStringList
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:MultiLineString" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    
    for (NSDictionary* lineString in lineStringList)
    {
        [data setValue:[self encodeGMLLineStringMember:lineString] forKey:@"gml:LineStringMember"];
    }
    
    return data;
}

-(NSDictionary*) encodeGMLMultiPolygon:(NSString*)srsName PolygonList:(NSArray*)PolygonList
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"gml:MultiPolygon" forKey:@"__name"];
    [data setValue:srsName forKey:@"_srsName"];
    
    for (NSDictionary* polygon in PolygonList)
    {
        [data setValue:[self encodeGMLPolygonMember:polygon] forKey:@"gml:PolyognMember"];
    }
    
    return data;
}

#pragma Private

-(NSDictionary*) encodeGMLOuterBundary:(NSDictionary*)linearRing
{
    NSMutableDictionary* outerBundary = [NSMutableDictionary dictionary];
    [outerBundary setValue:@"gml:outerBoundaryIs" forKey:@"__name"];
    [outerBundary setValue:linearRing forKey:[linearRing objectForKey:@"__name"]];
    
    return outerBundary;
}

-(NSDictionary*) encodeGMLInnerBundary:(NSDictionary*)linearRing
{
    NSMutableDictionary* innerBundary = [NSMutableDictionary dictionary];
    [innerBundary setValue:@"gml:innerBoundaryIs" forKey:@"__name"];
    [innerBundary setValue:linearRing forKey:[linearRing objectForKey:@"__name"]];
    
    return innerBundary;
}

-(NSDictionary*) encodeGMLPointMember:(NSDictionary*)point
{
    NSMutableDictionary* pointMember = [NSMutableDictionary dictionary];
    [pointMember setValue:@"gml:PointMember" forKey:@"__name"];
    [pointMember setValue:point forKey:[point objectForKey:@"__name"]];
    
    return pointMember;
}

-(NSDictionary*) encodeGMLLineStringMember:(NSDictionary*)lineString
{
    NSMutableDictionary* lineStringMember = [NSMutableDictionary dictionary];
    [lineStringMember setValue:@"gml:LineStringMember" forKey:@"__name"];
    [lineStringMember setValue:lineString forKey:[lineString objectForKey:@"__name"]];
    
    return lineStringMember;
}

-(NSDictionary*) encodeGMLPolygonMember:(NSDictionary*)polygon
{
    NSMutableDictionary* polygonMember = [NSMutableDictionary dictionary];
    [polygonMember setValue:@"gml:PolyognMember" forKey:@"__name"];
    [polygonMember setValue:polygon forKey:[polygon objectForKey:@"__name"]];
    
    return polygonMember;
}

#pragma 为ArcGIS对象封装

-(NSDictionary*) encodeGMLPoint:(AGSSpatialReference*)srs point:(AGSPoint*)point
{
    NSString* coordinates = [NSString stringWithFormat:@"%f,%f",point.x,point.y];
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
    
    return [self encodeGMLPoint:srsName coordinates:coordinates];
}

-(NSDictionary*) encodeGMLBox:(AGSSpatialReference*)srs lowerPoint:(AGSPoint*)lowerPoint upperPoint:(AGSPoint*)upperPoint
{
    NSString* coordinates = [NSString stringWithFormat:@"%f,%f %f,%f",lowerPoint.x,lowerPoint.y,upperPoint.x,upperPoint.y];
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
    
    return [self encodeGMLBox:srsName coordinates:coordinates];
}

-(NSDictionary*) encodeGMLEnvelope:(AGSSpatialReference*)srs lowerPoint:(AGSPoint*)lowerPoint upperPoint:(AGSPoint*)upperPoint
{
    NSString* lowerCorner = [NSString stringWithFormat:@"%f,%f",lowerPoint.x,lowerPoint.y];
    NSString* upperCorner = [NSString stringWithFormat:@"%f,%f",upperPoint.x,upperPoint.y];
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
    
    return [self encodeGMLEnvelope:srsName lowerCorner:lowerCorner upperCorner:upperCorner];
}

-(NSDictionary*) encodeGMLLineString:(AGSSpatialReference*)srs pointList:(NSArray*)pointList
{
    NSMutableString* coordinates = [NSMutableString string];
    for (AGSPoint* point in pointList)
    {
        [coordinates appendFormat:@"%f,%f ",point.x,point.y];
    }
    
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
    
    return [self encodeGMLLineString:srsName coordinates:coordinates];
}

-(NSDictionary*) encodeGMLLineString:(AGSSpatialReference*)srs polyline:(AGSPolyline*)polyline
{
    NSMutableString* coordinates = [NSMutableString string];
    for(int i=0; i<[polyline numPaths]; i++)
    {
        for (int j=0; j<[polyline numPointsInPath:i]; j++)
        {
            AGSPoint* point = [polyline pointOnPath:i atIndex:j];
            [coordinates appendFormat:@"%f,%f ",point.x,point.y];
        }
    }
    
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
    
    return [self encodeGMLLineString:srsName coordinates:coordinates];
}

-(NSDictionary*) encodeGMLLinearRing:(AGSSpatialReference*)srs pointList:(NSArray*)pointList
{
    NSMutableString* coordinates = [NSMutableString string];
    for (AGSPoint* point in pointList)
    {
        [coordinates appendFormat:@"%f,%f ",point.x,point.y];
    }
    
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
    
    return [self encodeGMLLinearRing:srsName coordinates:coordinates];
}

-(NSDictionary*) encodeGMLLinearRing:(AGSSpatialReference*)srs polygon:(AGSPolygon*)polygon
{
    NSMutableString* coordinates = [NSMutableString string];
    for (int i=0; i<[polygon numRings]; i++)
    {
        for (int j=0; j<[polygon numPointsInRing:i]; j++)
        {
            AGSPoint* point = [polygon pointOnRing:i atIndex:j];
            [coordinates appendFormat:@"%f,%f ",point.x,point.y];
        }
    }
    AGSPoint* point = [polygon pointOnRing:0 atIndex:0];
    [coordinates appendFormat:@"%f,%f ",point.x,point.y];
    
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
    
    return [self encodeGMLLinearRing:srsName coordinates:coordinates];
}

-(NSDictionary*) encodeGMLPolygon:(AGSSpatialReference*)srs polygon:(AGSPolygon*)polygon
{
    NSDictionary* linearRing = [self encodeGMLLinearRing:srs polygon:polygon];
    NSString* srsName = [NSString stringWithFormat:@"EPSG:%lu",(unsigned long)srs.wkid];
        
    return [self encodeGMLPolygon:srsName outerBundaryList:[NSArray arrayWithObjects:linearRing, nil] innerBundaryList:nil];
}

#pragma 将GML解码成ArcGIS对象

-(AGSPoint*) decodeGMLPoint:(NSDictionary*)gmlPoint
{
    NSString* srsName = [gmlPoint objectForKey:@"_srsName"];

    NSString* coordinates = [gmlPoint objectForKey:@"gml:coordinates"];
    if (coordinates == nil)
    {
        coordinates = [gmlPoint objectForKey:@"gml:coord"];
    }
    
    if ([coordinates isKindOfClass:[NSDictionary class]])
    {
        NSDictionary* dic = (NSDictionary*)coordinates;
        if([[dic allKeys] indexOfObject:@"__text"] != NSNotFound)
        {
            coordinates = [[gmlPoint objectForKey:@"gml:coordinates"] objectForKey:@"__text"];
        }
        else    
        {
            NSInteger wkid = [[[srsName componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
            AGSSpatialReference* srs = [AGSSpatialReference spatialReferenceWithWKID:wkid];
            NSString* x = [dic objectForKey:@"gml:X"];
            NSString* y = [dic objectForKey:@"gml:Y"];
            
            return [AGSPoint pointWithX:[x doubleValue] y:[y doubleValue] spatialReference:srs];
        }
    }

    NSArray* xyList = [coordinates componentsSeparatedByString:@","];
    
    NSArray* srsList = [srsName componentsSeparatedByString:@":"];
    if ([srsList count] == 2)
    {
        NSInteger wkid = [[[srsName componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
        AGSSpatialReference* srs = [AGSSpatialReference spatialReferenceWithWKID:wkid];
        
        return [AGSPoint pointWithX:[[xyList objectAtIndex:0] doubleValue] y:[[xyList objectAtIndex:1] doubleValue] spatialReference:srs];
    }
    else
    {
        return [AGSPoint pointWithX:[[xyList objectAtIndex:0] doubleValue] y:[[xyList objectAtIndex:1] doubleValue] spatialReference:nil];
    }
}

-(AGSPolyline*) decodeGMLLineString:(NSDictionary*)gmlLineString
{
    NSString* srsName = [gmlLineString objectForKey:@"_srsName"];
    NSString* coordinates = [[gmlLineString objectForKey:@"gml:coordinates"] objectForKey:@"__text"];
    NSArray* xyStringList = [coordinates componentsSeparatedByString:@" "];
    NSInteger wkid = [[[srsName componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    AGSSpatialReference* srs = [AGSSpatialReference spatialReferenceWithWKID:wkid];
    
    AGSMutablePolyline* polyline = [[AGSMutablePolyline alloc] initWithSpatialReference:srs];
    [polyline addPathToPolyline];
    for (NSString* xyString in xyStringList)
    {
        NSArray* xyList = [xyString componentsSeparatedByString:@","];
        AGSPoint* point = [AGSPoint pointWithX:[[xyList objectAtIndex:0] doubleValue] y:[[xyList objectAtIndex:1] doubleValue] spatialReference:srs];
        [polyline addPointToPath:point];
    }
    
    return polyline;
}

-(AGSPolyline*) decodeGMLPolygon:(NSDictionary*)gmlPolygon
{
    return nil;
}

-(AGSPolyline*) decodeGMLMultiLineString:(NSDictionary*)gmlMultiPolyline
{
    NSString* srsName = [gmlMultiPolyline objectForKey:@"_srsName"];
    NSInteger wkid = [[[srsName componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    AGSSpatialReference* srs = [AGSSpatialReference spatialReferenceWithWKID:wkid];
    
    id lineStringMemberNode = [gmlMultiPolyline objectForKey:@"gml:lineStringMember"];
    if ([lineStringMemberNode isKindOfClass:[NSArray class]])               //有多个LineString
    {   
        AGSMutablePolyline* polyline = [[AGSMutablePolyline alloc] initWithSpatialReference:srs];
        for (NSDictionary* lineStringMember in lineStringMemberNode)
        {
            NSDictionary* lineString = [lineStringMember objectForKey:@"gml:LineString"];
            [polyline addPathToPolyline];
        
            NSString* coordinates = [lineString objectForKey:@"gml:coordinates"];
            NSArray* xyStringList = [coordinates componentsSeparatedByString:@" "];
            for (NSString* xyString in xyStringList)
            {
                NSArray* xyList = [xyString componentsSeparatedByString:@","];
                AGSPoint* point = [AGSPoint pointWithX:[[xyList objectAtIndex:0] doubleValue] y:[[xyList objectAtIndex:1] doubleValue] spatialReference:srs];
                [polyline addPointToPath:point];
            }
            
            return polyline;
        }
    }
    else if ([lineStringMemberNode isKindOfClass:[NSDictionary class]])     //有一个LineString
    {
        NSDictionary* lineString = [lineStringMemberNode objectForKey:@"gml:LineString"];
        return [self decodeGMLLineString:lineString];
    }
    
    return nil;
}

-(AGSGraphic*) decodeGMLFeatureMember:(NSDictionary*)gmlFeatureMember geometryFieldName:(NSString*)geometryFieldName
{
    NSArray* allkeys = [gmlFeatureMember allKeys];
    NSString* layerName = [allkeys objectAtIndex:1];
    NSDictionary* featureFields = [gmlFeatureMember objectForKey:layerName];
    
    NSMutableDictionary* attributes = [featureFields mutableCopy];
    [attributes setValue:layerName forKey:@"图层"];


    NSDictionary* geom = [featureFields objectForKey:geometryFieldName];
    NSArray* geomKeys = [geom allKeys];
    NSString* gmlType = [geomKeys objectAtIndex:1];
    
    if ([gmlType isEqualToString:@"gml:GML"])
    {
        geom = [geom objectForKey:gmlType];
        geomKeys = [geom allKeys];
        gmlType = [geomKeys objectAtIndex:2];
    }
    
    AGSGeometry* geometry = nil;
    if ([gmlType isEqualToString:@"gml:Point"])
    {
        geometry = [self decodeGMLPoint:[geom objectForKey:gmlType]];
    }
    else if([gmlType isEqualToString:@"gml:MultiLineString"])
    {
        geometry = [self decodeGMLMultiLineString:[geom objectForKey:gmlType]];
    }
    
    return [AGSGraphic graphicWithGeometry:geometry symbol:nil attributes:attributes];
}

@end

