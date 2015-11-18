//
//  NBSearchImageViewController.m
//  hzch
//
//  Created by xtturing on 15/10/18.
//  Copyright (c) 2015年 xtturing. All rights reserved.
//

#import "NBSearchImageViewController.h"
#import "SVProgressHUD.h"
#define HTTP_IMAGE  @"http://ditu.zj.cn/MEDIA/%ld/IMAGE/%@"

@interface NBSearchImageViewController ()

@end

@implementation NBSearchImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.title = @"返回";
    self.title = self.titleName;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self.imageUrl containsString:@";"]){
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            for (NSString *imageurl in [self.imageUrl componentsSeparatedByString:@";"]) {
                NSString* escaped_value = [imageurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSString *url = [NSString stringWithFormat:HTTP_IMAGE,(long)self.catalogID,escaped_value];
                NSLog(@"image url %@", url);
                NSData *Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                if(Data && Data.length > 0){
                    [array addObject:[UIImage imageWithData:Data]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if(array.count > 0){
                    self.imageView.animationImages = array;
                    self.imageView.animationDuration = 4.0f;
                    [self.imageView startAnimating];
                }else{
                    ALERT(@"无法获取到图片");
                }
            });
        }else{
            NSString* escaped_value = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                            kCFAllocatorDefault, /* allocator */
                                                                                                            (CFStringRef)self.imageUrl,
                                                                                                            NULL, /* charactersToLeaveUnescaped */
                                                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                            kCFStringEncodingUTF8));
            NSString *url = [NSString stringWithFormat:HTTP_IMAGE,(long)self.catalogID,escaped_value];
            NSLog(@"image url %@", url);
            NSData *Data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                if(Data && Data.length > 0){
                    self.imageView.image = [UIImage imageWithData:Data];
                }else{
                    ALERT(@"无法获取到图片");
                }
            });
            
        }
    });
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.imageView stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
