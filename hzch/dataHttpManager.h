//
//  dataHttpManager.h
//  房伴
//
//  Created by tao xu on 13-8-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "StringUtil.h"
#import "NSStringAdditions.h"
#import "DBDraws.h"
#import "NBRoute.h"
#import "DBCacheManager.h"
#import "DBCache.h"
#define HTTP_LOAD_TPK          @"http://ditu.zj.cn:8081/LoadTPK/LoadTPK.asmx/LoadTpk"

#define HTTP_DEPARTMENT        @"http://ditu.zj.cn/catalog?parentid=1&catalogtheme=catalog_department&request=list&page=1&start=0&limit=1000"
#define HTTP_GOVMENT           @"http://ditu.zj.cn/catalog?parentid=2&catalogtheme=catalog_affairs&request=list&page=1&start=0&limit=1000"

#define HTTP_DEPARTMENT_DETAIL @"http://ditu.zj.cn/catalog?parentid=%ld&catalogtheme=catalog_department&request=list&page=1&start=0&limit=1000"
#define HTTP_GOVMENT_DETAIL    @"http://ditu.zj.cn/catalog?parentid=%ld&catalogtheme=catalog_affairs&request=list&page=1&start=0&limit=1000"

#define HTTP_SEARCH            @"http://ditu.zj.cn/services/placesearch?withgeometry=true&searchtype=&page=%d&pagesize=%d&keywords=%@&city=&v=2&frontRequest=true&tableid=&minx=&maxx=&miny=&maxy="

#define HTTP_CATALOG_SEARCH    @"http://ditu.zj.cn/services/datasearch?withgeometry=false&searchtype=spatialdata&page=%d&pagesize=%d&keywords=%@&city=&v=2&frontRequest=true&tableid=%@&minx=&maxx=&miny=&maxy=&lk=false&geo=&_dc=1419474648386"

#define HTTP_DRAW_SEARCH       @"http://ditu.zj.cn/services/datasearch?withgeometry=false&searchtype=spatialdata&page=%d&pagesize=%d&keywords=&city=&v=2&frontRequest=true&tableid=%@&minx=%f&maxx=%f&miny=%f&maxy=%f&lk=false&geo=&_dc=1419474648386"
#define HTTP_THEMATIC          @"http://ditu.zj.cn/thematicDataMetadata?request=updatethematicdata&operationAction=lookup&tableName=%@"

#define HTTP_RANGE             @"http://ditu.zj.cn/services/divisionsearch?v=2&oid=330000-000-2120-%E6%B5%99%E6%B1%9F%E7%9C%81&geom=1000K"

#define HTTP_LINE_SEARCH       @"http://www.tianditu.com/query.shtml"

#define REQUEST_TYPE          @"requestType"

typedef enum {
    AALoadTPK = 0,
    AACatalogDepartment,
    AACatalogGovment,
    AACatalogDepartmentDetail,
    AACatalogGovmentDetail,
    AASearchText,
    AASearchCatalog,
    AASearchDraw,
    AAGetLineSearch,
    AAGetThematic,
    AAGetRange,
    //继续添加
    
}DataRequestType;


@class ASINetworkQueue;


//Delegate
@protocol dataHttpDelegate <NSObject>
@optional

- (void)didGetFailed;

- (void)didGetTableIDFailed;

- (void)didLoadTPK:(NSMutableDictionary *)Dic;

- (void)didGetCatalogDepartment:(NSArray *)departmentList;

- (void)didGetCatalogDepartmentDetail:(NSArray *)departmentDetailList;

- (void)didGetCatalogGovment:(NSArray *)govmentList;

- (void)didGetCatalogGovmentDetail:(NSArray *)govmentDetailList;

- (void)didGetSearch:(NSMutableDictionary *)searchDic;

- (void)didgetSearchCatalog:(NSMutableDictionary *)searchDic;

- (void)didgetSearchSqlite:(NSMutableDictionary *)searchDic;

- (void)didGetDraw:(NSMutableDictionary *)searchDic;

- (void)didGetRoute:(NBRoute *)route;

- (void)didGetThematic:(NSMutableDictionary *)thematicDic;

- (void)didGetRange:(NSMutableDictionary *)rangeDic;
//继续添加
@end


@interface dataHttpManager : NSObject

@property (nonatomic,strong) ASINetworkQueue *requestQueue;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) id<dataHttpDelegate> delegate;
@property (nonatomic,strong) DBDraws *drawDB;
@property (nonatomic,strong) DBCacheManager *cacheDB;
@property (nonatomic,strong) DBCache *cache;
@property (nonatomic,strong) NSMutableDictionary *resourceLayers;
@property (nonatomic,strong) NSArray *drawPoints;
@property (nonatomic,strong)AGSGraphicsLayer *drawGhLayer;
@property (nonatomic,strong) NSMutableArray *drawLayers;
@property (nonatomic,strong) NSMutableDictionary *sqliteLayers;
@property (nonatomic,strong) NSMutableArray *localLayers;
@property (nonatomic,strong) NSMutableDictionary *sqliteCalloutDic;
@property (nonatomic,strong) NSArray *cacheList;
@property (nonatomic) NSInteger tableID;
@property (nonatomic,strong) NSString *tableName;
@property (nonatomic,strong) NSDictionary *thematicDic;
@property (nonatomic,strong) NSDictionary *rangeDic;
+(dataHttpManager*)getInstance;
- (id)initWithDelegate;

- (void)letLoadTPK;
- (void)letGetCatalogDepartment;
- (void)letGetCatalogDepartmentDetail:(NSInteger)catalogID;
- (void)letGetCatalogGovment;
- (void)letGetCatalogGovmentDetail:(NSInteger)catalogID;
- (void)letGetSearch:(NSString *)searchText page:(int)page pageSize:(int)size;
- (void)letGetSearchCatalog:(NSString *)searchText page:(int)page pageSize:(int)size;
- (void)letGetSearchSqlite:(NSString *)searchText;
- (void)doTouchDrawSearchMinx:(double)minx miny:(double)miny maxx:(double)maxx maxy:(double)maxy page:(int)page pageSize:(int)size;
- (void)letGetLineSearch:(NSString *)start end:(NSString *)end;
- (void)letGetThematic;
- (void)letGetRange;
//继续添加
@end
