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

#define HTTP_LOAD_TPK          @"http://ditu.zj.cn:8081/LoadTPK/LoadTPK.asmx/LoadTpk"
#define HTTP_DEPARTMENT        @"http://ditu.zj.cn/catalog?parentid=1&catalogtheme=catalog_department&request=list&page=1&start=0&limit=1000"
#define HTTP_GOVMENT           @"http://ditu.zj.cn/catalog?parentid=2&catalogtheme=catalog_affairs&request=list&page=1&start=0&limit=20"
#define REQUEST_TYPE          @"requestType"

typedef enum {
    AALoadTPK = 0,
    AACatalogDepartment,
    //继续添加
    
}DataRequestType;


@class ASINetworkQueue;


//Delegate
@protocol dataHttpDelegate <NSObject>
@optional

- (void)didGetFailed;

- (void)didLoadTPK:(NSMutableDictionary *)Dic;

- (void)didGetCatalogDepartment:(NSArray *)departmentList;
//继续添加
@end


@interface dataHttpManager : NSObject

@property (nonatomic,retain) ASINetworkQueue *requestQueue;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,assign) int type;
@property (nonatomic,assign) id<dataHttpDelegate> delegate;
+(dataHttpManager*)getInstance;
- (id)initWithDelegate;

- (void)letLoadTPK;
- (void)letGetCatalogDepartment;


//继续添加
@end
