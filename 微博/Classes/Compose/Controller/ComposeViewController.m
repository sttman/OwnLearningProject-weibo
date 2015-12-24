//
//  ComposeViewController.m
//  微博
//
//  Created by mac on 15-8-24.
//  Copyright (c) 2015年 mac. All rights reserved.
//

#import "ComposeViewController.h"
#import "AccountTool.h"
#import "EmotionTextView.h"
#import "MBProgressHUD+NJ.h"
#import "AFNetworking.h"
#import "ComposeToolbar.h"
#import "ComposePhotosView.h"
#import "EmotionKeyboard.h"
#import "Emotion.h"
#import "UIView+Extension.h"
#import "NSString+Emoji.h"
@interface ComposeViewController ()<UITextViewDelegate,ComposeToolbarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/** 输入控件 */
@property (nonatomic, weak) EmotionTextView * textView;
/** 键盘顶部的工具条 */
@property (nonatomic, weak) ComposeToolbar * toolbar;
/** 相册（存放拍照或者相册中选择的图片） */
@property (nonatomic, weak) ComposePhotosView * photosView;
#warning 一定要用strong
/** 表情键盘 */
@property (nonatomic, strong) EmotionKeyboard * emotionKeyboard;
/** 是否正在切换键盘 */
@property (nonatomic, assign) BOOL switchingKeyboard;
@end

@implementation ComposeViewController
#pragma mark - 懒加载
- (EmotionKeyboard *)emotionKeyboard{
    if (_emotionKeyboard == nil) {
        _emotionKeyboard = [[EmotionKeyboard alloc]init];
        // 键盘的宽度
        _emotionKeyboard.width = self.view.width;
        _emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}
#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 设置导航栏内容
    [self setupNav];
    
    // 添加输入控件
    [self setupTextView];
    
    // 添加工具条
    [self setupToolbar];
    
    // 添加相册
    [self setupPhotosView];
    // 默认是YES：当scrollView遇到UINavigationBar，UITabBar等控件时，默认会设置scrollView的contentInset
//    self.automaticallyAdjustsScrollViewInsets;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 成为第一响应者（能输入文本的控件一旦成为第一响应者，就会叫出相应的键盘）
    [self.textView becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - 初始化方法
/**
 *  添加相册
 */
- (void)setupPhotosView{
    ComposePhotosView * photosView = [[ComposePhotosView alloc]init];
    photosView.y = 100;
    photosView.width = self.view.width;
    // 随便写的
    photosView.height = self.view.height;
    [self.textView addSubview:photosView];
    self.photosView = photosView;
}
/**
 *  添加工具条
 */
- (void)setupToolbar{
    ComposeToolbar * toolbar = [[ComposeToolbar alloc]init];
    toolbar.width = self.view.width;
    toolbar.height = 44;
    toolbar.y = self.view.height - toolbar.height;
    toolbar.delegate = self;
    // inputAccessoryView设置显示在键盘顶部的内容
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}
/**
 *  设置导航栏内容
 */
- (void)setupNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(send)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString * name = [AccountTool account].name;
    NSString * prefix = @"发微博";
    if (name) {
        UILabel * titleView = [[UILabel alloc]init];
        titleView.width = 200;
        titleView.height = 100;
        titleView.textAlignment = NSTextAlignmentCenter;
        // 自动换行
        titleView.numberOfLines = 0;
        titleView.y = 50;
        
        NSString * str = [NSString stringWithFormat:@"%@\n%@",prefix,name];
        // 创建一个带有属性的字符串（比如颜色属性、字体属性等文字 属性）
        NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc]initWithString:str];
        // 添加属性
        [attrStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:[str rangeOfString:prefix]];
        
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:[str rangeOfString:name]];
        titleView.attributedText = attrStr;
        self.navigationItem.titleView = titleView;
    }else{
        self.navigationItem.title = prefix;
    }
}
/**
 *  添加输入控件
 */
- (void)setupTextView{
    // 在这个控制器中，textView的ContentInset.top默认会等于64
    EmotionTextView * textView = [[EmotionTextView alloc]init];
    textView.frame = self.view.bounds;
    // 垂直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:15];
    textView.placeholder = @"分享新鲜事...";
    [self.view addSubview:textView];
    self.textView = textView;
    
    // 文字改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:textView];
    // 键盘改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    // 表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:@"EmotionDidSelectNotification" object:nil];
    // 删除文字的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:@"EmotionDidDeleteNotification" object:nil];
    
}
#pragma mark - 监听方法
/**
 *  删除文字
 */
