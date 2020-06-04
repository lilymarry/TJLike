//
//  EditCategoryViewController.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "CategoryManager.h"
#import "BtnMoveView.h"
#import "ButtonsCell.h"
#import "AlertHelper.h"
@interface EditCategoryViewController ()
{
    UITableView *mTableView;
    NSMutableArray *cateArray;
    NSMutableArray *listArr;
}
@property (nonatomic, strong) BtnMoveView* buttonsView;

@end

@implementation EditCategoryViewController
- (BtnMoveView*)buttonsView
{
    if (!_buttonsView)
    {
        _buttonsView = [[BtnMoveView alloc]init];
    }
    return _buttonsView;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.naviController setNaviBarTitle:@"内容定制"];
    [self.naviController setNavigationBarHidden:NO];
    [self.naviController setNaviBarDefaultLeftBut_Back];
     [self.naviController.navigationBar setBarTintColor:[UIColor whiteColor]];
}
- (void)requestRegionsInfo {
    
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.zounai.com/index.php/api/NewMenu"];
 
 [HttpClient request:nil URL:urlStr success:^(NSDictionary *info) {
       
        [listArr removeAllObjects];
        for (int i = 0; i<[info[@"data"] count]; i++) {
            NSDictionary *dict = info[@"data"][i];
            [cateArray addObject:dict];
        }
      
        [self getlistData:_dataSource andArr:cateArray];
       [mTableView reloadData];
 } fail:^{
     [[[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接差，稍后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
 }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cateArray = [[NSMutableArray alloc]initWithCapacity:10];
    listArr = [[NSMutableArray alloc]initWithCapacity:10];
    
   self.automaticallyAdjustsScrollViewInsets = NO;//    自动滚动调整，默认为YES
    
    [self requestRegionsInfo];
    self.view.backgroundColor=[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];


    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self createHeaderView];
    mTableView.tableHeaderView = self.buttonsView;
   // self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(goBack)];
    
   // mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
   // [mTableView setEditing:YES];
    [self.view addSubview:mTableView];
    [mTableView registerNib:[UINib nibWithNibName:@"ButtonsCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(buttonMoveChange:) name:@"buttonMoveChange" object:nil];

}
- (void)goBack
{
//    NSMutableArray *arr=[NSMutableArray arrayWithArray:self.buttonsView.buttonTitles];
//    [CategoryManager Share].mcArray = arr;
//    // self.mBlock();
//
//    [self.navigationController popViewControllerAnimated:YES];
//    
//    NSLog(@"---->%@",[CategoryManager Share].mcArray);
}
- (void)createHeaderView
{
    self.buttonsView.buttonTitles =self. dataSource;
    [self.buttonsView createButtons];
}
-(void)getlistData:(NSArray *)s1 andArr:(NSArray *)s2
{
    NSMutableArray *arr1=[NSMutableArray arrayWithArray:s1];
    NSMutableArray *arr2=[NSMutableArray arrayWithArray:s2];
    [s1 enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([s2  containsObject:obj]) {
            [arr1 removeObject:obj];
            [arr2 removeObject:obj];
        }
        
        
    }];
    [arr1 addObjectsFromArray:arr2];
    
    listArr=[arr1 copy];

}
//按钮改变
- (void)buttonMoveChange:(NSNotification*)notification
{

    [self.buttonsView  removeAllButtons];
    [self.buttonsView removeAllBtnMoves];
   // self.dataSource = notification.userInfo[@"buttonArray"];
    self.buttonsView.buttonTitles = notification.userInfo[@"buttonArray"];
   // NSLog(@"控制器剩余 ————  %@ ",self.buttonsView.buttonTitles);
    [self.buttonsView createButtons];
    dispatch_async(dispatch_get_main_queue(), ^{
        mTableView.tableHeaderView = self.buttonsView;
                [self getlistData:self.buttonsView.buttonTitles andArr:cateArray];
               [mTableView reloadData];
    });
}
//添加频道
- (void)addData:(UIButton*)sender
{
    [self.buttonsView  removeAllButtons];
    [self.buttonsView removeAllBtnMoves];
  //  self.dataSource = self.buttonsView.buttonTitles;
    ButtonsCell *cell = (ButtonsCell*)[[sender superview]superview];
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.buttonsView.buttonTitles];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:cell.myLabel.text,@"name",cell.butId,@"id", nil];
      [array addObject:dic];
       self.buttonsView.buttonTitles = [array copy];
       [self.buttonsView createButtons];

    //删除行
       NSMutableArray *tempArray =  [NSMutableArray arrayWithArray:listArr];
    
    [tempArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj[@"id"] isEqualToString:cell.butId]) {
            
            *stop = YES;
            
            if (*stop == YES) {
                
                [tempArray removeObject:dic];
                
            }
            
        }
        
    }];
        listArr = [tempArray copy];
        dispatch_async(dispatch_get_main_queue(), ^{
        mTableView.tableHeaderView = self.buttonsView;
        [mTableView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSMutableArray *arr=[NSMutableArray arrayWithArray:self.buttonsView.buttonTitles];
    if (arr.count>0) {
        [CategoryManager Share].mcArray = arr;

    }
   
    self.mBlock();
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    return listArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ButtonsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    
         cell.myLabel.text = [listArr objectAtIndex:indexPath.row][@"name"];
         [cell.myButton addTarget:self action:@selector(addData:) forControlEvents:UIControlEventTouchUpInside];
         cell.butId=[listArr objectAtIndex:indexPath.row][@"id"];
   
    return cell;
    
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleNone;
//}
//-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    [_dataSource exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
//    [CategoryManager Share].mcArray = _dataSource;
//    NSLog(@"---->%@",[CategoryManager Share].mcArray);
//}
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//#pragma mark - Table view delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
