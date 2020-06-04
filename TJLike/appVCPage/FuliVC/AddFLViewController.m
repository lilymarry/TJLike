//
//  AddFLViewController.m
//  TJLike
//
//  Created by 123 on 16/9/3.
//  Copyright © 2016年 IPTV_MAC. All rights reserved.
//

#import "AddFLViewController.h"
#import "TJPictureView.h"
#import "TJTopicViewModel.h"
#import "WebApi.h"
#import "AlertHelper.h"
#import "ImageHelper.h"
//#import "ScreenHelper.h"
#define SHEAR_IMAHE_WIDTH   (320)
#define SHEAR_IMAGE_HEIGHT  (320)
@interface AddFLViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TJPictureViewDelegate>

{
    UIButton *btnCarmer;
    UIButton *btnPhoto;
    UITextView  *topicTextView;
    UITextView  *contentTextView;
    UILabel     *lblHolder;
    UILabel     *lblContent;
    UILabel     *imgNum;
    UIView      *bottomView;
    UIScrollView *scrollView;
    TJPictureView *pictureView;
    BOOL         isUploadImg;
    BOOL         isKeyBoard;
    BOOL         isContext;
    BOOL         isBottom;
    
    
}

@property (nonatomic, strong) TJBBSCateSubModel *cateModel;
@property (nonatomic, strong) TJTopicViewModel *viewModel;
@property (nonatomic, strong) UIImagePickerController *pickerVC;
@property (nonatomic, strong) UIImage         *editedImage;
@property (nonatomic, strong) NSMutableArray  *imagDatas;
@property (nonatomic, strong) NSMutableArray  *finalData;


@end

@implementation AddFLViewController

//- (instancetype)initWithItem:(TJBBSCateSubModel *)item
//{
//    self = [super init];
//    if (self) {
//        self.cateModel = item;
//        self.hidesBottomBarWhenPushed = YES;
//        isBottom = YES;
//        _viewModel = [[TJTopicViewModel alloc] init];
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   _imagDatas = [[NSMutableArray alloc] init];
    [self buildUI];
    isBottom = YES;
    [self handleKeyboard];
    [self initImagePicker];
}

- (void)initImagePicker
{
    _pickerVC = [[UIImagePickerController alloc] init];
    _pickerVC.allowsEditing = NO;
    _pickerVC.delegate = self;
}

- (void)initialNaviBar
{
    
    [self.naviController setNaviBarTitle:@"添加评论"];
    [self.naviController setNaviBarTitleStyle:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor],NAVTITLE_COLOR_KEY,[UIFont boldSystemFontOfSize:19.0],NAVTITLE_FONT_KEY,nil]];
    //    UIImage *leftImg = [UIImage imageNamed:@"navi_back"];
    UIButton *leftBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:nil imgNormal:@"navi_back" imgHighlight:nil withFrame:CGRectMake(0, 0, 40,40)];
    @weakify(self)
    [[leftBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [self.naviController popViewControllerAnimated:YES];
        
    }];
    [self.naviController setNaviBarLeftBtn:leftBtn];
    
    UIButton *rightBtn = [TJBaseNaviBarView createNaviBarBtnByTitle:@"发帖" imgNormal:nil imgHighlight:nil withFrame:CGRectMake(0, 0, 55,30)];
    rightBtn.backgroundColor=UIColorFromRGB(0xc72a2a);
    [rightBtn.layer setMasksToBounds:YES];
    [rightBtn.layer setBorderColor:UIColorFromRGB(0xc72a2a).CGColor];
    [rightBtn.layer setBorderWidth:1.0f];
    [rightBtn.layer setCornerRadius:4];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[rightBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (!StringEqual(self->topicTextView.text, @"") || !StringEqual(self->contentTextView.text, @"")) {
            NSData *data;
            if (self.imagDatas.count>0) {
                data=[NSData data];;

               data =self.imagDatas[0];
            }
            [AlertHelper MBHUDShow:@"提交中..." ForView:self.view AndDelayHid:30];
            [[WebApi  sharedRequest] AddHFCommentWithId:UserManager.userInfor.userId type:_status status:@"0" aid:_fuId reply:@"0" font:self->contentTextView.text  imgs:data Success:^(NSDictionary *dic){
                 [AlertHelper hideAllHUDsForView:self.view];
                if ([[dic objectForKey:@"code"] integerValue] == 200) {
                    [AlertHelper singleMBHUDShow:@"发送成功" ForView:self.view AndDelayHid:1];
                    NSObject<CommonDelegate> *tmpDele=self.refreshDelegate;
                    [tmpDele refreshingDataList];
                  
                    [self.naviController popViewControllerAnimated:YES];
                }
//                else if ([[dic objectForKey:@"code"] integerValue] == 502){
//                    [AlertHelper singleMBHUDShow:@"已存在" ForView:self.view AndDelayHid:1];
//                    
//                }
                else
                {
                    [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
                    
                }
                
            } fail:^(){
                [AlertHelper hideAllHUDsForView:self.view];
                
                [AlertHelper singleMBHUDShow:@"网络请求数据失败" ForView:self.view AndDelayHid:1];
                
            }];
            
            
            
//            [self.viewModel postTopicBBSAddTieba:self.imagDatas withCateID:self.cateModel.subID  andUserId:UserManager.userInfor.userId withTitle:self->topicTextView.text withFont:self->contentTextView.text withPalce:nil andFinish:^(NSDictionary *resultDict) {
//                [self.view makeToast:@"发布成功" duration:2.0 position:CSToastPositionCenter];
//                [self.naviController popViewControllerAnimated:YES];
//                
//            } andFailed:^(NSString *error) {
//                [self.view makeToast:error duration:2.0 position:CSToastPositionCenter];
//            }];
        }
        
    }];
    [self.naviController setNaviBarRightBtn:rightBtn];
}

