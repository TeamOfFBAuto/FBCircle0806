//
//  SendPostsViewController.m
//  FBCircle
//
//  Created by soulnear on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SendPostsViewController.h"
#import "SendPostsBottomView.h"
#import "SendPostsImageScrollView.h"
#import "TakePhotoView.h"
#import "MyImagePickViewController.h"
#import "TakePhotoPreViewController.h"

#define INPUT_HEIGHT 40.5

#define MAX_SHARE_WORD_NUMBER 30


@interface SendPostsViewController ()
{
    UILabel * title_place_label;//标题框默认文字
    
    UILabel * content_place_label;//内容框默认字
    
    SendPostsBottomView * bottom_view;//底部视图 相机 相册
    
    QBImagePickerController * imagePickerC;//选取本地照片类
    
    SendPostsImageScrollView * imageScrollView;//显示图片
    
    NSMutableArray * allImageArray;//存放图片数据
    
    NSMutableArray * allAssesters;
}

@end

@implementation SendPostsViewController
@synthesize title_textView = _title_textView;
@synthesize content_textView = _content_textView;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"新帖子";
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    right_button.frame = CGRectMake(0,0,40,44);
    
    right_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [right_button setTitle:@"发表" forState:UIControlStateNormal];
    
    [right_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [right_button addTarget:self action:@selector(sendTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * right_item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
    
    self.navigationItem.rightBarButtonItem = right_item;
    
    
    
    allImageArray = [NSMutableArray array];
    
    allAssesters = [NSMutableArray array];
    
    
    _title_textView = [[UITextView alloc] initWithFrame:CGRectMake(10,5,300,33)];
    
    _title_textView.textAlignment = NSTextAlignmentLeft;
    
    _title_textView.textColor = RGBCOLOR(3,3,3);
    
    _title_textView.backgroundColor = [UIColor clearColor];
    
    _title_textView.returnKeyType = UIReturnKeyDone;
    
    _title_textView.delegate = self;
    
    _title_textView.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:_title_textView];

    
    title_place_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,300,33)];
    
    title_place_label.font = [UIFont systemFontOfSize:16];
    
    title_place_label.textColor = RGBCOLOR(173,173,173);
    
    title_place_label.text = @"输入标题(必填)不超过30个字";
    
    title_place_label.textAlignment = NSTextAlignmentLeft;
    
    title_place_label.backgroundColor = [UIColor clearColor];
    
    title_place_label.userInteractionEnabled = NO;
    
    [_title_textView addSubview:title_place_label];
    
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15.5,43,320,0.5)];
    
    lineView.backgroundColor = RGBCOLOR(188,191,195);
    
    [self.view addSubview:lineView];
    
    
    
    _content_textView = [[UITextView alloc] initWithFrame:CGRectMake(10,43.5,300,80)];
    
    _content_textView.textAlignment = NSTextAlignmentLeft;
    
    _content_textView.textColor = RGBCOLOR(3,3,3);
    
    _content_textView.delegate = self;
    
    _content_textView.returnKeyType = UIReturnKeyDone;
    
    _content_textView.backgroundColor = [UIColor clearColor];
    
    _content_textView.delegate = self;
    
    _content_textView.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:_content_textView];
    
    
    content_place_label = [[UILabel alloc] initWithFrame:CGRectMake(10,0,300,33)];
    
    content_place_label.font = [UIFont systemFontOfSize:16];
    
    content_place_label.textColor = RGBCOLOR(173,173,173);
    
    content_place_label.text = @"输入正文";
    
    content_place_label.textAlignment = NSTextAlignmentLeft;
    
    content_place_label.backgroundColor = [UIColor clearColor];
    
    content_place_label.userInteractionEnabled = NO;
    
    [_content_textView addSubview:content_place_label];
    
    
    
    imageScrollView = [[SendPostsImageScrollView alloc] initWithFrame:CGRectMake(0,_content_textView.frame.origin.y+_content_textView.frame.size.height,320,150)];
    
    imageScrollView.showsHorizontalScrollIndicator = NO;
    
    imageScrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:imageScrollView];
    
    
    
    __weak typeof(self) bself = self;
    
    //选择相册 或是 相机
    bottom_view = [[SendPostsBottomView alloc] initWithFrame:CGRectMake(0,(iPhone5?568:480)-40.5-64,320,40.5) WithBlock:^(int index) {
        
        switch (index) {
            case 0://相机
            {
                [bself takePhotos];
            }
                break;
            case 1://相册
            {
                [bself localPhotos];
            }
                break;
                
            default:
                break;
        }
        
    }];

    
    [self.view addSubview:bottom_view];
    
    [self addNotificationObserVer];
    
}

//添加观察者
-(void)addNotificationObserVer
{
    //弹出键盘
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //隐藏键盘
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//删除观察者
-(void)deleteNotificationObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 弹出收回键盘

-(void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
    
}

-(void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[ZSNApi animationOptionsForCurve:curve]
                     animations:^{
                         
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = bottom_view.frame;
                         
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         bottom_view.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         
//                         CGRect content_frame = _content_textView.frame;
//                         
//                         content_frame.size.height = inputViewFrameY-43.5;
//                         
//                         _content_textView.frame = content_frame;
                         
                     }
                     completion:^(BOOL finished) {
                     }];
}


#pragma mark - 发表


-(void)sendTap:(UIButton *)sender
{
    NSLog(@"self.count -=-----  %@",allImageArray);
    
    
}




#pragma mark - 拍照

