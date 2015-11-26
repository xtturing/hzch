//
//  DBSqliteManager.h
//  hzch
//
//  Created by xtturing on 15/11/26.
//  Copyright © 2015年 xtturing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "NBSpatialData.h"

@interface DBSqliteManager : NSObject{
    FMDatabase    * database;
}

-(void)openDatabase;
-(void)closeDatabase;
-(void)createTable;
-(void)dropTable;
-(void)beginTransaction;
-(void)commit;
-(void)insertSqlite:(NBSpatialData *)theSqlite;
-(NSMutableArray *)getAllSqlite;
-(void)deleteSqlite:(NSString *)url;
-(void)deleteSqlites;
- (void)updateSqlite:(NBSpatialData *)theSqlite;
-(int)getCount;

@end
