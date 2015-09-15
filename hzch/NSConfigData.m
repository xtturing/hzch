//
//  NSConfigData.m
//  RapidReport_P
//
//  Created by hvit-pc on 14-3-20.
//  Copyright (c) 2014年 hvit-pc. All rights reserved.
//
#define BaiDu_Location @"http://api.map.baidu.com/geocoder/v2/?coordtype=wgs84ll&ak=QleFqxAthzzZOoIXTFGb8Q4C&callback=renderReverse&location=%@,%@&output=json&pois=0"
#import "NSConfigData.h"
#import "NSConvert.h"

@implementation NSConfigData

//获得user沙箱数据
-(NSDictionary*)getUserDic{
    
    NSConvert *nsConvert = [[NSConvert alloc]init];
    
    //读文件
    NSDictionary *userPlist = [nsConvert NsDataToNSDictionary:[NSData dataWithContentsOfFile:[self getUserPath]]];
    if(userPlist == nil)
    {
        // 创建一个plist文件
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:[self getUserPath] contents:nil attributes:nil];
        
    }
    
    return userPlist;
}

//获得user沙箱用户路径
-(NSString*)getUserPath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    
    NSString *userPlistPath=[path stringByAppendingPathComponent:@"user.plist"];
    
    return userPlistPath;
}

-(void)deleteMediaFile:(NSString*) pPath{
    //建立文件操作对象
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSError *err;
    [fileManage removeItemAtPath:pPath error:&err];
}

-(void)deleteMediaDir:(NSString*) pModel info:(NSString*)pInfoId{
    //建立文件操作对象
    NSFileManager *fileManage = [NSFileManager defaultManager];
    //获取到Documents的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //拿到Documents的路径
    NSString *documentsDirectory = [paths objectAtIndex:0];

    //文件命名为file
    NSString *fileDir = [documentsDirectory stringByAppendingPathComponent:@"file"];
    
    if ([fileManage fileExistsAtPath:fileDir]) {
        //采集分类
        NSString *modelDir = [fileDir stringByAppendingPathComponent:pModel];
        if ([fileManage fileExistsAtPath:modelDir]) {
            
            //采集信息
            NSString *infoIdDir = [modelDir stringByAppendingPathComponent:pInfoId];
            if ([fileManage fileExistsAtPath:infoIdDir]) {
                [fileManage removeItemAtPath:infoIdDir error:nil];
            }
        }
    }
    
}

//判断是否存在本地多媒体
-(NSMutableArray*) judgeMediaFile:(NSString*) pModel info:(NSString*)pInfoId fileType:(NSString*)pFileType