- (void)buildImageUI
{
    if (!pictureView) {
        pictureView = [[TJPictureView alloc] initWithFrame:CGRectMake(0, bottomView.frame.size.height + bottomView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - bottomView.frame.size.height - bottomView.frame.origin.y)];
        pictureView.delegate = self;
        [self.view addSubview:pictureView];
    }
    
    pictureView.hidden = NO;
    [pictureView setBackgroundColor:[UIColor whiteColor]];
}
- (void)clearImageUI
{
    pictureView.hidden = YES;
    [pictureView removeFromSuperview];
    pictureView = nil;
}


- (void)buildUI
{
    self.view.backgroundColor=UIColorFromRGB(0xf0f0f0);
    //;
    
//    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT  - 45, SCREEN_WIDTH, 45)];
//    [bottomView setBackgroundColor:COLOR(244, 245, 249, 1)];
//    [self.view addSubview:bottomView];
//    bottomView.hidden=YES;
//    
//     btnCarmer = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnCarmer setFrame:CGRectMake(10, 2, 40, 40)];
//    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 25, 25)];
//    img.image=[UIImage imageNamed:@"相机.png"];
//    [btnCarmer addSubview:img];
//   // [btnCarmer setImage:[UIImage imageNamed:@"相机.png"] forState:UIControlStateNormal];
//    @weakify(self)
//    [[btnCarmer rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        @strongify(self)
//        
//        self->isUploadImg = YES;
//        [self.view endEditing:NO];
//        
//        [self gainPhotoFromCamera];
//        if (isBottom) {
//            
//            @weakify(self)
//            [UIView animateWithDuration:0.25 animations:^{
//                @strongify(self)
//                CGRect bframe = self->bottomView.frame;
//                isBottom = NO;
//                bframe.origin.y = 315 *SCREEN_PHISICAL_SCALE;
//                self->bottomView.frame=bframe;
//                [self buildImageUI];
//                [pictureView refresPictureView:self.imagDatas];
//                
//                
//            } completion:nil];
//            
//        }
//        
//    }];
//    [bottomView addSubview:btnCarmer];
//    
//    btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnPhoto setFrame:CGRectMake(btnCarmer.frame.size.width +btnCarmer.frame.origin.x +10, 2, 40, 40)];
//    
//
//    UIImageView *img1=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, 25, 25)];
//    img1.image=[UIImage imageNamed:@"image.png"];
//    [btnPhoto addSubview:img1];
//  //  [btnPhoto setImage:[UIImage imageNamed:@"image.png"] forState:UIControlStateNormal];
//    [[btnPhoto rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        self->isUploadImg = YES;
//        [self.view endEditing:NO];
//        [self gainPhotoFromPhotogallery];
//        if (isBottom) {
//            
//            @weakify(self)
//            [UIView animateWithDuration:0.25 animations:^{
//                @strongify(self)
//                CGRect bframe = self->bottomView.frame;
//                isBottom = NO;
//                bframe.origin.y = 315 *SCREEN_PHISICAL_SCALE;
//                self->bottomView.frame=bframe;
//                [self buildImageUI];
//                [pictureView refresPictureView:self.imagDatas];
//                
//                
//            } completion:nil];
//            
//        }
//        
//    }];
//    [bottomView addSubview:btnPhoto];
    
//    imgNum = [[UILabel alloc] initWithFrame:CGRectMake(bottomView.frame.size.width - 40 -20, 10, 25, 25)];
//    [imgNum.layer setMasksToBounds:YES];
//    imgNum.layer.cornerRadius = imgNum.frame.size.width/2;
//    [imgNum setBackgroundColor:[UIColor redColor]];
//    [imgNum setTextColor:[UIColor whiteColor]];
//    [imgNum setTextAlignment:NSTextAlignmentCenter];
//    [bottomView addSubview:imgNum];
//    self->imgNum.hidden = YES;
    
    //    [[RACObserve(self, imagDatas) filter:^BOOL(NSArray *value) {
    //
    //        return value.count != 0;
    //    }] subscribeNext:^(NSArray *value) {
    //        @strongify(self)
    //
    //    }];
    
//    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NAVIBAR_HEIGHT + STATUSBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - bottomView.frame.size.height)];
//    scrollView.showsVerticalScrollIndicator = NO;
//    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 44);
//    scrollView.delegate = self;
//    scrollView.backgroundColor = UIColorFromRGB(0xf0f0f0);
//    [self.view addSubview:scrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    topicTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, SCREEN_WIDTH - 10, 44)];
//    topicTextView.backgroundColor=[UIColor redColor];
//    topicTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    [topicTextView setFont:[UIFont systemFontOfSize:18]];
//    [[topicTextView layoutManager] usedRectForTextContainer:[topicTextView textContainer]];
//    topicTextView.dataDetectorTypes = UIDataDetectorTypeAll;
//    topicTextView.scrollEnabled = NO;
//    topicTextView.returnKeyType = UIReturnKeyNext;
//    topicTextView.delegate = self;
//    [scrollView addSubview:topicTextView];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, topicTextView.frame.size.height - 5, SCREEN_WIDTH, 0.5)];
//    [lineView setBackgroundColor:UIColorFromRGB(0xd2d2d2)];
//    [scrollView addSubview:lineView];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(5,64, SCREEN_WIDTH - 10, 200)];
  //  [contentTextView setBackgroundColor:UIColorFromRGB(0xf0f0f0)];
    [contentTextView setBackgroundColor:[UIColor whiteColor]];
    contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [contentTextView setFont:[UIFont systemFontOfSize:18]];
    [[contentTextView layoutManager] usedRectForTextContainer:[contentTextView textContainer]];
    contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    contentTextView.scrollEnabled = NO;
    contentTextView.returnKeyType = UIReturnKeyDefault;
    contentTextView.delegate = self;
    [self.view addSubview:contentTextView];
    
//    lblHolder = [[UILabel alloc] init];
//    lblHolder.frame =CGRectMake(10, 0, 150, 36);
//    lblHolder.text = @"请输入标题";
//    [lblHolder setTextAlignment:NSTextAlignmentLeft];
//    [lblHolder setTextColor:[UIColor grayColor]];
//    lblHolder.enabled = NO;
//    lblHolder.backgroundColor = [UIColor clearColor];
//    [scrollView addSubview:lblHolder];
    
    lblContent = [[UILabel alloc] init];
    lblContent.frame =CGRectMake(10, contentTextView.frame.origin.y, 150, 36);
    lblContent.text = @"请输入帖子内容";
    [lblContent setTextAlignment:NSTextAlignmentLeft];
    [lblContent setTextColor:[UIColor grayColor]];
    lblContent.enabled = NO;
    lblContent.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lblContent];
    
   // [self.view addSubview:bottomView];
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviController.navigationBarHidden = NO;
    [self initialNaviBar];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    isKeyBoard = YES;
    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        @strongify(self)
        //        if (!isKeyBoard) {
        CGRect sendBtnFrame=self->bottomView.frame;
        sendBtnFrame.origin.y=self.view.bounds.size.height-keyboardHeight-sendBtnFrame.size.height;
        self->bottomView.frame=sendBtnFrame;
        //        }
    } completion:nil];
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    isKeyBoard = NO;
    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        @strongify(self)
        CGRect bframe = self->bottomView.frame;
        if (self->isUploadImg) {
            isBottom = NO;
            bframe.origin.y = 315 *SCREEN_PHISICAL_SCALE;
            self->bottomView.frame=bframe;
           // TLog(@"%@",NSStringFromCGRect(bframe));
            [self buildImageUI];
            [pictureView refresPictureView:self.imagDatas];
        }
        else{
            isBottom = YES;
            bframe.origin.y = SCREEN_HEIGHT  - self->bottomView.frame.size.height;
            self->bottomView.frame=bframe;
            [self clearImageUI];
        }
        
    } completion:nil];
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == topicTextView) {
        if (textView.text.length == 0) {
            lblHolder.hidden = NO;
            lblHolder.text = @"标题";
        }else{
            lblHolder.hidden = YES;
            lblHolder.text = @"";
        }
    }
    else if (textView == contentTextView)
    {
        if (textView.text.length == 0) {
            lblContent.hidden = NO;
            lblContent.text = @"请输入帖子内容";
        }else{
            lblContent.hidden = YES;
            lblContent.text = @"";
        }
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == topicTextView) {
        isContext = NO;
        btnCarmer.enabled = btnPhoto.enabled = NO;
    }
    else if (textView == contentTextView)
    {
        isContext = YES;
        btnCarmer.enabled = btnPhoto.enabled = YES;
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if (textView == topicTextView) {
        if ([text isEqualToString:@"\n"]) {
            
            [contentTextView becomeFirstResponder];
            return NO;
        }
        
    }
    
    
    return YES;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(BOOL)textViewShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    isUploadImg = NO;
    //隐藏键盘
    [self.view endEditing:NO];
    
    if (!isKeyBoard) {
        [self clearImageUI];
        isBottom = YES;
        @weakify(self)
        [UIView animateWithDuration:0.25 animations:^{
            @strongify(self)
            CGRect bframe = self->bottomView.frame;
            bframe.origin.y =  SCREEN_HEIGHT  - self->bottomView.frame.size.height;
            self->bottomView.frame=bframe;
        } completion:nil];
    }
    
}

