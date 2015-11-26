//
//  DBSqliteManager.m
//  hzch
//
//  Created by xtturing on 15/11/26.
//  Copyright © 2015年 xtturing. All rights reserved.
//

#import "DBSqliteManager.h"

@implementation DBSqliteManager

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

-(void)openDatabase{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"]  stringByAppendingPathComponent:@"mySqlite.db"];
    
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
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS SQLITE (ROW INTEGER PRIMARY KEY, name TEXT,note TEXT,updatetime TEXT,news TEXT,url TEXT);";
    BOOL bSucceed = [database executeUpdate:createSQL];
    if(!bSucceed)
    {
        NSLog(@"Failed to creating table. Error: %@",[database lastErrorMessage]);
        [self closeDatabase];
    }
}

-(void)dropTable
{
    NSString *createSQL = @"DROP TABLE IF EXISTS SQLITE";
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

-(void)insertSqlite:(NBSpatialData *)theSqlite{
    if(theSqlite == NULL)
        return;
    NSString *update = @"INSERT OR REPLACE INTO SQLITE (name,note,updatetime,news,url) VALUES (?,?,?,?,?);";
    BOOL bSecceed = [database executeUpdate:update,theSqlite.name,theSqlite.note,theSqlite.updatetime,theSqlite.news,theSqlite.url];
    if (!bSecceed)
    {
        NSLog(@"DBSQLITE insertRecord Faild to update table. Error:%@",[database lastErrorMessage]);
    }
}
-(NSMutableArray *)getAllSqlite{
    NSMutableArray * recordList = [NSMutableArray arrayWithCapacity:1];
    
    NSString *query = @"SELECT name,note,updatetime,news,url FROM SQLITE;";
    
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        NBSpatialData * record = [[NBSpatialData alloc]init];
        record.name = [rs stringForColumn:@"name"];
        record.note = [rs stringForColumn:@"note"];
        record.updatetime = [rs stringForColumn:@"updatetime"];
        record.news = [rs stringForColumn:@"news"];
        record.url = [rs stringForColumn:@"url"];
        [recordList addObject:record];
    }
    
    [rs close];
    
    return recordList;
}
-(void)deleteSqlite:(NSString *)url{
    NSString * query = @"DELETE FROM SQLITE WHERE url=\"";
    query = [query stringByAppendingString:[NSString stringWithFormat:@"%@",url]];
    query = [query stringByAppendingString:@"\""];
    BOOL bSucceed = [database executeUpdate:query];
    if(!bSucceed)
    {
        NSLog(@"DBPhoto deleteRecord Failed to update table. Error: %@",[database lastErrorMessage]);
    }
}
-(void)deleteSqlites{
    NSString * query = @"DELETE FROM SQLITE";
    BOOL bSucceed = [database executeUpdate:query];
    if(!bSucceed)
    {
        NSLog(@"DBPhoto deleteRecord Failed to update table. Error: %@",[database lastErrorMessage]);
    }
}
- (void)updateSqlite:(NBSpatialData *)theSqlite{
    if(theSqlite == NULL)
        return;
    NSString *update = @"update SQLITE set name = ?,note = ?,updatetime = ?,news = ?  WHERE url =";
    update = [update stringByAppendingString:@"\""];
    update = [update stringByAppendingString:[NSString stringWithFormat:@"%@",theSqlite.url]];
    update = [update stringByAppendingString:@"\""];
    BOOL bSucceed = [database executeUpdate:update,theSqlite.name,theSqlite.note,theSqlite.updatetime,theSqlite.news];
    
    if (!bSucceed)
    {
        NSLog(@"DBSchedule updateRecord Faild to update table. Error:%@",[database lastErrorMessage]);
    }
}
-(int)getCount{
    int nCount = 0;
    NSString *query = @"SELECT ROW FROM SQLITE ORDER BY ROW";
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        nCount++;
    }
    
    [rs close];
    
    return nCount;
}

@end
