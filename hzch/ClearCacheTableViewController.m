//
//  ClearCacheTableViewController.m
//  hzch
//
//  Created by xtturing on 15/11/2.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "ClearCacheTableViewController.h"
#import "dataHttpManager.h"
#import "SVProgressHUD.h"
@interface ClearCacheTableViewController (){
    BOOL selectTpk;
    BOOL selectSqlite;
    BOOL selectMyDraw;
}

@end

@implementation ClearCacheTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selectTpk = YES;
    selectSqlite = YES;
    selectMyDraw = YES;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doDelete:(id)sender{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确认清除数据？", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"取消", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    alert.tag = 70008;
    [alert show];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if(indexPath.row == 0){
            if(selectTpk){
                selectTpk = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                selectTpk = YES;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        if(indexPath.row == 1){
            if(selectSqlite){
                selectSqlite = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                selectSqlite = YES;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
        if(indexPath.row == 2){
            if(selectMyDraw){
                selectMyDraw = NO;
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else{
                selectMyDraw = YES;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 70008 && buttonIndex == 1){
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if(selectTpk){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEAR_TPK_SQLITE" object:nil];
                NSString *extension = @"tpk";
                NSString *extension1 = @"sqlite";
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory=[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
                NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
                NSEnumerator *e = [contents objectEnumerator];
                NSString *filename;
                while ((filename = [e nextObject])) {
                    if ([[filename pathExtension] isEqualToString:extension] || [[filename pathExtension] isEqualToString:extension1]) {
                        [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
                    }
                }
                NSString *dbPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"] stringByAppendingPathComponent:@"download.db"];
                if([fileManager fileExistsAtPath:dbPath]){
                    [fileManager removeItemAtPath:dbPath error:NULL];
                }
            }
            
            if(selectSqlite){
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSFileManager *fileManage = [NSFileManager defaultManager];
                NSString *mapDir = [documentsDirectory stringByAppendingPathComponent:@"map"];
                if ([fileManage fileExistsAtPath:mapDir]) {
                    [fileManage removeItemAtPath:mapDir error:NULL];
                }
            }
            
            if(selectMyDraw){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CLEAR_MYDRAW" object:nil];
                NSFileManager *fileManager = [NSFileManager defaultManager];
                NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
                NSString *dbPath=[[[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"]  stringByAppendingPathComponent:@"mydraws.db"];
                if([fileManager fileExistsAtPath:dbPath]){
                    [fileManager removeItemAtPath:dbPath error:NULL];
                    [[dataHttpManager getInstance].drawDB closeDatabase];
                    [dataHttpManager getInstance].drawDB = nil;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
    }
}
@end