#pragma mark - choose carmer ,image library

- (void)gainPhotoFromPhotogallery
{
    _pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_pickerVC animated:YES completion:^{
        
    }];
    
}

- (void)gainPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        _pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerVC.mediaTypes = @[@"public.image"];
        
        [self presentViewController:_pickerVC animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:@"请注意" message:@"设备不支持相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alterView show];
    }
}
/////对图片尺寸进行压缩--
//-(UIImage*)imageScaleWithImage:(UIImage*)image
//{
//    //设置image的尺寸
//    CGSize imagesize = image.size;
//    
//    //iphone5
//    CGFloat a=(imagesize.height>imagesize.width)?320.0:568;
//    //iphone6
//    if ([ScreenHelper checkWhichIphoneScreen] == iphone6) {
//        a=(imagesize.height>imagesize.width)?375:667;
//    }else if ([ScreenHelper checkWhichIphoneScreen] == iphone6plus){
//        a=(imagesize.height>imagesize.width)?414:736;
//    }
//    
//    float XX=imagesize.width/a;//宽度比
//    float VY=imagesize.height/XX;//在屏幕上的高度
//    
//    imagesize.width = a;//放大倍数100
//    imagesize.height =VY;
//    
//    UIImage *ima = [self imageWithImage:image scaledToSize:imagesize];
//    return ima;
//    
//    
//}
//-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
//{
//    UIGraphicsBeginImageContext(newSize);
//    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}

