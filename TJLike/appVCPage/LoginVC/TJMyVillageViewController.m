//
//  TJMyVillageViewController.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/5.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJMyVillageViewController.h"
#import "TJVillageViewModel.h"
#import "TJVillageView.h"
#import "TJCityModel.h"

#define LABELCELL_Height (30)
#define LABELCELL_Y      (35)
#define LABELCELL_WidthH (80)
#define ThirdPartHeight 167.5
#define ThirdIconWH 66.5
#define TextFieldH 50
#define LineH 0.5


@interface TJMyVillageViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,TJVillageViewDelegate>

{
    UILabel *labelA;
    UILabel *labelB;
    
}
@property (nonatomic, strong) UITableView    *tableView;
@property (nonatomic, strong) TJVillageViewModel *viewModel;
@property (nonatomic, strong) NSArray        *cityLists;
@property (nonatomic, strong) NSArray        *streetLists;
@property (nonatomic, strong) NSArray        *communityLists;

@property (nonatomic, strong) TJVillageView  *cityVillageView;
@property (nonatomic, strong) TJVillageView  *streetVillageView;
@property (nonatomic, strong) TJVillageView  *communityVillageView;

@property (nonatomic, strong) UITextField    *commTextField;
@property (nonatomic, strong) NSString       *cityID;
@property (nonatomic, strong) NSString       *streetID;
@property (nonatomic, strong) NSString       *communityID;
@property (nonatomic, strong) NSString       *villageID;

@property (nonatomic, strong) NSString       *cityName;
@property (nonatomic, strong) NSString       *streetName;
@property (nonatomic, strong) NSString       *villageName;


@property (nonatomic, assign) NSInteger      communityStatus;

@property (nonatomic, assign) BOOL           isBindSuceess;
@end

@implementation TJMyVillageViewController

- (instancetype)init
{
    self =[super init];
    if (self) {
        
        _viewModel = [[TJVillageViewModel alloc] init];
        self.isBindSuceess = NO;
        self.communityStatus = 0;
    }
    return self;
}


