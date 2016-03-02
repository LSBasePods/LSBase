//
//  ViewController.m
//  LSBase
//
//  Created by Terry Zhang on 15/12/4.
//  Copyright © 2015年 BasePod. All rights reserved.
//

#import "ViewController.h"
#import "Book.h"
#import "LSBase.h"
#import "LSUDIDGenerator.h"
#import "PropertyTypeTestObj.h"
#import "YYClassInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];

    Book *book1 = [Book modelWithJSON:@"{\"name\": \"Harry Potter\",\"read\": 1, \"pages\": 256, \"user\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" }}"];
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
    
    // 父类属性
    EnglishBook *englishBook = [EnglishBook new];
    englishBook.name =@"111";
    englishBook.englishName = @"one one one";
    EnglishBook *english2 = [EnglishBook modelWithOtherObject:englishBook];
    NSLog(@"name:%@ englishName:%@",english2.name, english2.englishName);
    
    PropertyTypeTestObj *obj = [PropertyTypeTestObj new];
    obj.doubleType = 10.1;
    PropertyTypeTestObj *obj2 = [PropertyTypeTestObj modelWithOtherObject:obj];
    NSLog(@"resutl :%f", obj2.doubleType);
    
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(110, 110, 100, 50);
    button.buttonStyle = LKButtonStyleTopImageBottomText;
    [button setTitle:@"按按钮" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"position.png"] forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [[LSUDIDGenerator sharedInstance] udid];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [label showBorderPosition:LSBorderPositionTop borderColor:[UIColor orangeColor] borderWidth:1.0 contentInsets:UIEdgeInsetsZero];
    label.backgroundColor =[UIColor grayColor];
    label.text = @"111111111";
//    label.contentInsets = UIEdgeInsetsMake(10, 10, 20, 20);
//    [label showText:@"qeqeqwas" leftPadding:13];
    [self.view addSubview:label];
//    [label autoAlignInSuperview:LSAutoLayoutAlignCenterY];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
