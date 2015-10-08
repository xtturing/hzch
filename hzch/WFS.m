//
//  WFSParser.m
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-8.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "WFS.h"
#import "XMLDictionary.h"

@implementation WFS

@synthesize version = _version;
@synthesize service = _service;
@synthesize xmlNamespaceList = _xmlNamespaceList;
@synthesize wfsData;

+(id) wfsWithGetFeature:(NSString*)service version:(NSString*)version namespaceList:(NSMutableDictionary*)namespaceList
{
    WFS* parser = [[WFS alloc] init];
    parser.version = version == nil ? @"1.0.0" : version;
    parser.service = service == nil ? @"WFS" : service;
    
    if (namespaceList == nil)
    {
        parser.xmlNamespaceList = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.zjgis.com",@"xmlns",
                                   @"http://www.opengis.net/wfs",@"xmlns:wfs", 
                                   @"http://www.opengis.net/ogc",@"xmlns:ogc",
                                   @"http://www.opengis.net/gml",@"xmlns:gml", nil];
    }
    else
    {
        parser.xmlNamespaceList = [namespaceList mutableCopy];
    }
    
    parser.wfsData = [NSMutableDictionary dictionary];
    [parser.wfsData setValue:@"wfs:GetFeature" forKey:@"__name"];
    [parser.wfsData setValue:parser.service forKey:@"_service"];
    [parser.wfsData setValue:parser.version forKey:@"_version"];
    for (NSString* key in parser.xmlNamespaceList)
    {
        [parser.wfsData setValue:[parser.xmlNamespaceList objectForKey:key] forKey:[NSString stringWithFormat:@"_%@",key]];
    }
    
    return parser;
}

+(id) wfsWithTransaction:(NSString*)service version:(NSString*)version namespaceList:(NSMutableDictionary*)namespaceList
{
    WFS* parser = [[WFS alloc] init];
    parser.version = version == nil ? @"1.0.0" : version;
    parser.service = service == nil ? @"WFS" : service;
    
    if (namespaceList == nil)
    {
        parser.xmlNamespaceList = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"www.zjgis.com",@"xmlns",
                                   @"http://www.opengis.net/wfs",@"xmlns:wfs", 
                                   @"http://www.opengis.net/ogc",@"xmlns:ogc",
                                   @"http://www.opengis.net/gml",@"xmlns:gml", nil];
    }
    else
    {
        parser.xmlNamespaceList = [namespaceList mutableCopy];
    }
    
    parser.wfsData = [NSMutableDictionary dictionary];
    [parser.wfsData setValue:@"wfs:Transaction" forKey:@"__name"];
    [parser.wfsData setValue:parser.service forKey:@"_service"];
    [parser.wfsData setValue:parser.version forKey:@"_version"];
    for (NSString* key in parser.xmlNamespaceList)
    {
        [parser.wfsData setValue:[parser.xmlNamespaceList objectForKey:key] forKey:[NSString stringWithFormat:@"_%@",key]];
    }
    
    return parser;
}

-(void) setPaging:(NSInteger)startIndex maxFeatures:(NSInteger)maxFeatures
{
    [self.wfsData setValue:[NSString stringWithFormat:@"%d",startIndex] forKey:@"_startIndex"];
    [self.wfsData setValue:[NSString stringWithFormat:@"%d",maxFeatures] forKey:@"_maxFeatures"];
}

-(void) addQuery:(NSDictionary*)wfsQuery
{
    id item = [self.wfsData objectForKey:@"wfs:Query"];
    if (item == nil)
        item = [self.wfsData objectForKey:@"Query"];
    
    NSMutableArray* queryList = item != nil ? item :  [NSMutableArray array];
    [queryList addObject:wfsQuery];
    
    [self.wfsData setValue:queryList forKey:@"wfs:Query"];
}

-(void) addInsert:(NSDictionary*)wfsInsert
{
    id item = [self.wfsData objectForKey:@"wfs:Insert"];
    if (item == nil)
        item = [self.wfsData objectForKey:@"Insert"];
    
    NSMutableArray* queryList = item != nil ? item :  [NSMutableArray array];
    [queryList addObject:wfsInsert];
    
    [self.wfsData setValue:queryList forKey:@"wfs:Insert"];
}

-(void) addUpdate:(NSDictionary*)wfsUpdate
{
    id item = [self.wfsData objectForKey:@"wfs:Update"];
    if (item == nil)
        item = [self.wfsData objectForKey:@"Update"];
    
    NSMutableArray* queryList = item != nil ? item :  [NSMutableArray array];
    [queryList addObject:wfsUpdate];
    
    [self.wfsData setValue:queryList forKey:@"wfs:Update"];
}

-(NSDictionary*) encodeWFSQuery:(NSString*)layerName ogcFilter:(NSDictionary*)ogcFilter;
{    
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"wfs:Query" forKey:@"__name"];
    [data setValue:layerName forKey:@"_typeName"];
    [data setValue:ogcFilter forKey:[ogcFilter objectForKey:@"__name"]];
    
    return data;
}

