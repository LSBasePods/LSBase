//
//  ViewController.m
//  LSBase
//
//  Created by Terry Zhang on 15/12/4.
//  Copyright © 2015年 BasePod. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import "NSObject+LSModel.h"
#import "UIView+LS.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //**** Model from Json
    Book *book1 = [Book modelWithJSON:@"{\"name\": \"Harry Potter\",\"read\": 1, \"pages\": 256, \"user\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" }}" discrepantKeys:@{@"hasRead":@"read"}];
    NSLog(@"book1's user name : %@", book1.user.name);
    
    //**** Model from Other Object
    Book *book = [Book new];
    book.name = @"nihao";
    book.pages = @110;
    book.user = [User new];
    book.user.name = @"user";
    book.user.birthday = @"1992";
    Book *book2 = [Book modelWithOtherObject:book];
    NSLog(@"book2's user name : %@", book2.user.name);
    
    //**** Model key Archiever
    NSData *book1Data = [NSKeyedArchiver archivedDataWithRootObject:book1];
    Book *book3 = [NSKeyedUnarchiver unarchiveObjectWithData:book1Data];
    NSLog(@"book3's user name : %@", book3.user.name);
    
    //**** Model with Array Property from JSON
    NSString *model4Json = @"{\"name\": \"Harry Potter\",\"read\": 1, \"pages\": 256, \"user\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" },\"userList\":[{\"name\": \"Zhang San\", \"birthday\": \"1965-07-31\" },{\"name\": \"Lee Si\", \"birthday\": \"1965-07-31\" }]}";
    Book *book4 = [Book modelWithJSON:model4Json];
    NSLog(@"book4's userList:%@",book4.userList);
    
    //**** View Mapping
    UIView *view = [UIView new];
    [view configViewFromData:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
