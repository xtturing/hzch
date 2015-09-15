//
//  NSConfigData.h
//  RapidReport_P
//
//  Created by hvit-pc on 14-3-20.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "FMDB.h"
#import "Reachability.h"

@interface NSConfigData : NSObject
@property (strong,nonatomic) Reachability *reachability;

-(NSMutableDictionary*)getUserDic;
-(NSString*)getUserPath;
-(BOOL)getUserRole:(NSString *)p_powerValue;
-(FMDatabase*)CreateMyDb;
-(FMDatabase*)getMyDb;
-(FMDatabaseQueue*)getMyDbQueue;
-(NSString*)getDbPath;
-(NSString *)getSubString:(NSString*)p_allStr Start:(NSString*)p_start End:(NSString*)p_end;
-(NSString*)getMediaPath:(NSString*) pModel info:(NSString*)pInfoId fileType:(NSString*)pFileType fileName:(NSString *)pFileName;
-(void)deleteMediaFile:(NSString*) pPath;
-(NSMutableArray*) judgeMediaFile:(NSString*) pModel info:(NSString*)pInfoId fileType:(NSString*)pFileType;
-(void)deleteMediaDir:(NSString*) pModel info:(NSString*)pInfoId;

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay;
-(NSString*)getWebServices;
-(UIImage *)addImageText:(UIImage *)p_img text:(NSString *)p_txt;
-(NSString*)jsonDateToDate:(NSString *)p_jsonDate;
-(NSString*)getLocationAddress:(double )lon Lat:(double )lat;

- (void)showAlert:(NSString *)String;
@end