- (void)bindViewModel
{
    _cityLists = [[NSArray alloc] init];
    _streetLists = [[NSArray alloc] init];
    _communityLists = [[NSArray alloc] init];
    
    @weakify(self)
    [[RACObserve(_viewModel, cityArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.cityLists = value;
    }];
    
    [[RACObserve(_viewModel, streetArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.streetLists = value;
    }];
    [[RACObserve(_viewModel, communityArr) filter:^BOOL(NSArray *value) {
        return value.count != 0;
    }] subscribeNext:^(NSArray *value) {
        @strongify(self)
        self.communityLists = value;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
    [self bindViewModel];
}

- (void)inistalNavBar
{
    [self.naviController setNaviBarTitle:@"我的小区"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    UIImage *leftImg = [UIImage imageNamed:@"appui_fanhui_"];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"appui_fanhui_" imgHighlight:nil withFrame:CGRectMake(0, 0, leftImg.size.width/2,leftImg.size.height/2)];
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:@"完成" imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
       
        [self.naviController popToRootViewControllerAnimated:YES];
        
        
        [_cityVillageView hideVillageView];
        [_streetVillageView hideVillageView];
        [_communityVillageView hideVillageView];
        
    }];
    [self.naviController setNaviBarRightBtn:rightBtn];
    
}

- (void)buildUI
{
    _tableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsHorizontalScrollIndicator = YES;
    _tableView.scrollEnabled = NO;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 10);
    [self.view addSubview:_tableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self inistalNavBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 70;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return SCREEN_HEIGHT - 70 *3;
            break;
        default:
            return 0;
            break;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 70 *3 - NAVIBAR_HEIGHT - STATUSBAR_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    
    
    UIImage *image =[UIImage imageNamed:@"sign_10_"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:CGRectMake(20, view.frame.size.height *3/4, SCREEN_WIDTH - 40, 50)];
    [button setTitle:@"提交" forState:UIControlStateNormal];
    
    @weakify(self)
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
      @strongify(self)  
        [self.viewModel postUserAddCommunity:self.cityID andStreet:self.streetID andCommunity:(self.communityStatus == 0?self.villageID:self.commTextField.text) andUserid:UserManager.userInfor.userId andStatus:[NSString stringWithFormat:@"%ld",(long)self.communityStatus] andFinish:^(NSArray *results) {
            
            self.isBindSuceess = YES;
            [self.view makeToast:@"绑定市区街道小区成功" duration:2.0 position:CSToastPositionCenter];
            
        } andFailed:^(NSString *errer) {
            self.isBindSuceess = NO;
            [self.view makeToast:@"绑定市区街道小区失败" duration:2.0 position:CSToastPositionCenter];
        }];
        
        
    }];
    
    [view addSubview:button];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *strCell = @"strCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:strCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                UIImageView *accessView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 13)];
                accessView.image = [UIImage imageNamed:@"appui"];
                cell.accessoryView = accessView;
                UIView *viewA  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"区县"];
                if (!labelA) {
                     labelA = [[UILabel alloc] initWithFrame:CGRectMake(10 + viewA.frame.size.width +viewA.frame.origin.x, LABELCELL_Y, cell.frame.size.width - viewA.frame.size.width, LABELCELL_Height)];
                    [labelA setTextAlignment:NSTextAlignmentLeft];
                    [labelA setTextColor:[UIColor blackColor]];
                     [cell addSubview:labelA];
                    [cell addSubview:viewA];
                }
                
                [labelA setText:self.cityName];
                
               
            }
                break;
            case 1:
            {
                UIImageView *accessView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 13)];
                accessView.image = [UIImage imageNamed:@"appui"];
                cell.accessoryView = accessView;
                UIView *viewC  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"街道/乡镇"];
                if (!labelB) {
                    labelB = [[UILabel alloc] initWithFrame:CGRectMake(10 + labelB.frame.size.width +labelB.frame.origin.x, LABELCELL_Y, cell.frame.size.width - labelB.frame.size.width, LABELCELL_Height)];
                    [labelB setTextAlignment:NSTextAlignmentCenter];
                    [labelB setTextColor:[UIColor blackColor]];
                    [cell addSubview:viewC];
                    [cell addSubview:labelB];
                }
                
                [labelB setText:self.streetName];
            }
                
                break;
            case 2:
            {

                UIView *viewD  = [self setupTableViewCellSubView:CGRectMake(15, LABELCELL_Y, LABELCELL_WidthH, LABELCELL_Height) andTitle:@"小区/村庄"];
                if (!_commTextField) {
                    _commTextField = [[UITextField alloc] initWithFrame:CGRectMake(10 + viewD.frame.size.width +viewD.frame.origin.x, LABELCELL_Y, cell.frame.size.width - viewD.frame.size.width, LABELCELL_Height)];
                    [_commTextField setReturnKeyType:UIReturnKeySend];
                    _commTextField.delegate = self;
                    _commTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
                    _commTextField.enabled = NO;
                    [_commTextField setPlaceholder:@"可手动录入增加社区"];
                    [cell addSubview:_commTextField];
                    [cell addSubview:viewD];
                }
                
        
                [cell.detailTextLabel setText:self.villageName];
               
                
            }
                
                break;
            default:
                break;
        }
    }


    return cell;
    
}


