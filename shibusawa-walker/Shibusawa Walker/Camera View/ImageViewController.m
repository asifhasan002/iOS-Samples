//
//  ImageViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 15/11/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "ImageViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ImageViewController ()

@property (strong, nonatomic) UILabel *infoLabel;
@end

@implementation ImageViewController{
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


//blend camera shot and frame(Image) together as if camera shot is inside the frame
- (UIImage*)blendImages :(UIImage *)capturedImage and:(UIImage *)frameImage{
    
    UIImageView *mainImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,screenWidth,(screenWidth*1.33)- [UIApplication sharedApplication].statusBarFrame.size.height)];
    UIImageView *frameImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0,screenWidth,(screenWidth*1.33)- [UIApplication sharedApplication].statusBarFrame.size.height)];
    
    mainImageView.image=capturedImage;
    frameImageView.image=frameImage;
    
    
    UIView *imageContainer=[[UIView alloc]initWithFrame:CGRectMake(0,0, screenWidth,(screenWidth*1.33)- [UIApplication sharedApplication].statusBarFrame.size.height)];
    [imageContainer addSubview:mainImageView];
    [imageContainer addSubview:frameImageView];
    
    return [self convertUIViewToImageView:imageContainer];
}


//converts UIView to UIImage
- (UIImage *) convertUIViewToImageView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    
    self.view.userInteractionEnabled = YES;
    
    self.monoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, screenWidth,(screenWidth*1.33)- [UIApplication sharedApplication].statusBarFrame.size.height)];
    self.monoImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.monoImageView.backgroundColor = [UIColor redColor];
    
    self.monoImageView.image = [self blendImages:self.image and:self.frameImage];
    [self.view addSubview:self.monoImageView];
    
    
    
    UIView *cancelView=[[UIView alloc]initWithFrame:CGRectMake(0,0,132,32)];
    cancelView.backgroundColor=[UIColor blackColor];
    cancelView.center=CGPointMake(100,(screenWidth*1.33+((screenHeight-(screenWidth*1.33)))/2));
    cancelView.userInteractionEnabled = YES;
   
    
    UIImageView *cancel_capture_image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    cancel_capture_image.image=[UIImage imageNamed:@"ic_view_cancel_capture@2x"];
    [cancelView addSubview:cancel_capture_image];
    UILabel *cancelText=[[UILabel alloc]initWithFrame:CGRectMake(33, 0, 99, 32)];
    cancelText.backgroundColor=[UIColor blackColor];
    cancelText.textColor=[UIColor whiteColor];
    cancelText.text=@"キャンセル";
    cancelText.font=[UIFont systemFontOfSize:17];
    [cancelView addSubview:cancelText];
    
    [self.view addSubview:cancelView];
    
    

    
    
    
    
    UIView *saveView=[[UIView alloc]initWithFrame:CGRectMake(0,0,100,32)];
    saveView.center=CGPointMake(screenWidth-100,(screenWidth*1.33+((screenHeight-(screenWidth*1.33)))/2));
    [self.view addSubview:saveView];
    
    
    
    UIImageView *save_capture_image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 32, 32)];
    save_capture_image.image=[UIImage imageNamed:@"ic_view_save_capture@2x"];
    [saveView addSubview:save_capture_image];
    
    UILabel *saveText=[[UILabel alloc]initWithFrame:CGRectMake(33, 0, 67, 32)];
    saveText.backgroundColor=[UIColor blackColor];
    saveText.textColor=[UIColor whiteColor];
    saveText.text=@"保存";
    saveText.font=[UIFont systemFontOfSize:17];
    [saveView addSubview:saveText];

    UITapGestureRecognizer *cancelCaptureTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonPressed)];
    
    [cancelView addGestureRecognizer:cancelCaptureTap];
    
    UITapGestureRecognizer *saveCaptureTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(saveImageToGalaryButtonPressed)];
    
    [saveView addGestureRecognizer:saveCaptureTap];
    

    [self setHorizontalLineToView];
}

//sets horizontal line between camera preview screen and rest of the screen
-(void)setHorizontalLineToView{
    UIView *horizontalLine=[[UIView alloc]initWithFrame:CGRectMake(0, (screenWidth*1.33), screenWidth, 1)];
    [horizontalLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:horizontalLine];
    
}

-(void)saveImageToGalaryButtonPressed{
    

    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Confirm"
                                 message:@"Are you sure,you want to save this image?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    UIImageWriteToSavedPhotosAlbum(self.monoImageView.image, nil, nil, nil);
                                    [self dismissViewControllerAnimated:NO completion:nil];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)cancelButtonPressed{
     [self dismissViewControllerAnimated:NO completion:nil];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
  //  self.imageView.frame = self.view.contentBounds;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
