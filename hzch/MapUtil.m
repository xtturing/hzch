//
//  MapUtil.m
//  ZjGIS
//
//  Created by 林峰 余 on 12-8-6.
//  Copyright (c) 2012年 zjgis. All rights reserved.
//

#import "MapUtil.h"

@implementation MapUtil

+(BOOL) isSameEnvelope:(AGSEnvelope*)envelopeA andEnvelope:(AGSEnvelope*)envelopeB
{
    if (envelopeA.xmax == envelopeB.xmax 
     && envelopeA.xmin == envelopeB.xmin
     && envelopeA.ymax == envelopeB.ymax
     && envelopeA.ymin == envelopeB.ymin)
    {
        return YES;
    }
    else 
    {
        return NO;
    }
}

+ (id)getMapLayerByName:(NSString*)layerName mapView:(AGSMapView*)mapView
{
    NSArray* mapLayers = [mapView mapLayers];
    for (AGSLayer* mapLayer in mapLayers)
    {
        if ([[mapLayer name] isEqualToString:layerName])
        {
            return mapLayer;
        }
    }
    
    return nil;
}

+ (BOOL)hasLayerName:(NSString *)name  mapView:(AGSMapView*)mapView{
    NSArray* mapLayers = [mapView mapLayers];
    for (AGSLayer* mapLayer in mapLayers)
    {
        if([mapLayer.name isEqualToString:name]){
            return YES;
        }
    }
    return NO;
}

+ (void) clearMapLayers:(AGSMapView*)mapView
{
    NSArray* mapLayers = [mapView mapLayers];
    for (AGSLayer* layer in mapLayers)
    {
        [mapView removeMapLayerWithName:[layer name]];
    }
}

+ (NSMutableArray*)queryGraphicsByAttributes:(NSMutableArray*)graphicList conditionList:(NSMutableArray*)conditionList
{
    NSMutableArray* queryResult = [NSMutableArray array];
    
    if ([conditionList count] <= 0)
    {
        return graphicList;
    }
    
    for (NSDictionary* item in conditionList)
    {
        NSString* field = [item objectForKey:@"field"];
        NSString* value = [item objectForKey:@"value"];
        
        for (AGSGraphic* graphic in graphicList)
        {
            NSDictionary* attributes = graphic.allAttributes;
            if([[attributes allKeys] containsObject:field])
            {
                if([[attributes objectForKey:field] isEqualToString:value])
                {
                    if (![queryResult containsObject:graphic]) 
                    {
                        [queryResult addObject:graphic];
                    }
                }
            }
        }
    }
    
    return queryResult;
}

+ (NSMutableArray*)queryGraphicsBySpatial:(NSMutableArray*)graphicList geometry:(AGSGeometry*)geometry
{
    NSMutableArray* queryResult = [NSMutableArray array];
    for (AGSGraphic* graphic in graphicList)
    {
        AGSGeometry* graGeom = graphic.geometry;
        if([geometry intersectsWithEnvelope:graGeom.envelope])
        {
            if (![queryResult containsObject:graphic]) 
            {
                [queryResult addObject:graphic];
            }
        }
    }
    
    return queryResult;
}

@end
