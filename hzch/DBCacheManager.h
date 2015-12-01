//
//  DBCacheManager.h
//  
//
//  Created by xtturing on 15/11/4.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DBCache.h"
@interface DBCacheManager : NSObject{
    FMDatabase    * database;
}

-(void)openDatabase;
-(void)closeDatabase;
-(void)createTable;
-(void)dropTable;
-(void)beginTransaction;
-(void)commit;
-(void)insertCache:(DBCache *)theCache;
-(NSMutableArray *)getAllCache;
-(void)deleteCache:(long)createdate;
-(void)deleteCaches;
- (void)updateCache:(DBCache *)theCache;
-(int)getCount;


@end