-(void)takePhotos
{
    
    UIImagePickerController * pickerC = [[UIImagePickerController alloc] init];
    
//    __weak typeof(self) bself = self;
    
    TakePhotoView * view = [[TakePhotoView alloc] initWithFrame:CGRectMake(0,0,320,(iPhone5?568:480)) WithBlock:^(int index) {
        
        switch (index) {
            case 0://拍照
            {
                [pickerC takePicture];
            }
                break;
            case 1://关闭相机
            {
                [pickerC dismissViewControllerAnimated:YES completion:NULL];
            }
                break;
                
            default:
                break;
        }
        
    }];
    
    view.backgroundColor = [UIColor clearColor];
    
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        pickerC.modalPresentationStyle = UIModalPresentationFullScreen;
        pickerC.delegate = self;
        pickerC.allowsEditing = YES;
        pickerC.sourceType = sourceType;
        pickerC.showsCameraControls = NO;
        pickerC.cameraOverlayView = view;
        
        [self presentViewController:pickerC animated:YES completion:nil];
    }
    else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}



#pragma mark - 从相册选取


-(void)localPhotos
{
    if (!imagePickerC)
    {
        imagePickerC = nil;
    }
    
    imagePickerC = [[QBImagePickerController alloc] init];
    imagePickerC.delegate = self;
    imagePickerC.allowsMultipleSelection = YES;
    
    imagePickerC.assters = allAssesters;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerC];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}


#pragma mark-QBImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
}


-(void)imagePickerController1:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
//    NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
    
//    for (int i = 0;i < mediaInfoArray.count;i++)
//    {
//        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
//        
//        UIImage * newImage = [SzkAPI scaleToSizeWithImage:image size:CGSizeMake(image.size.width>1024?1024:image.size.width,image.size.width>1024?image.size.height*1024/image.size.width:image.size.height)];
//        
//        [allImageArray addObject:newImage];
//        
//        NSURL * url = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerReferenceURL"];
//        
//        NSString * url_string = [[url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@""];
//        
//        url_string = [url_string stringByAppendingString:@".png"];
//        
//        [allAssesters addObject:url_string];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//            [ZSNApi saveImageToDocWith:url_string WithImage:image];
//        });
//    }
    
    
    [imagePickerController dismissViewControllerAnimated:YES completion:NULL];
    
    
    for (int i = 0;i < mediaInfoArray.count;i++)
    {
        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        [allImageArray addObject:image];
        
        
        [allAssesters addObject:[[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerReferenceURL"]];
    }
    
    [imageScrollView loadAllViewsWith:allImageArray];
    
}

-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
 /*直接发送方法
    NSMutableArray * allImageArray = [NSMutableArray array];
    
    NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
    
    UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [allImageArray addObject:image1];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library writeImageToSavedPhotosAlbum:image1.CGImage orientation:(ALAssetOrientation)image1.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
     {
         //here is your URL : assetURL
         
         NSString * url_string = [[assetURL absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@""];
         
         url_string = [url_string stringByAppendingString:@".png"];
         
         [allAssesters addObject:url_string];
         
         [picker dismissViewControllerAnimated:YES completion:NULL];
         
//         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
//             [ZSNApi saveImageToDocWith:url_string WithImage:image1];
//         });
     }];
  
  */
    
    
    /*
    
    UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [allImageArray addObject:image1];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:image1.CGImage orientation:(ALAssetOrientation)image1.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
     {
         //here is your URL : assetURL
         
         [allAssesters addObject:assetURL];
     }];
    
    [imageScrollView loadAllViewsWith:allImageArray];
     */
    
    
    
    
    TakePhotoPreViewController * previewC = [[TakePhotoPreViewController alloc] initWithBlock:^{
        
        UIImage *image1 = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSLog(@"image1 ----  %@ ----  %@",image1,info);
        
        
        
        [allImageArray addObject:image1];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:image1.CGImage orientation:(ALAssetOrientation)image1.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error )
         {
             //here is your URL : assetURL
             
             [allAssesters addObject:assetURL];
         }];
        
        [imageScrollView loadAllViewsWith:allImageArray];
        
        [picker dismissViewControllerAnimated:NO completion:NULL];
        
        NSLog(@"image2 ----  %@ ----  %@",image1,info);
        
    }];
    
    previewC.theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker presentViewController:previewC animated:YES completion:NULL];
    
    
    
}


-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    
    if ([name isEqualToString:desc])
        return aView;
    
    for (NSUInteger i = 0; i < [aView.subviews count]; i++)
    {
        UIView *subView = [aView.subviews objectAtIndex:i];
        subView = [self findView:subView withName:name];
        if (subView)
            return subView;
    }
    return nil;
}
-(void)addSomeElements:(UIViewController *)viewController
{
    UIView *PLCameraView=[self findView:viewController.view withName:@"PLCameraView"];
    UIView *bottomBar=[self findView:PLCameraView withName:@"PLCropOverlayBottomBar"];
    UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
    UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
    [retakeButton setTitle:@"重拍" forState:UIControlStateNormal];  //左下角按钮
    UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
    [useButton setTitle:@"上传" forState:UIControlStateNormal];  //右下角按钮
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [self addSomeElements:viewController];
}



#pragma mark - UITextView Delegate

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == _title_textView)
    {
        if (textView.text.length == 0)
        {
            title_place_label.text = @"输入标题(必填)不超过30个字";
        }else
        {
            title_place_label.text = @"";
        }
    }else
    {
        if (textView.text.length == 0)
        {
            content_place_label.text = @"输入正文";
        }else{
            content_place_label.text = @"";
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //碰到换行，键盘消失
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}


-(void)dealloc
{
    [self deleteNotificationObserver];
    
    for (UIView * view in imageScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    imageScrollView = nil;
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
