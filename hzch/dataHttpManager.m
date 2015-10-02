//
//  dataHttpManager.m
//  房伴
//
//  Created by tao xu on 13-8-12.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "dataHttpManager.h"
#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"
#import "XMLReader.h"
#import "NBTpk.h"
#import "NBSpatialData.h"
#import "DownloadItem.h"
#import "DownloadManager.h"
#import "NBDepartMent.h"
#import "NBGovment.h"
#import "NBSearch.h"

#define TIMEOUT 30

static dataHttpManager * instance=nil;

@implementation dataHttpManager

-(void)dealloc
{
    self.requestQueue = nil;
}
//单例
+(dataHttpManager*)getInstance{
    @synchronized(self) {
        if (instance==nil) {
            instance=[[dataHttpManager alloc] initWithDelegate];
            [instance start];
        }
    }
    return instance;
}
//初始化
- (id)initWithDelegate {
    self = [super init];
    if (self) {
        _requestQueue = [[ASINetworkQueue alloc] init];
        [_requestQueue setDelegate:self];
        [_requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [_requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        [_requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[_requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [_requestQueue setShowAccurateProgress:YES];
        
    }
    
    return self;
}
#pragma mark - Methods
- (void)setGetUserInfo:(ASIHTTPRequest *)request withRequestType:(DataRequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:REQUEST_TYPE];
    [request setUserInfo:dict];
}

- (void)setPostUserInfo:(ASIFormDataRequest *)request withRequestType:(DataRequestType)requestType {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInt:requestType] forKey:REQUEST_TYPE];
    [request setUserInfo:dict];
}

- (NSURL*)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
	if (params) {
		NSMutableArray* pairs = [NSMutableArray array];
		for (NSString* key in params.keyEnumerator) {
			NSString* value = [params objectForKey:key];
			NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
																						  kCFAllocatorDefault, /* allocator */
																						  (CFStringRef)value,
																						  NULL, /* charactersToLeaveUnescaped */
																						  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
																						  kCFStringEncodingUTF8));
            
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
		}
		
		NSString* query = [pairs componentsJoinedByString:@"&"];
		NSString* url = [NSString stringWithFormat:@"%@?%@", baseURL, query];
		return [NSURL URLWithString:url];
	} else {
		return [NSURL URLWithString:baseURL];
	}
}
#pragma mark - Http Operate
- (void)letLoadTPK{
    NSString *baseUrl =[NSString  stringWithFormat:@"%@",HTTP_LOAD_TPK];
    NSURL  *url = [NSURL URLWithString:baseUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIMEOUT];
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:AALoadTPK];
    [_requestQueue addOperation:request];
}

- (void)letGetCatalogDepartment{
    NSString *baseUrl =[NSString  stringWithFormat:@"%@",HTTP_DEPARTMENT];
    NSURL  *url = [NSURL URLWithString:baseUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIMEOUT];
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:AACatalogDepartment];
    [_requestQueue addOperation:request];
}

- (void)letGetCatalogDepartmentDetail:(NSInteger)catalogID{
    NSString *baseUrl =[NSString  stringWithFormat:HTTP_DEPARTMENT_DETAIL,catalogID];
    NSURL  *url = [NSURL URLWithString:baseUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIMEOUT];
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:AACatalogDepartmentDetail];
    [_requestQueue addOperation:request];
}

- (void)letGetCatalogGovment{
    NSString *baseUrl =[NSString  stringWithFormat:@"%@",HTTP_GOVMENT];
    NSURL  *url = [NSURL URLWithString:baseUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIMEOUT];
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:AACatalogGovment];
    [_requestQueue addOperation:request];
}

- (void)letGetCatalogGovmentDetail:(NSInteger)catalogID{
    NSString *baseUrl =[NSString  stringWithFormat:HTTP_DEPARTMENT_DETAIL,catalogID];
    NSURL  *url = [NSURL URLWithString:baseUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIMEOUT];
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:AACatalogGovmentDetail];
    [_requestQueue addOperation:request];
}

- (void)letGetSearch:(NSString *)searchText page:(int)page pageSize:(int)size{
    NSString *baseUrl =[NSString  stringWithFormat:HTTP_SEARCH,searchText,page,size];
    NSURL  *url = [NSURL URLWithString:baseUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setTimeOutSeconds:TIMEOUT];
    [request setResponseEncoding:NSUTF8StringEncoding];
    NSLog(@"url=%@",url);
    [self setGetUserInfo:request withRequestType:AASearchText];
    [_requestQueue addOperation:request];
}

//继续添加

#pragma mark - Operate queue
- (BOOL)isRunning
{
	return ![_requestQueue isSuspended];
}

- (void)start
{
	if( [_requestQueue isSuspended] )
		[_requestQueue go];
}

- (void)pause
{
	[_requestQueue setSuspended:YES];
}

- (void)resume
{
	[_requestQueue setSuspended:NO];
}

- (void)cancel
{
	[_requestQueue cancelAllOperations];
}
#pragma mark - ASINetworkQueueDelegate
//失败
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"请求失败:%@,%@,",request.responseString,[request.error localizedDescription]);
    if ([_delegate respondsToSelector:@selector(didGetFailed)]) {
        [_delegate didGetFailed];
    }
}

