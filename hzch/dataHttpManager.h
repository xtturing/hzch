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

#define REQUEST_TYPE          @"requestType"

typedef enum {
    AALoadTPK = 0,
    //继续添加
    
}DataRequestType;


@class ASINetworkQueue;


//Delegate
@protocol dataHttpDelegate <NSObject>
@optional

- (void)didGetFailed;

- (void)didLoadTPK:(NSMutableDictionary *)Dic;
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


//继续添加
@end
