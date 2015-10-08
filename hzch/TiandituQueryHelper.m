//
//  WFSHelper.m
//  ZJGIS-iPhone
//
//  Created by YULinfeng on 13-1-21.
//  Copyright (c) 2013年 tencent. All rights reserved.
//

#import "TiandituQueryHelper.h"
#import "WFS.h"
#import "XMLDictionary.h"

@implementation TiandituQueryHelper

+(void) requestTiandituQuery:(NSString*)uri queryString:(NSString*)queryString responder:(id)responder
{
    WFS* wfs = [WFS wfsWithGetFeature:nil version:nil namespaceList:nil];
    OGCParser* ogcParser = [OGCParser sharedInstance];
    // 分页  [wfs setPaging:200 maxFeatures:10];
    
    NSArray* queryConditions = [NSArray arrayWithObjects:[ogcParser encodeOGCSortBy:@"NAME"], 
                                [ogcParser encodeOGCFilter:[ogcParser encodeOGCPropertyIsLike:@"NAME" literal:[NSString stringWithFormat:@"*%@*",queryString]]],nil];
    
    [wfs addQuery:[wfs encodeWFSQuery:@"POIALL" queryCondition:queryConditions]];
    
    NSString* postData = [wfs.wfsData xmlString];
    
//    [responder POST:uri data:[postData dataUsingEncoding:NSUTF8StringEncoding]];
}

+(void) requestTiandituQueryWithPaging:(NSString*)uri layerName:(NSString*)layerName fieldName:(NSString*)fieldName queryString:(NSString*)queryString sortByFieldName:(NSString*)sortByFieldName responder:(id)responder startIndex:(NSInteger)startIndex maxFeatures:(NSInteger)maxFeatures
{
    WFS* wfs = [WFS wfsWithGetFeature:nil version:nil namespaceList:nil];
    OGCParser* ogcParser = [OGCParser sharedInstance];
    // 分页 
    [wfs setPaging:startIndex maxFeatures:maxFeatures];
    
    NSArray* queryConditions = [NSArray arrayWithObjects:[ogcParser encodeOGCSortBy:sortByFieldName], 
                                [ogcParser encodeOGCFilter:[ogcParser encodeOGCPropertyIsLike:fieldName literal:[NSString stringWithFormat:@"*%@*",queryString]]],nil];
    
    [wfs addQuery:[wfs encodeWFSQuery:layerName queryCondition:queryConditions]];
    
    NSString* postData = [wfs.wfsData xmlString];
    
//    [responder POST:uri data:[postData dataUsingEncoding:NSUTF8StringEncoding]];
}

+(void) requestTiandituZJQueryWithPaging:(NSString*)key pageIndex:(NSInteger)pageIndex pageStep:(NSInteger)pageStep responder:(id)responder
{
    NSString* urlString = [NSString stringWithFormat:@"http://www.zjditu.cn/tdtzj/ZJDituWebService/Service.asmx/QueryPOI?&taghead=a class=hlight&tagtail=a&type=&pageIndex=%d&pageStep=%d&key=%@&flds=&pac=",pageIndex,pageStep,key];
#ifdef DEBUG
    NSLog(@"%@",urlString);
#endif
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    [responder GET:urlString];
}

@end