-(NSDictionary*) encodeWFSQuery:(NSString*)layerName queryCondition:(NSArray*)queryCondition
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"wfs:Query" forKey:@"__name"];
    [data setValue:layerName forKey:@"_typeName"];
    
    for (NSDictionary* condition in queryCondition)
    {
        [data setValue:condition forKey:[condition objectForKey:@"__name"]];
    }
    
    return data;
}

-(NSDictionary*) encodeWFSInsert:(NSString*)layerName geomFieldName:(NSString*)geomFieldName geometry:(NSDictionary*)geometry attributes:(NSDictionary*)attributes
{
    NSMutableDictionary* geom = [NSMutableDictionary dictionary];
    [geom setValue:geomFieldName forKey:@"__name"];
    [geom setValue:geometry forKey:[geometry objectForKey:@"__name"]];
    
    NSMutableDictionary* layer = [NSMutableDictionary dictionary];
    [layer setValue:layerName forKey:@"__name"];
    [layer setValue:geom forKey:geomFieldName];
    
    for (NSString* key in [attributes allKeys])
    {
        [layer setValue:[attributes objectForKey:key] forKey:key];
    }
    
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"wfs:Insert" forKey:@"__name"];
    [data setValue:layer forKey:layerName];
    
    return data;
}

-(NSDictionary*) encodeWFSInsert:(NSString*)layerName geomFieldName:(NSString*)geomFieldName graphic:(AGSGraphic*)graphic
{
    GMLParser* gmlParser = [GMLParser sharedInstance];
    NSDictionary* geometry = [gmlParser encodeGMLPoint:graphic.geometry.spatialReference point:(AGSPoint*)graphic.geometry];
    return [self encodeWFSInsert:layerName geomFieldName:geomFieldName geometry:geometry attributes:graphic.allAttributes];
}

-(NSDictionary*) encodeWFSUpdateAttributes:(NSString*)layerName filter:(NSDictionary*)filter attributes:(NSDictionary*)attributes
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"wfs:Update" forKey:@"__name"];
    [data setValue:layerName forKey:@"_typeName"];
    
    NSMutableArray* propertyList = [NSMutableArray array];
    for (NSString* key in [attributes allKeys])
    {
        NSDictionary* property = [self encodeWFSProperty:key value:[attributes objectForKey:key]];
        [propertyList addObject:property];  
    }
     [data setValue:propertyList forKey:@"wfs:Property"];
    
    [data setValue:filter forKey:[filter objectForKey:@"__name"]];
    
    return data;
}

-(NSDictionary*) encodeWFSProperty:(NSString*)name value:(NSString*)value
{
    NSMutableDictionary* data = [NSMutableDictionary dictionary];
    [data setValue:@"wfs:Property" forKey:@"__name"];
    
    [data setValue:name forKey:@"wfs:Name"];
    [data setValue:value forKey:@"wfs:Value"];
    
    return data;
}

-(NSDictionary*) encodeWFSIdentify:(NSString*)layerName geomFieldName:(NSString*)geomFieldName polygon:(AGSPolygon*)polygon
{
    GMLParser* gmlParser = [GMLParser sharedInstance];
    OGCParser* ogcParser = [OGCParser sharedInstance];
    
    NSDictionary* polygonNode = [gmlParser encodeGMLPolygon:polygon.spatialReference polygon:polygon];    
    NSDictionary* filter = [ogcParser encodeOGCFilter:[ogcParser encodeOGCIntersects:@"geom" gmlGeometry:polygonNode]];
    NSDictionary* query = [self encodeWFSQuery:layerName ogcFilter:filter];
    
    return query;
}

+(NSArray*) decodeQueryResultWithString:(NSString*)responseString geometryFieldName:(NSString*)geometryFieldName
{
    NSDictionary* result = [NSDictionary dictionaryWithXMLString:responseString];
    id featureMember = [result objectForKey:@"gml:featureMember"];
    if (featureMember == nil)
    {
        return nil;
    }
    
    GMLParser* gmlParser = [GMLParser sharedInstance];
    if ([featureMember isKindOfClass:[NSDictionary class]]) //一个结果
    {
        AGSGraphic* graphic = [gmlParser decodeGMLFeatureMember:featureMember geometryFieldName:geometryFieldName];
        return [NSArray arrayWithObjects:graphic, nil];
    }
    else if ([featureMember isKindOfClass:[NSArray class]]) //多个结果
    {
        NSMutableArray* graphicList = [NSMutableArray array];
        for (NSDictionary* item in featureMember) 
        {
            AGSGraphic* graphic = [gmlParser decodeGMLFeatureMember:item geometryFieldName:geometryFieldName];
            [graphicList addObject:graphic];
        }
        return graphicList;
    }
    
    return nil;
}

@end
