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
#import "LSAlertController.h"
#import "NSDictionary+LS.h"

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
    EnglishBook *englishBook = [EnglishBook modelWithOtherObject:book1];
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
    
    NSLog(@"lalallalala %@",[NSDictionary modelJSONDictionaryWithModel:english2]);

    //**** Model with Array Property from JSON
    NSString *model4Json = @"{\"name\": \"Harry Potter\",\"read\": 1, \"pages\": 256, \"user\": {\"name\": \"J.K.Rowling\", \"birthday\": \"1965-07-31\" },\"userList\":[{\"name\": \"Zhang San\", \"birthday\": \"1965-07-31\" },{\"name\": \"Lee Si\", \"birthday\": \"1965-07-31\" }]}";
    Book *book4 = [Book modelWithJSON:model4Json];
    NSLog(@"book4's userList:%@",book4.userList);
    
    NSLog(@"lalallalala %@",[NSDictionary modelJSONDictionaryWithModel:book4]);
    
    NSLog(@"hehheheheheh %@", [book4 convertToJSONStr]);

    
    //**** View Mapping
    UIView *view = [UIView new];
    [view configViewFromData:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor greenColor];
    button.frame = CGRectMake(110, 110, 100, 50);
    button.buttonStyle = LKButtonStyleTopImageBottomText;

    [button setTitle:@"alert" forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"position.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showAlert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    actionButton.backgroundColor = [UIColor redColor];
    actionButton.frame = CGRectMake(110, 250, 100, 50);
    actionButton.buttonStyle = LKButtonStyleTopImageBottomText;
    [actionButton setTitle:@"sheet" forState:UIControlStateNormal];
    [actionButton setImage:[UIImage imageNamed:@"position.png"] forState:UIControlStateNormal];
    [actionButton addTarget:self action:@selector(showAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:actionButton];
    
    [[LSUDIDGenerator sharedInstance] udid];
    
    NSDictionary *dic = @{@"a": @1, @"b": @"2"};
    NSLog(@"%@", [dic toStringWithSplitString:@"&"]);
    
    [self countDown:10];
    
    UILabel *countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 300, 200, 30)];
    [self.view addSubview:countDownLabel];
    [countDownLabel countDownSetStartNumber:10000 endNumber:10 interval:1 countDownHandler:^(UILabel *label, NSInteger currentNumber, BOOL stopped) {
        if (stopped) {
            NSLog(@"stopped");
            label.backgroundColor = [UIColor grayColor];
        }
        label.text = [NSString stringWithFormat:@"还剩%d秒", currentNumber];
    }];
    [countDownLabel countDownStart];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)okClick
{
    NSLog(@"okClick");
}

- (void)cancelClick
{
    NSLog(@"cancelClick");
}

- (void)otherClick
{
    NSLog(@"otherClick");
}

-(void)countDown:(int)count{
    
    if(count <=0){
        
        NSLog(@"wociao ");
        
        return;
        
    }
    
    UILabel* lblCountDown = [[UILabel alloc] initWithFrame:CGRectMake(260, 120, 50, 50)];
    lblCountDown.textColor = [UIColor redColor];
    lblCountDown.font = [UIFont boldSystemFontOfSize:66];
    lblCountDown.backgroundColor = [UIColor clearColor];
    
    lblCountDown.text = [NSString stringWithFormat:@"%d", count];
    [self.view addSubview:lblCountDown];
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationCurveEaseOut animations:^{
                         
                         lblCountDown.alpha = 0;
                         lblCountDown.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                         
                     }
                     completion:^(BOOL finished) {
                         
                         [lblCountDown removeFromSuperview];
                         //递归调用，直到计时为零
                         [self countDown:count -1];
                         
                     }
     
     ];
    
}

- (void)showAction
{
    LSAlertController *alert = [LSAlertController alertControllerWithTitle:@"提示" message:@"内容" preferredStyle:LSAlertControllerStyleActionSheet];
    @weakify(self);
    LSAlertAction *okAction = [LSAlertAction actionWithTitle:@"确认" style:LSAlertActionStyleDestructive handler:^(LSAlertAction *action) {
        @strongify(self);
        [self okClick];
    }];
    [alert addAction:okAction];
    
    LSAlertAction *cancelAction = [LSAlertAction actionWithTitle:@"取消" style:LSAlertActionStyleCancel handler:^(LSAlertAction *action) {
        @strongify(self);
        [self cancelClick];
    }];
    [alert addAction:cancelAction];
    
    LSAlertAction *otherAction = [LSAlertAction actionWithTitle:@"其他" style:LSAlertActionStyleDestructive handler:^(LSAlertAction *action) {
        @strongify(self);
        [self otherClick];
    }];
    [alert addAction:otherAction];
    
    [alert showInController:self];
}

- (void)showAlert
{
    LSAlertController *alert = [LSAlertController alertControllerWithTitle:@"提示" message:@"内容" preferredStyle:LSAlertControllerStyleAlert];
    @weakify(self);
    LSAlertAction *okAction = [LSAlertAction actionWithTitle:@"确认" style:LSAlertActionStyleDestructive handler:^(LSAlertAction *action) {
        @strongify(self);
        [self okClick];
    }];
    [alert addAction:okAction];
    
    LSAlertAction *cancelAction = [LSAlertAction actionWithTitle:@"取消" style:LSAlertActionStyleCancel handler:^(LSAlertAction *action) {
        @strongify(self);
        [self cancelClick];
    }];
    [alert addAction:cancelAction];
    
    LSAlertAction *otherAction = [LSAlertAction actionWithTitle:@"其他" style:LSAlertActionStyleDestructive handler:^(LSAlertAction *action) {
        @strongify(self);
        [self otherClick];
    }];
    [alert addAction:otherAction];
    
    [alert showInController:self];
}

@end
