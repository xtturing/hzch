//
//  DBCacheManager.m
//  
//
//  Created by xtturing on 15/11/4.
//
//

#import "DBCacheManager.h"
#import "Utility.h"

@implementation DBCacheManager

-(id)init
{
    if (self = [super init])
    {
        [self openDatabase];
    }
    
    return (self);
}

- (void)dealloc
{
    [self closeDatabase];
    database = nil;
}

-(void)openDatabase
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"]  stringByAppendingPathComponent:@"myCache2.db"];
    
    database = [FMDatabase databaseWithPath:desPath];
    if ([database open])
    {
        [database setShouldCacheStatements:YES];
    }
    else
    {
        NSLog(@"Failed to open database.");
        [self closeDatabase];
    }
}

-(void)closeDatabase
{
    [database close];
}

-(void)createTable
{
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS CACHE (ROW INTEGER PRIMARY KEY, TYPEID INTEGER, MAXLEVEL INTEGER, MINLEVEL INTEGER,NAME TEXT,LAYERNAME TEXT,RANGE TEXT,RANGEBOX TEXT, ISSHOW INTEGER);";
    BOOL bSucceed = [database executeUpdate:createSQL];
    if(!bSucceed)
    {
        NSLog(@"Failed to creating table. Error: %@",[database lastErrorMessage]);
        [self closeDatabase];
    }
}

-(void)dropTable
{
    NSString *createSQL = @"DROP TABLE IF EXISTS CACHE";
    BOOL bSucceed = [database executeUpdate:createSQL];
    if(!bSucceed)
    {
        NSLog(@"Failed to creating table. Error: %@",[database lastErrorMessage]);
        [self closeDatabase];
    }
    
}

-(void)beginTransaction
{
    [database beginTransaction];
}

-(void)commit
{
    [database commit];
}

-(void)insertCache:(DBCache *)theCache{
    if(theCache == NULL)
        return;
    NSString *update = @"INSERT OR REPLACE INTO CACHE (TYPEID,MAXLEVEL,MINLEVEL,NAME,LAYERNAME,RANGE,RANGEBOX,ISSHOW) VALUES (?,?,?,?,?,?,?,?);";
    BOOL bSecceed = [database executeUpdate:update,[NSNumber numberWithLong:theCache.typeID],[NSNumber numberWithLong:theCache.maxLevel],[NSNumber numberWithLong:theCache.minLevel],theCache.name,theCache.layerName,theCache.range,theCache.rangeBox,[NSNumber numberWithLong:theCache.isShow]];
    if (!bSecceed)
    {
        NSLog(@"DBSchedule insertRecord Faild to update table. Error:%@",[database lastErrorMessage]);
    }
}

- (void)updateCache:(DBCache *)theCache{
    if(theCache == NULL)
        return;
    NSString *update = @"update CACHE set NAME = ?,MAXLEVEL = ?,MINLEVEL = ?,LAYERNAME = ? ,RANGE = ? ,RANGEBOX = ?,ISSHOW = ? WHERE TYPEID =";
    update = [update stringByAppendingString:@"\""];
    update = [update stringByAppendingString:[NSString stringWithFormat:@"%ld",theCache.typeID]];
    update = [update stringByAppendingString:@"\""];
    BOOL bSucceed = [database executeUpdate:update,
                     theCache.name,[NSNumber numberWithLong:theCache.maxLevel],[NSNumber numberWithLong:theCache.minLevel],theCache.layerName,theCache.range,theCache.rangeBox,[NSNumber numberWithLong:theCache.isShow]];
    
    if (!bSucceed)
    {
        NSLog(@"DBSchedule updateRecord Faild to update table. Error:%@",[database lastErrorMessage]);
    }
}

-(NSMutableArray *)getAllCache{
    NSMutableArray * recordList = [NSMutableArray arrayWithCapacity:1];
    
    NSString *query = @"SELECT TYPEID,MAXLEVEL,MINLEVEL,NAME,LAYERNAME,RANGE,RANGEBOX,ISSHOW FROM CACHE;";
    
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        DBCache * record = [[DBCache alloc]init];
        record.name = [rs stringForColumn:@"NAME"];
        record.layerName = [rs stringForColumn:@"LAYERNAME"];
        record.range = [rs stringForColumn:@"RANGE"];
        record.maxLevel = [rs longForColumn:@"MAXLEVEL"];
        record.minLevel = [rs longForColumn:@"MINLEVEL"];
        record.typeID = [rs longForColumn:@"TYPEID"];
        record.isShow = [rs boolForColumn:@"ISSHOW"];
        record.rangeBox = [rs stringForColumn:@"RANGEBOX"];
        [recordList addObject:record];
    }
    
    [rs close];
    
    return recordList;
}

-(void)deleteCache:(NSInteger)typeId{
    NSString * query = @"DELETE FROM CACHE WHERE TYPEID=\"";
    query = [query stringByAppendingString:[NSString stringWithFormat:@"%ld",typeId]];
    query = [query stringByAppendingString:@"\""];
    BOOL bSucceed = [database executeUpdate:query];
    if(!bSucceed)
    {
        NSLog(@"DBPhoto deleteRecord Failed to update table. Error: %@",[database lastErrorMessage]);
    }
}

-(void)deleteCaches{
    NSString * query = @"DELETE FROM CACHE";
    BOOL bSucceed = [database executeUpdate:query];
    if(!bSucceed)
    {
        NSLog(@"DBPhoto deleteRecord Failed to update table. Error: %@",[database lastErrorMessage]);
    }
}

-(int)getCount{
    int nCount = 0;
    NSString *query = @"SELECT ROW FROM CACHE ORDER BY ROW";
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        nCount++;
    }
    
    [rs close];
    
    return nCount;
}


@end
