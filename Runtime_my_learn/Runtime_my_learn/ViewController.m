//
//  ViewController.m
//  Block->method
//
//  Created by tom on 08/01/2018.
//  Copyright © 2018 NWD. All rights reserved.
//  https://github.com/Flipboard/FLEX/blob/b0085cae7dc5348363da9121ae9b7681550cc58e/Classes/Utility/FLEXKeyboardShortcutManager.m#L136

#import "ViewController.h"
#import <objc/runtime.h>

@interface ViewController ()
{
    UIButton *btn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    btn = UIButton.new;
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [btn setTitle:@"\"this is a title\"" forState:UIControlStateSelected];
    NSString *title = [btn titleForState:UIControlStateSelected];
    NSLog(@"title is \"%@\"", title);
}

@end
