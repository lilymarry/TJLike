//
//  BtnMoveView.m
//  TJLike
//
//  Created by imac-1 on 16/7/15.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "BtnMoveView.h"
#import "BtnMoves.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define KONGWIDTH (WIDTH - 4*60)/5

@interface BtnMoveView ()<MoveButtonDelegate>

@end
@implementation BtnMoveView

- (NSMutableArray*)allButtons
{
    if (!_allButtons)
    {
        _allButtons = [NSMutableArray array];
    }
    return _allButtons;
}
//- (NSMutableArray*)allButtons1
//{
//    if (!_allButtons1)
//    {
//        _allButtons1 = [NSMutableArray array];
//    }
//    return _allButtons1;
//}
//- (NSMutableArray*)views
//{
//    if (!_views)
//    {
//        _views = [NSMutableArray array];
//    }
//    return _views;
//}
- (id)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createButtons
{
    // NSLog(@"1110000------- %@",self.buttonTitles);
    self.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    
    UILabel * _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-100 , 20, 200, 20)];
    _titleLabel.text = @"长按并按住拖动可调整频道位置";
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel.textColor = [UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0];
    [self addSubview:_titleLabel];
    
    for (int i = 0; i < self.buttonTitles.count; i++)
    {
        //代表第几行
        NSInteger n = (NSInteger)i/4;
        //代表第几列
        NSInteger l = (NSInteger)i%4;
        BtnMoves* button=[BtnMoves buttonWithType:UIButtonTypeCustom];
        button.delegate=self;
        button.tag = i;
        button.userInteractionEnabled = YES;
        button.frame = CGRectMake(((KONGWIDTH + 60) * l) + KONGWIDTH, (n * (KONGWIDTH + 30)) + 60, 60, 30);
        [button setTitle:self.buttonTitles[i][@"name"] forState:UIControlStateNormal];
        
        button.btnId=self.buttonTitles[i][@"id"] ;
        
        button.layer.borderWidth = 0.3;
        button.layer.borderColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0].CGColor;
        button.layer.cornerRadius = 3.0;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:[UIColor whiteColor]];
        if (i==0) {
            [button setTitleColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeCount:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.allButtons addObject:button];
        button.btnArray = self.allButtons;
        [self addSubview:button];
        CGFloat height = button.frame.origin.y;
        CGFloat viewHeight = height + 50 + 30 + 40;
        self.frame = CGRectMake(0, 0, WIDTH, viewHeight);
        
    }
    
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(10 , self.frame.size.height - 40, WIDTH-20, 40)];
    [moreBtn setTitle: @"更多频道" forState:UIControlStateNormal ];
    moreBtn.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:62.0/255.0 blue:55.0/255.0 alpha:1.0];
    [self addSubview:moreBtn];
    
}
- (void)changeCount:(BtnMoves*)sender
{
    for (UIButton* button in self.allButtons)
    {
        if (button.tag == sender.tag)
        {
            [button setTitleColor:[UIColor colorWithRed:151.0/255.0 green:151.0/255.0 blue:151.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
        else
        {
            [button setTitleColor:[UIColor colorWithRed:19.0/255.0 green:19.0/255.0 blue:19.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        }
    }
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.buttonTitles];
  
        [array removeObjectAtIndex:sender.tag];
        self.buttonTitles = [array copy];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonMoveChange" object:self userInfo:@{@"buttonTag":[NSString stringWithFormat:@"%ld",(long)sender.tag],@"buttonArray":self.buttonTitles}];
   
}
- (void)removeAllBtnMoves
{
    for (BtnMoves* button in self.allButtons)
    {
        [button removeFromSuperview];
    }
    [self.allButtons removeAllObjects];
}
- (void)removeAllButtons
{
    for (UIButton* button in self.subviews)
    {
        [button removeFromSuperview];
    }
  //  [self.allButtons1 removeAllObjects];
}

//得到变化后的按钮数组
- (void)dragButton:(BtnMoves *)button buttons:(NSArray *)buttons
{
    // NSString* currentTitle=button.currentTitle;
    // NSLog(@"%@位置发生了改变,counts=%lu id %@",currentTitle,(unsigned long)button.tag,button.btnId);
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.buttonTitles];
    NSMutableArray* arr = [NSMutableArray arrayWithArray:self.buttonTitles];
    
    
    if ([buttons containsObject:button])
    {
        NSInteger index = [buttons indexOfObject:button];
        for (NSDictionary *dic in array) {
            if ([ dic[@"name"] isEqualToString:button.currentTitle]) {
                //   NSLog(@"拖动删除 _____ %@",dic);
                [arr removeObject:dic];
            }
        }
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys: button.currentTitle,@"name",button.btnId,@"id", nil];
        [arr insertObject:dic atIndex:index];
        
        //  NSLog(@"剩下 _____ %@",arr);
        
        self.buttonTitles = [arr copy];
        
    }
    //  [NSNotificationCenter defaultCenter]postNotificationName:<#(nonnull NSString *)#> object:<#(nullable id)#>;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonMoveChange" object:self userInfo:@{@"buttonTag":[NSString stringWithFormat:@"%ld",(long)button.tag],@"buttonArray":self.buttonTitles}];
    
}



@end