//成功
- (void)requestFinished:(ASIHTTPRequest *)request{
    NSDictionary *userInformation = [request userInfo];
    DataRequestType requestType = [[userInformation objectForKey:REQUEST_TYPE] intValue];
    NSString * responseString = [request responseString];
    AGSSBJsonParser *parser = [[AGSSBJsonParser alloc] init];    
    id  returnObject = [parser objectWithString:responseString];
    if(!returnObject && responseString){
        NSError *parseError = nil;
        returnObject= [XMLReader dictionaryForXMLString:responseString error:&parseError];
    }
    NSDictionary *userInfo = nil;
    NSArray *userArr = nil;
    if ([returnObject isKindOfClass:[NSDictionary class]]) {
        userInfo = (NSDictionary*)returnObject;
    }
    else if ([returnObject isKindOfClass:[NSArray class]]) {
        userArr = (NSArray*)returnObject;
    }
    
    if(requestType == AALoadTPK && userInfo){
        NSString * responseString = [[userInfo objectForKey:@"string"] objectForKey:@"text"];
        id  returnObject = [parser objectWithString:responseString];
        NSArray *tpklist = [[[returnObject objectForKey:@"all"] objectForKey:@"allTPK"] objectForKey:@"tpk"];
        NSArray *dataList = [[[returnObject objectForKey:@"all"] objectForKey:@"allSpatialData"] objectForKey:@"SpatialData"];
        NSMutableArray *tpkArr = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *tpkdic in tpklist){
            NBTpk *tpk = [[NBTpk alloc] initWithJsonDictionary:tpkdic];
            [tpkArr addObject:tpk];
        }
        for(NSDictionary *datadic in dataList){
            NBSpatialData *data = [[NBSpatialData alloc] initWithJsonDictionary:datadic];
            [dataArr addObject:data];
        }
        NSMutableDictionary  *resultDic = [NSMutableDictionary dictionaryWithCapacity:2];
        [resultDic setObject:tpkArr forKey:@"tpk"];
        [resultDic setObject:dataArr forKey:@"data"];
        if ([_delegate respondsToSelector:@selector(didLoadTPK:)]) {
            [_delegate didLoadTPK:resultDic];
        }
    }
    
    if(requestType == AACatalogDepartment && userInfo){
        NSArray *result = [userInfo objectForKey:@"result"];
        NSMutableArray *departArr = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dataDic in result){
            NBDepartMent *depart = [[NBDepartMent alloc] initWithJsonDictionary:dataDic];
            [departArr addObject:depart];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(didGetCatalogDepartment:)]) {
            [_delegate didGetCatalogDepartment:departArr];
        }
    }
    if(requestType == AACatalogDepartmentDetail && userInfo){
        NSArray *result = [userInfo objectForKey:@"parents"];
        NSMutableArray *departArr = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dataDic in result){
            NBDepartMent *depart = [[NBDepartMent alloc] initWithJsonDictionary:dataDic];
            [departArr addObject:depart];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(didGetCatalogDepartmentDetail:)]) {
            [_delegate didGetCatalogDepartmentDetail:departArr];
        }
    }
    if(requestType == AACatalogGovment && userInfo){
        NSArray *result = [userInfo objectForKey:@"results"];
        NSMutableArray *govtArr = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dataDic in result){
            NBGovment *gov = [[NBGovment alloc] initWithJsonDictionary:dataDic];
            [govtArr addObject:gov];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(didGetCatalogGovment:)]) {
            [_delegate didGetCatalogGovment:govtArr];
        }
    }
    if(requestType == AACatalogGovmentDetail && userInfo){
        NSArray *result = [userInfo objectForKey:@"parents"];
        NSMutableArray *govtArr = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dataDic in result){
            NBGovment *gov = [[NBGovment alloc] initWithJsonDictionary:dataDic];
            [govtArr addObject:gov];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(didGetCatalogGovmentDetail:)]) {
            [_delegate didGetCatalogGovmentDetail:govtArr];
        }
    }
    if(requestType == AASearchText && userInfo){
        NSArray *result = [userInfo objectForKey:@"results"];
        NSMutableArray *searchArr = [NSMutableArray arrayWithCapacity:0];
        for(NSDictionary *dataDic in result){
            NBSearch *search = [[NBSearch alloc] initWithJsonDictionary:dataDic];
            [searchArr addObject:search];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setObject:searchArr forKey:@"results"];
        [dic setObject:@([userInfo getIntValueForKey:@"totalCount" defaultValue:0]) forKey:@"totalCount"];
        [dic setObject:[userInfo getStringValueForKey:@"resulttype" defaultValue:@""] forKey:@"resulttype"];
        [dic setObject:@([userInfo getIntValueForKey:@"page" defaultValue:0]) forKey:@"page"];
        [dic setObject:@([userInfo getIntValueForKey:@"pagesize" defaultValue:0]) forKey:@"pagesize"];
        [dic setObject:[userInfo getStringValueForKey:@"city" defaultValue:@""] forKey:@"city"];
        [dic setObject:@([userInfo getIntValueForKey:@"tableid" defaultValue:0])  forKey:@"tableid"];
        if (_delegate && [_delegate respondsToSelector:@selector(didGetSearch:)]) {
            [_delegate didGetSearch:dic];
        }
    }
    //继续添加
    
}

//跳转
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL {
    NSLog(@"请求将要跳转");
}


@end
