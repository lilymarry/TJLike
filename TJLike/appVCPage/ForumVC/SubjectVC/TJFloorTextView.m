//
//  TJFloorTextView.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJFloorTextView.h"

@interface TJFloorTextView ()<UITextFieldDelegate>
{
    UITextField *textField;
    BOOL isHasImage;
    NSString *goodNum;
    TJSubCommentModel *kmodel;
}
@end

@implementation TJFloorTextView

- (instancetype)initWithFrame:(CGRect)frame withisImage:(BOOL)isImage 
{
    self = [super initWithFrame:frame];
    if (self) {
        self.isShow = NO;
        isHasImage = isImage;
        self.backgroundColor = [UIColor whiteColor];
        
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    CGFloat preBtnWidth = 0;
    
    UIButton *btnPraise = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPraise setImage:[UIImage imageNamed:@"赞.png"] forState:UIControlStateNormal];
    [btnPraise setFrame:CGRectMake(5, 5, 30, 30)];
    [self addSubview:btnPraise];
    
    
    preBtnWidth = btnPraise.frame.size.width + btnPraise.frame.origin.x;
    @weakify(self)
    [[btnPraise rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        TLog(@"我要赞了，哈哈");
        if ([self.delegate respondsToSelector:@selector(tapbtnPraise)]) {
            
            [self.delegate tapbtnPraise];
        }
    }];
    
    
    
    
    if (isHasImage) {
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnImage setImage:[UIImage imageNamed:@"fabu_zhaopian_"] forState:UIControlStateNormal];
        [btnImage setFrame:CGRectMake(btnPraise.frame.size.width + btnPraise.frame.origin.x +10, 5, 30, 30)];
        [self addSubview:btnImage];
        [[btnImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(tapBtnImages)]) {
                [self.delegate tapBtnImages];
            }
            
        }];
        preBtnWidth = btnImage.frame.origin.x +btnImage.frame.size.width - 20;
    }
    UIButton *btnSend = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnSend.layer setMasksToBounds:YES];
    btnSend.layer.borderWidth = 0.5;
    btnSend.layer.borderColor = [UIColor grayColor].CGColor;
    btnSend.layer.cornerRadius = 5;
    [btnSend setTitle:@"发送" forState:UIControlStateNormal];
    [btnSend setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btnSend setFrame:CGRectMake(SCREEN_WIDTH - 50, 5, 40, 30)];
    [self addSubview:btnSend];
    
    [[btnSend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        if (self->textField.text != nil && !StringEqual(self->textField.text, @"")) {
            if ([self.delegate respondsToSelector:@selector(sendComments:)]) {
              //  [self.delegate sendComments:self->textField.text];
                 [self.delegate sendComments:self->textField.text];
            }
//             [self.delegate sendCommentsForUser:kmodel withMesg:self->textField.text];
        }
    }];
    
    textField = [[UITextField alloc] initWithFrame:CGRectMake(preBtnWidth + 20, 5, SCREEN_WIDTH - btnSend.frame.size.width - preBtnWidth - 40, 30)];
    textField.placeholder = @"回复楼主";
    textField.borderStyle =UITextBorderStyleRoundedRect;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDefault;
    textField.enablesReturnKeyAutomatically=YES;
    textField.delegate = self;
    textField.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self addSubview:textField];
    [self handleKeyboard];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    [lineView setBackgroundColor:[UIColor grayColor]];
    [self addSubview:lineView];
}
- (void)removeKeyBoard
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:self];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleKeyboard {
//    [self removeKeyBoard];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat keyboardHeight = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    self.isShow = YES;
    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        @strongify(self)
        CGRect sendBtnFrame=self.frame;
        sendBtnFrame.origin.y=SCREEN_HEIGHT -keyboardHeight - sendBtnFrame.size.height;
        self.frame=sendBtnFrame;
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    float animationDuration = [[[notification userInfo] valueForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.isShow = NO;
    @weakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        @strongify(self)
        //        CGRect bframe = self.frame;
        //        bframe.origin.y = SCREEN_HEIGHT  - self.frame.size.height;
        self.frame=self.myFrame;
    } completion:nil];
}



- (void)callbackKeyboard
{
    [self endEditing:YES];
    textField.text = @"";
}

- (void)callShowKeyboard
{
    [textField becomeFirstResponder];
    
}

- (void)callMainComments
{
    if (UserManager.userInfor.userId) {
        [self callShowKeyboard];
        [textField setPlaceholder:@"我也说一句..."];
    }
    else{
        [SHARE_WINDOW makeToast:@"未登录，不能评论" duration:0.5 position:CSToastPositionCenter];
    }
}

- (void)callSubCommits:(NSString *)strTitle
{
    if (UserManager.userInfor.userId) {
        [self callShowKeyboard];
         [textField setPlaceholder:[NSString stringWithFormat:@"回复: %@ ",strTitle]];
       // textField.text = [NSString stringWithFormat:@"回复: %@ ",strTitle];
    }
    else{
        [SHARE_WINDOW makeToast:@"未登录，不能评论" duration:0.5 position:CSToastPositionCenter];
    }
    
}
//- (void)callSubCommitsModel:(TJSubCommentModel *)model
//{
//    if (UserManager.userInfor.userId) {
//        [self callShowKeyboard];
//        kmodel=model;
//        [textField setPlaceholder:[NSString stringWithFormat:@"回复: %@ ",model.commentidnickname]];
//        // textField.text = [NSString stringWithFormat:@"回复: %@ ",strTitle];
//    }
//    else{
//        [SHARE_WINDOW makeToast:@"未登录，不能评论" duration:0.5 position:CSToastPositionCenter];
//    }
//    
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self.delegate judgeUserLogin];
}

- (void)dealloc{
  //  TLog(@"textview dealloc");
    [self removeKeyBoard];
}

@end