{
    
    //建立文件操作对象
    NSFileManager *fileManage = [NSFileManager defaultManager];
    //获取到Documents的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //拿到Documents的路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //文件命名为file
    NSString *fileDir = [documentsDirectory stringByAppendingPathComponent:@"file"];
    
    if ([fileManage fileExistsAtPath:fileDir]) {
        //采集分类
        NSString *modelDir = [fileDir stringByAppendingPathComponent:pModel];
        if ([fileManage fileExistsAtPath:modelDir]) {
            
            //采集信息
            NSString *infoIdDir = [modelDir stringByAppendingPathComponent:pInfoId];
            if ([fileManage fileExistsAtPath:infoIdDir]) {
                //采集信息的多媒体
                NSString *mediaDir = [infoIdDir stringByAppendingPathComponent:pFileType];
                if ([fileManage fileExistsAtPath:mediaDir]) {
                    //创建文件夹
                   NSArray *tFileNameArr = [fileManage subpathsAtPath:mediaDir];
                    NSMutableArray *tFilePathArr = [[NSMutableArray alloc]init];
                    
                    for (NSString *tFileName in tFileNameArr) {
                        [tFilePathArr addObject:  [mediaDir stringByAppendingPathComponent:tFileName]];
                    }
                    return tFilePathArr;
                }else{
                
                    return nil;
                }
               
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

//获得相关的多媒体文件路径
-(NSString*)getMediaPath:(NSString*) pModel info:(NSString*)pInfoId fileType:(NSString*)pFileType fileName:(NSString *)pFileName{
    //建立文件操作对象
    NSFileManager *fileManage = [NSFileManager defaultManager];
    //获取到Documents的目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //拿到Documents的路径
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //文件命名为file
    NSString *fileDir = [documentsDirectory stringByAppendingPathComponent:@"file"];
    if (![fileManage fileExistsAtPath:fileDir]) {
        //创建文件夹
        [fileManage createDirectoryAtPath:fileDir attributes:nil];
    }
    
    //采集分类
    NSString *modelDir = [fileDir stringByAppendingPathComponent:pModel];
    if (![fileManage fileExistsAtPath:modelDir]) {
        //创建文件夹
        [fileManage createDirectoryAtPath:modelDir attributes:nil];
    }
    
    //采集信息
    NSString *infoIdDir = [modelDir stringByAppendingPathComponent:pInfoId];
    if (![fileManage fileExistsAtPath:infoIdDir]) {
        //创建文件夹
        [fileManage createDirectoryAtPath:infoIdDir attributes:nil];
    }
    
    //采集信息的多媒体
    NSString *mediaDir = [infoIdDir stringByAppendingPathComponent:pFileType];
    if (![fileManage fileExistsAtPath:mediaDir]) {
        //创建文件夹
        [fileManage createDirectoryAtPath:mediaDir attributes:nil];
    }
    
    //采集信息的图片
    NSString *filePath = [mediaDir stringByAppendingPathComponent:pFileName];
    return filePath;
}

-(BOOL)getUserRole:(NSString *)p_powerValue{
    BOOL t_reulst = NO;
    NSDictionary *t_userDic = [self getUserDic];
    NSArray *t_userRoles = [t_userDic objectForKey:@"TabRoles"];
    if (t_userRoles !=nil) {
        for (NSInteger i=0; i<t_userRoles.count; i++) {
            NSArray *t_userMenus = [t_userRoles[i] objectForKey:@"TabMenus"];
            for (NSInteger j=0; j<t_userMenus.count; j++) {
                NSString *t_powerValue = [t_userMenus[j] objectForKey:@"Powervalue"];
                if (t_powerValue != [NSNull null]) {
                    
                    if ([t_powerValue isEqualToString:p_powerValue]) {
                        t_reulst = YES;
                        break;
                    }else{
                        t_reulst = NO;
                    }
                }
            }
        }
    }
    
    return t_reulst;
}

-(FMDatabase*)getMyDb{
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDbPath]] ;
    return db;
}

-(FMDatabaseQueue*)getMyDbQueue{
    FMDatabaseQueue *Queue = [FMDatabaseQueue databaseQueueWithPath:[self getDbPath]]; ;
    return Queue;
}

//获得本地数据库
-(FMDatabase*)CreateMyDb{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[self getDbPath]] ;
    
    if ([db open]) {
        
        if(![db tableExists:@"Tab_TianDiTuOffLine"])
        {
            [db executeUpdate:@"CREATE TABLE Tab_TianDiTuOffLine (T VARCHAR(10),X INTEGER,Y INTEGER,L INTEGER,Tiels BLOB)"];
        }
        if (![db tableExists:@"Tab_Catalog"]){
            [db executeUpdate:@"CREATE TABLE Tab_Catalog (Id VARCHAR(40),OTime VARCHAR(40),EpiLat DOUBLE,EpiLon DOUBLE,M DOUBLE,LocationName VARCHAR(100))"];
        }
        if (![db tableExists:@"Tab_Proinformation"]) {
            [db executeUpdate:@"CREATE TABLE Tab_Proinformation (InfoId VARCHAR(40),EarthId VARCHAR(40),Name VARCHAR(20),UserId INTEGER,Longitude VARCHAR(20),Latitude VARCHAR(20),Address VARCHAR(100),SIntensity VARCHAR(20), PIntensity VARCHAR(20),SDescription  VARCHAR(255),PDescription VARCHAR(255),Date TEXT,Time TEXT,SaveType INTEGER)"];
        }
        if (![db tableExists:@"Tab_MacInformation"]) {
            [db executeUpdate:@"CREATE TABLE Tab_MacInformation (InfoId VARCHAR(40),Name VARCHAR(20),UserId INTEGER,Department VARCHAR(20),Longitude VARCHAR(20),Latitude VARCHAR(20),Address VARCHAR(100),Description VARCHAR(255),Date TEXT,Time text,SaveType INTEGER)"];
        }
        
        [db close];
    }
    
    return db;
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    
    promptAlert =NULL;
}


- (void)showAlert:(NSString *)p_title

{
    
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:p_title delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:NO];
    
    [promptAlert show];
}


- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

//获得user沙箱用户路径
-(NSString*)getLocationAddress:(double )lon Lat:(double )lat{
    
    NSString *locationAddress;
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://api.map.baidu.com/geocoder/v2/?coordtype=wgs84ll&ak=QleFqxAthzzZOoIXTFGb8Q4C&callback=renderReverse&location=%@,%@&output=json&pois=0",[NSString stringWithFormat:@"%.3f", lat],[NSString stringWithFormat:@"%.3f", lon]]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    self.reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([self.reachability currentReachabilityStatus]) {
        case NotReachable:
            locationAddress = @"网络无法识别";
            
            break;
        case ReachableViaWWAN:
        case ReachableViaWiFi:
            [request setURL:url];
            [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
            [request setTimeoutInterval: 60];
            [request setHTTPShouldHandleCookies:FALSE];
            [request setHTTPMethod:@"GET"];
            
            NSHTTPURLResponse *response;
            NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                                       returningResponse:&response error:nil];
            NSError *error;
            
            NSString *jsonString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            
            
            jsonString= [self getSubString:jsonString Start:@"(" End:@")"];
            
            NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *returnDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            
            if ([[returnDic objectForKey:@"status"] intValue] == 0) {
                NSDictionary *resultDic = [returnDic objectForKey:@"result"];
                locationAddress = [resultDic objectForKey:@"formatted_address"];
            }else{
                locationAddress = nil;
            }
            break;
    }
    
    
    
    return locationAddress;
}

//截取字符串
-(NSString *)getSubString:(NSString*)p_allStr Start:(NSString*)p_start End:(NSString*)p_end{
    NSRange range2 = [p_allStr rangeOfString:p_start];
    int location2 = range2.location;
    NSRange range3 = [p_allStr rangeOfString:p_end];
    int location3 = range3.location;
    
    p_allStr= [p_allStr substringWithRange:NSMakeRange(location2+1, location3-location2-1)];
    
    return p_allStr;
}

//获得本地数据库路径
-(NSString*)getDbPath{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths    objectAtIndex:0];
    
    NSString *dbPath=[path stringByAppendingPathComponent:@"myDb.db"];
    
    return dbPath;
}

//获得webServicesUrl
-(NSString*)getWebServices
{
    //获取WebServices Url
    NSString *initPath = [[NSBundle mainBundle] pathForResource:@"all" ofType:@"plist"];
    NSDictionary *t_init = [[NSMutableDictionary alloc] initWithContentsOfFile:initPath ];
    NSString *webServicesUrl = [t_init objectForKey:@"WebServicesUrl"];
    return webServicesUrl;
}


//秒制时间转换标准时间
-(NSString*)jsonDateToDate:(NSString *)p_jsonDate{
    NSString *string2 = @"(";
    NSString *string3 = @"+";
    NSRange range2 = [p_jsonDate rangeOfString:string2];
    int location2 = range2.location;
    NSRange range3 = [p_jsonDate rangeOfString:string3];
    int location3 = range3.location;
    
    NSString *time = [p_jsonDate substringWithRange:NSMakeRange(location2+1, location3-location2-1)];
    NSDate *date70 = [NSDate dateWithTimeIntervalSince1970:([time doubleValue] / 1000) ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date70];
    
    return destDateString;
}





-(UIImage *)addImageText:(UIImage *)p_img text:(NSString *)p_txt
{
    //get image width and height
    int w = p_img.size.width;
    int h = p_img.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //create a graphic context with CGBitmapContextCreate
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), p_img.CGImage);
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    char* text = (char *)[p_txt cStringUsingEncoding:NSASCIIStringEncoding];
    CGContextSelectFont(context, "Arial", 10, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    
    CGContextSetTextMatrix(context, CGAffineTransformMakeRotation( 0 ));
    
    CGContextShowTextAtPoint(context, w/4, h/3, text, strlen(text));
    
    
    //Create image ref from the context
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage* tImage = [UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);
    return tImage; 
    
}

@end
