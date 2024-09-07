//
//  HomeViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "SnapViewController.h"
//#import "ViewUtils.h"
#import "ImageViewController.h"

@interface SnapViewController ()

@property (strong, nonatomic) UIButton *snapButton;
@property (strong,nonatomic)  UIButton *cancelButton;
@property (weak, nonatomic) FastttFilterCamera *fastCamera;
@end

@implementation SnapViewController{
    
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;

}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.frameImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,[UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, (self.view.frame.size.width*1.33)-[UIApplication sharedApplication].statusBarFrame.size.height)];
    self.frameImageView.image=[UIImage imageNamed:self.frameFileName];
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight=screenRect.size.height;
    
    UIImage *lookupFilterImage = [UIImage imageNamed:@"effect"];
    self.fastCamera = [FastttFilterCamera cameraWithFilterImage:lookupFilterImage];
    self.fastCamera.filterImage=lookupFilterImage;
    self.fastCamera.delegate = self;
    

    [self fastttAddChildViewController:self.fastCamera];
    self.fastCamera.view.frame = self.frameImageView.frame;
    
    
 
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.clipsToBounds = YES;
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.snapButton.layer.borderWidth = 5.0f;
    self.snapButton.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    self.snapButton.center=CGPointMake(self.frameImageView.frame.size.width  / 2,(screenWidth*1.33+((screenHeight-(screenWidth*1.33)))/2));
    
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.frameImageView];
    [self.view addSubview:self.snapButton];
    

    //cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(5,5, 32.0f, 32.0f);
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"ic_btn_close.png"] forState:UIControlStateNormal];
    self.cancelButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.cancelButton.center=CGPointMake(100/2,(screenWidth*1.33+((screenHeight-(screenWidth*1.33)))/2));
    [self.cancelButton setAlpha:0.50f];
    
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.cancelButton];
    [self setHorizontalLineToView];
    
}


//sets horizontal line between camera preview screen and rest of the screen
-(void)setHorizontalLineToView{
    UIView *horizontalLine=[[UIView alloc]initWithFrame:CGRectMake(0, (screenWidth*1.33), screenWidth, 1)];
    [horizontalLine setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:horizontalLine];
    
}

-(void)cancelButtonPressed{
    [self dismissViewControllerAnimated:(YES) completion:^{
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}



- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)snapButtonPressed:(UIButton *)button
{
    [self.fastCamera takePicture];
}



- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - IFTTTFastttCameraDelegate

- (void)cameraController:(FastttFilterCamera *)cameraController
 didFinishCapturingImage:(FastttCapturedImage *)capturedImage
{
    __weak typeof(self) weakSelf = self;

    
    ImageViewController *imageVC = [[ImageViewController alloc] initWithNibName:@"ImageViewController" bundle:nil];
    imageVC.image=capturedImage.fullImage;
    imageVC.frameImage=self.frameImageView.image;
    [weakSelf presentViewController:imageVC animated:NO completion:nil];

    /**
     *  Here, capturedImage.fullImage contains the full-resolution captured
     *  image, while capturedImage.rotatedPreviewImage contains the full-resolution
     *  image with its rotation adjusted to match the orientation in which the
     *  image was captured.
     */
}

- (void)cameraController:(FastttFilterCamera *)cameraController
didFinishScalingCapturedImage:(FastttCapturedImage *)capturedImage
{
       /**
     *  Here, capturedImage.scaledImage contains the scaled-down version
     *  of the image.
     */
}

- (void)cameraController:(FastttFilterCamera *)cameraController
didFinishNormalizingCapturedImage:(FastttCapturedImage *)capturedImage
{
    

    
    /**
     *  Here, capturedImage.fullImage and capturedImage.scaledImage have
     *  been rotated so that they have image orientations equal to
     *  UIImageOrientationUp. These images are ready for saving and uploading,
     *  as they should be rendered more consistently across different web
     *  services than images with non-standard orientations.
     */
}

@end
