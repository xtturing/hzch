//
//  FileManager.m
//  CoreDataTest
//
//  Created by  on 11/27/13.
//  Copyright (c) 2013 CocoaRush. All rights reserved.
//

#import "Utility.h"
#import <CommonCrypto/CommonDigest.h>
#import <sys/xattr.h>
@implementation Utility

SINGLETON(Utility);

+(NSString *)formatTimeByNumber:(float)time
{
    NSString *result=@"00:00";
    if(time>=3600)//hour
    {
        int hour= time/3600;
        int minute=(time-hour*3600)/60;
        int second=time-hour*3600-minute*60;
        
        NSString *hourString=[NSString stringWithFormat:@"%d",hour];
        if(hour<10)
        {
            hourString=[NSString stringWithFormat:@"0%d",hour];
        }
        
        NSString *minString=[NSString stringWithFormat:@"%d",minute];
        if(minute<10)
        {
            minString=[NSString stringWithFormat:@"0%d",minute];
        }
        
         NSString *secondString=[NSString stringWithFormat:@"%d",second];
        if(second<10)
        {
            secondString=[NSString stringWithFormat:@"0%d",second];
        }
        
       result=[NSString stringWithFormat:@"%@:%@:%@",hourString,minString,secondString];
    }
    else if(time<3600)
    {
      
        int minute=time/60;
        int second=time-minute*60;;
        NSString *minString=[NSString stringWithFormat:@"%d",minute];
        if(minute<10)
        {
            minString=[NSString stringWithFormat:@"0%d",minute];
        }

        NSString *secondString=[NSString stringWithFormat:@"%d",second];
        if(second<10)
        {
            secondString=[NSString stringWithFormat:@"0%d",second];
        }
        
        result=[NSString stringWithFormat:@"%@:%@",minString,secondString];
    }
    return result;
}

+(NSString *)transferNumberToString:(double)number
{
    NSString *result=@"";
//    if(number==0)
//    {
////        result=@"-";
//        result=@"0";
//    }
    //byte
    if(number<1024)
    {
        result=[NSString stringWithFormat:@"%0.1fB",number];
    }
    //kB
    else if(number<1024*1024)
    {
        result=[NSString stringWithFormat:@"%0.1fK",number/1024.0];
    }
    //MB
    else if(number<1024*1024*1024)
    {
        result=[NSString stringWithFormat:@"%0.1fM",number/1024.0/1024.0];
    }
    //GB
    else
    {
        result=[NSString stringWithFormat:@"%0.1fG",number/1024.0/1024.0/1024.0];
    }
    return result;
}

-(NSString *)applicationDocumentPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}

+(double)getFileSizeAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error=nil;
    NSDictionary *ret=[fileManager attributesOfItemAtPath:path error:&error];
    if(error)
    {
        NSLog(@"getFileSizeAtPath===============%@",error);
    }
    return [[ret objectForKey:NSFileSize] doubleValue];
}

-(BOOL)isExistFileAtPath:(NSString *)path
{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:path];
}

-(BOOL)removeFileAtPath:(NSString *)path
{
    NSError *error=nil;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path])
    {
        return NO;
    }
    BOOL result= [fileManager removeItemAtPath:path error:&error];
    if(error)
    {
        NSLog(@"移除文件失败：%@",error);
        result=NO;
    }
    return result;
}

-(NSString *) md5HexDigest :(NSString *)originString
{
    const char *str = [originString UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}

+ (NSString *)databaseDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    documentsDirectory = [documentsDirectory stringByAppendingPathComponent:@"database"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:documentsDirectory];
    if (!fileExists)
    {
        [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        [Utility addSkipBackupAttributeToItemAtPath:documentsDirectory];
    }
    
    return documentsDirectory;
}
+(BOOL)addSkipBackupAttributeToItemAtPath:(NSString *)path
{
    //NSLog(@"path is:----%@",path);
    NSComparisonResult order = [[UIDevice currentDevice].systemVersion compare:@"5.1" options:NSNumericSearch];
    //version>=5.1
    if (order == NSOrderedDescending||order == NSOrderedSame)
    {
        //assert([[NSFileManager defaultManager] fileExistsAtPath:path]);
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return FALSE;
        }
        NSError *error = nil;
        NSURL *URL = [NSURL fileURLWithPath:path];
        BOOL success = [URL setResourceValue:[NSNumber numberWithBool:YES]
                                      forKey:NSURLIsExcludedFromBackupKey
                                       error:&error];
        if (!success)
        {
            NSLog(@"Error excluding %@ from backup %@",[URL lastPathComponent],error);
        }
        return success;
    }
    else
    {
        const char* filePath = [path fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        
        NSLog(@"setxattr result = %d",result);
        
        return result == 0;
    }
    return FALSE;
}

@end