//- (UIImage *)imageTelescopicToSize:(CGSize)size
//{
//    
//    UIGraphicsBeginImageContext(size);
//    
//    [self.editedImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//    
//}
- (NSData *)imageTransformData:(UIImage *)image
{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1);
    }
    else{
        data = UIImagePNGRepresentation(image);
    }
    
    return data;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if([type isEqualToString:@"public.image"]){
        UIImage *image = nil;
        
        if (_pickerVC.allowsEditing) {
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }
        else{
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
     //   self.editedImage = image;
        
      //  self.editedImage = [self imageTelescopicToSize:CGSizeMake(SHEAR_IMAHE_WIDTH, SHEAR_IMAGE_HEIGHT)];
        self.editedImage = [ImageHelper imageScaleWithImage:image];
    }
    
    @weakify(self);
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        NSData *data = [self imageTransformData:self.editedImage];
       // if (![self.imagDatas containsObject:data]) {
           
            [self.imagDatas removeAllObjects];
            [self.imagDatas addObject:data];
        //    self->imgNum.hidden = NO;
        //    [self->imgNum setText:[NSString stringWithFormat:@"%ld",(long)self.imagDatas.count]];
       // }
        
        [self->pictureView refresPictureView:self.imagDatas];
        
        
    }];
    
}

- (void)setImagDatas:(NSMutableArray *)imagDatas
{
    _imagDatas = imagDatas;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)removeImageView:(int)index
{
    [pictureView refresPictureView:self.imagDatas];
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