- (void)emotionDidDelete{
    [self.textView deleteBackward];
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
/**
 *  表情被选中了
 */
- (void)emotionDidSelect:(NSNotification *)notification{
    Emotion * emotion = notification.userInfo[@"selectEmotion"];
    [self.textView insertEmotion:emotion];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
/**
 *  键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangFrame:(NSNotification *)notification{
    // 如果正在切换键盘，就不要执行后面的代码
    if (self.switchingKeyboard) return;
    NSDictionary * userInfo = notification.userInfo;
    // 动画持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        //执行动画
        if (keyboardF.origin.y > self.view.height) {// 键盘的Y值已远远超过了控制器View的高度
            self.toolbar.y = self.view.height - self.toolbar.height;
        }else{
            self.toolbar.y = keyboardF.origin.y - self.toolbar.height;
        }
    }];
}
- (void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)send{
    if (self.photosView.photos.count) {
        [self sendWithImage];
    }else{
        [self sendWithoutImage];
    }
    // dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  发有图片的微博
 */
- (void)sendWithImage{
    // URL: https://upload.api.weibo.com/2/statuses/upload.json
    // 参数
    /** status true string 要发布的微博文本内容，必须做URLencode，内容不能超过140个汉字。*/
    /** pic true binary 微薄的配图。*/
    /** access_token true string */
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://upload.api.weibo.com/2/statuses/upload.json" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 拼接文件数据
        UIImage * image = [self.photosView.photos firstObject];
        NSData * data = UIImageJPEGRepresentation(image, 1.0);// 5M以内的图片
        [formData appendPartWithFileData:data name:@"pic" fileName:@"test.jpg" mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}
/**
 *  发没有图片的微博
 */
- (void)sendWithoutImage{
    // URL: https://api.weibo.com/2/statuses/update.json
    // 参数
    /** status true string 要发布的微博文本内容，必须做URLencode，内容不能超过140个汉字。*/
    /** access_token true string */
    // 1.请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    //    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // AFN的AFJSONResponseSerializer默认不接受text/plain这种类型
    
    // 2.拼接请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = [AccountTool account].access_token;
    params[@"status"] = self.textView.fullText;
    
    // 3.发送请求
    [mgr POST:@"https://api.weibo.com/2/statuses/update.json" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary * responseObject) {
        [MBProgressHUD showSuccess:@"发送成功"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"发送失败"];
    }];
}
/**
 *  监听文字改变
 */
- (void)textDidChange{
    self.navigationItem.rightBarButtonItem.enabled = self.textView.hasText;
}
#pragma mark - UITextViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - ComposeToolbarDelegate
- (void)composeToolbar:(ComposeToolbar *)toolbar didClickButton:(ComposeToolbarButtonType)buttonType{
    switch (buttonType) {
        case ComposeToolbarButtonTypeCamera:// 拍照
            [self openCamera];
            break;
        case ComposeToolbarButtonTypePicture:// 相册
            [self openAlbum];
            break;
        case ComposeToolbarButtonTypeMention:// @
            
            break;
        case ComposeToolbarButtonTypeTrend:// #
            
            break;
        case ComposeToolbarButtonTypeEmotion:// 表情\键盘
            [self switchKeyboard];
            break;
    }
}

#pragma mark - 其他方法
/**
 *  切换键盘
 */
- (void)switchKeyboard{
    // self.textView.inputView == nil;使用的是系统自带的键盘
    if (self.textView.inputView == nil) {// 切换为自定义的表情键盘
        self.textView.inputView = self.emotionKeyboard;
        
        // 显示键盘按钮
        self.toolbar.showKeyboardButton = YES;
    }else { // 切换为系统自带的键盘
        self.textView.inputView = nil;
        
        // 显示表情按钮
        self.toolbar.showKeyboardButton = NO;
    }
    
    // 开始切换键盘
    self.switchingKeyboard = YES;
    
    // 退出键盘
    [self.textView endEditing:YES];

    // 结束切换键盘
    self.switchingKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 弹出键盘
        [self.textView becomeFirstResponder];
    });
}
- (void)openCamera{
    [self getImagePickerController:UIImagePickerControllerSourceTypeCamera];
}
- (void)openAlbum{
    // 如果想自己写一个图片选择控制器，得利用AssetsLibrary.framework，利用这个框架可以获得手机上的所有相册图片
    [self getImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)getImagePickerController:(UIImagePickerControllerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
//    self.picking = YES;
    UIImagePickerController * ipc = [[UIImagePickerController alloc]init];
    ipc.sourceType = type;
    ipc.delegate = self;
    [self presentViewController:ipc animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate
/**
 *  从UIImagePickerController选择完图片就调用（拍照完毕或者选择相册图片完毕）
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    // info中就包含了选择的图片
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    
    // 添加图片到photosView中
    [self.photosView addPhoto:image];
}
@end
