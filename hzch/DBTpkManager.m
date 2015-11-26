//
//  DBTpkManager.m
//  hzch
//
//  Created by xtturing on 15/11/26.
//  Copyright © 2015年 xtturing. All rights reserved.
//

#import "DBTpkManager.h"

@implementation DBTpkManager

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
    NSString *desPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"]  stringByAppendingPathComponent:@"myTpk.db"];
    
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
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS TPK (ROW INTEGER PRIMARY KEY, tpkid TEXT,name TEXT,type TEXT,content TEXT,updatetime TEXT,news TEXT,tpkname TEXT,url TEXT );";
    BOOL bSucceed = [database executeUpdate:createSQL];
    if(!bSucceed)
    {
        NSLog(@"Failed to creating table. Error: %@",[database lastErrorMessage]);
        [self closeDatabase];
    }
}

-(void)dropTable
{
    NSString *createSQL = @"DROP TABLE IF EXISTS TPK";
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

-(void)insertTpk:(NBTpk *)theTpk{
    if(theTpk == NULL)
        return;
    NSString *update = @"INSERT OR REPLACE INTO TPK (tpkid,name,type,content,updatetime,news,tpkname,url) VALUES (?,?,?,?,?,?,?,?);";
    BOOL bSecceed = [database executeUpdate:update,theTpk.tpkid,theTpk.name,theTpk.type,theTpk.content,theTpk.updatetime,theTpk.news,theTpk.tpkname,theTpk.url];
    if (!bSecceed)
    {
        NSLog(@"DBTpk insertRecord Faild to update table. Error:%@",[database lastErrorMessage]);
    }
}
-(NSMutableArray *)getAllTpk{
    NSMutableArray * recordList = [NSMutableArray arrayWithCapacity:1];
    
    NSString *query = @"SELECT tpkid,name,type,content,updatetime,news,tpkname,url FROM TPK;";
    
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        NBTpk * record = [[NBTpk alloc]init];
        record.tpkid = [rs stringForColumn:@"tpkid"];
        record.name = [rs stringForColumn:@"name"];
        record.type = [rs stringForColumn:@"type"];
        record.content = [rs stringForColumn:@"content"];
        record.updatetime = [rs stringForColumn:@"updatetime"];
        record.news = [rs stringForColumn:@"news"];
        record.tpkname = [rs stringForColumn:@"tpkname"];
        record.url = [rs stringForColumn:@"url"];
        [recordList addObject:record];
    }
    
    [rs close];
    
    return recordList;
}
-(void)deleteTpk:(NSString *)url{
    NSString * query = @"DELETE FROM TPK WHERE url=\"";
    query = [query stringByAppendingString:[NSString stringWithFormat:@"%@",url]];
    query = [query stringByAppendingString:@"\""];
    BOOL bSucceed = [database executeUpdate:query];
    if(!bSucceed)
    {
        NSLog(@"DBPhoto deleteRecord Failed to update table. Error: %@",[database lastErrorMessage]);
    }
}
-(void)deleteTpks{
    NSString * query = @"DELETE FROM TPK";
    BOOL bSucceed = [database executeUpdate:query];
    if(!bSucceed)
    {
        NSLog(@"DBPhoto deleteRecord Failed to update table. Error: %@",[database lastErrorMessage]);
    }
}
- (void)updateTpk:(NBTpk *)theTpk{
    if(theTpk == NULL)
        return;
    NSString *update = @"update TPK set tpkid = ?,name = ?,type = ?,content = ?,updatetime = ?,news = ?,tpkname = ?  WHERE url =";
    update = [update stringByAppendingString:@"\""];
    update = [update stringByAppendingString:[NSString stringWithFormat:@"%@",theTpk.url]];
    update = [update stringByAppendingString:@"\""];
    BOOL bSucceed = [database executeUpdate:update,
                     theTpk.tpkid,theTpk.name,theTpk.type,theTpk.content,theTpk.updatetime,theTpk.news,theTpk.tpkname];
    
    if (!bSucceed)
    {
        NSLog(@"DBSchedule updateRecord Faild to update table. Error:%@",[database lastErrorMessage]);
    }
}
-(int)getCount{
    int nCount = 0;
    NSString *query = @"SELECT ROW FROM TPK ORDER BY ROW";
    FMResultSet *rs = [database executeQuery:query];
    while ([rs next])
    {
        nCount++;
    }
    
    [rs close];
    
    return nCount;
}
@end