- (UIView *)setupTableViewCellSubView:(CGRect)frame andTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] init];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setText:title];
    
    [label  setFont:[UIFont systemFontOfSize:20]];
    [label setTextColor:[UIColor redColor]];
    CGSize size =  [UIUtil textToSize:title fontSize:20];
    [label setFrame:CGRectMake(0, 0, size.width, frame.size.height)];
    [view addSubview:label];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(label.frame.size.width + 20,0,1, label.frame.size.height)];
    [line setBackgroundColor:[UIColor redColor]];
    [view addSubview:line];
    
    view.frame = CGRectMake(frame.origin.x, frame.origin.y, label.frame.size.width + 21, frame.size.height);
    
    return view;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                CGRect cityFrame =[tableView rectForRowAtIndexPath:indexPath];
                if (!_cityVillageView) {
                   
                    @weakify(self)
                    [_viewModel getCityFinish:^(NSArray *results) {
                        @strongify(self)
//                        self.cityLists = results;
                        if (self.cityLists.count != 0) {
                            self.cityVillageView = [[TJVillageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH*3/4) - 20, cityFrame.size.height, SCREEN_WIDTH/4, SCREEN_HEIGHT/4) withData:_cityLists withStytle:Village_ViewStype_City];
                            self.cityVillageView.delegate = self;
                            [self.tableView addSubview:self.cityVillageView];
                            [self.streetVillageView hideVillageView];
                            self.streetVillageView = nil;
                            [self.communityVillageView hideVillageView];
                            self.communityVillageView = nil;
                            [self.cityVillageView showVillageView];
                        }
                        
                        
                    } andFailed:^(NSString *errer) {
                        
                    }];
                }
                else{
                    [_cityVillageView hideVillageView];
                    self.cityVillageView = nil;
                }

                TLog(@"%@",NSStringFromCGRect([tableView rectForRowAtIndexPath:indexPath]));
            }
                break;
            case 1:
            {
                
                CGRect streetFrame =[tableView rectForRowAtIndexPath:indexPath];
                if (!_streetVillageView) {
                   
                    @weakify(self)
                    
                    [_viewModel postStreet:self.cityID andFinish:^(NSArray *results) {
                        @strongify(self)
//                        self.streetLists = results;
                        if (self.streetLists.count != 0) {
                            self.streetVillageView = [[TJVillageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH*3/4) -60, streetFrame.size.height + streetFrame.origin.y, SCREEN_WIDTH/4 +40, SCREEN_HEIGHT/4) withData:self.streetLists withStytle:Village_ViewStype_street];
                            self.streetVillageView.delegate = self;
                            [self.tableView addSubview:self.streetVillageView];
                            
                            [self.cityVillageView hideVillageView];
                            self.cityVillageView = nil;
                            [self.communityVillageView hideVillageView];
                            self.communityVillageView = nil;
                            [self.streetVillageView showVillageView];
                        }
                        
                        
                    } andFailed:^(NSString *errer) {
                        
                    }];
                }
                else{
                    [_streetVillageView hideVillageView];
                    self.streetVillageView = nil;
                }
                
                TLog(@"%@",NSStringFromCGRect([tableView rectForRowAtIndexPath:indexPath]));
            }
                break;
            case 2:
            {
                CGRect communityFrame =[tableView rectForRowAtIndexPath:indexPath];
                if (!_communityVillageView) {
                    @weakify(self)
                    [_viewModel postCommunity:self.streetID andFinish:^(NSArray *results) {
                        @strongify(self)
//                        self.communityLists = results;
                        self.commTextField.enabled = YES;
                        [self.commTextField becomeFirstResponder];
                        if (self.communityLists.count != 0) {
                            
                            self.communityVillageView = [[TJVillageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH*3/4) - 20, communityFrame.size.height + communityFrame.origin.y, SCREEN_WIDTH/4, SCREEN_HEIGHT/4) withData:self.communityLists withStytle:Village_ViewStype_community];
                            self.communityVillageView.delegate = self;
                            [self.tableView addSubview:self.communityVillageView];
                            
                            
                            
                            [self.cityVillageView hideVillageView];
                            self.cityVillageView = nil;
                            [self.streetVillageView hideVillageView];
                            self.streetVillageView = nil;
                            [self.communityVillageView showVillageView];
                        }

                        
                    } andFailed:^(NSString *errer) {
                        
    
                    }];
                }
                else{
                    [_communityVillageView hideVillageView];
                    self.communityVillageView = nil;
                }
                
                TLog(@"%@",NSStringFromCGRect([tableView rectForRowAtIndexPath:indexPath]));
                
            }
                
                break;
            default:
                break;
        }
    }
    

}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_cityVillageView hideVillageView];
    [_streetVillageView hideVillageView];
    [_communityVillageView hideVillageView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    TLog(@"textFieldDidBeginEditing");
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    TLog(@"textFieldDidEndEditing");
    
   
    [self.viewModel postAddCommunity:self.streetID communtyName:self.commTextField.text andFinish:^(NSArray *results) {
        
        
        
    } andFailed:^(NSString *errer) {
        
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text != nil && !StringEqual(textField.text, @"")) {
        self.commTextField.enabled = NO;
        [self.communityVillageView hideVillageView];
        self.communityVillageView = nil;
        self.communityStatus = 1;
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didSelectRow:(id)modelObjc andType:(PageStype)type
{
    NSLog(@"didSelectRow");
    TJCityModel *itemModel = (TJCityModel *)modelObjc;
    switch (type) {
        case Village_ViewStype_City:
            self.cityID = itemModel.villageID;
            self.cityName = itemModel.villageName;
            break;
        case Village_ViewStype_street:
            self.streetID = itemModel.villageID;
            self.streetName = itemModel.villageName;
            break;
        case Village_ViewStype_community:
            self.communityID = itemModel.villageID;
            self.communityID = itemModel.villageName;
            self.communityStatus = 0;
            break;
        default:
            break;
    }

    
    [self.tableView reloadData];
    [_cityVillageView hideVillageView];
    [_streetVillageView hideVillageView];
    [_communityVillageView hideVillageView];
}




@end
