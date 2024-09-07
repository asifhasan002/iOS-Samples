//
//  FirstLaunchScreen.m
//  Logger
//
//  Created by XOR Geek 03 on 8/20/15.
//  Copyright (c) 2015 XOR Geek 03. All rights reserved.
//

#import "HowToUseViewController.h"

@implementation HowToUseViewController{
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat widthRatio;
    int index;
    
}
//NSLocalizedString(@"announcement", nil)
- (void)viewDidLoad
{
    [super viewDidLoad];
    index=0;
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    widthRatio=screenWidth/320.0;
    
    self.view.backgroundColor=[UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0];
    
    [self populateContentArrays];
    
    [self createPages];
    
}


- (void)createPages{
    
    self.contentScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, self.dismissViewControllerButton.frame.size.height+self.dismissViewControllerButton.frame.origin.y, screenWidth, screenHeight-(self.dismissViewControllerButton.frame.size.height+30))];
   
    self.contentScrollView.scrollEnabled = NO;
    self.contentScrollView.contentSize = CGSizeMake(screenWidth*3, self.contentScrollView.frame.size.height);
    [self.view addSubview:self.contentScrollView];
    
    
    
    for(int i=0;i<3;i++){
        
        UIView *scrollViewContainer=[[UIScrollView alloc]initWithFrame:CGRectMake(0+screenWidth*i,0,screenWidth,self.contentScrollView.contentSize.height)];
        scrollViewContainer.backgroundColor=[UIColor colorWithRed:250.0/255.0f green:250.0/255.0f blue:250.0/255.0f alpha:1.0];
        [self.contentScrollView addSubview: scrollViewContainer];
        
        self.contentImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 150*widthRatio, 150*widthRatio)];
        self.contentImageView.contentMode=UIViewContentModeScaleAspectFit;
        self.contentImageView.center = CGPointMake(scrollViewContainer.frame.size.width  / 2,
                                                   (scrollViewContainer.frame.size.height / 2)-110*widthRatio);
        self.contentImageView.image = [UIImage imageNamed:[self.contentImageFileNamesArray objectAtIndex:i]];
        [scrollViewContainer addSubview:self.contentImageView];
        
        self.contentTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(30/widthRatio, self.contentImageView.frame.size.height+self.contentImageView.frame.origin.y+(10*widthRatio),scrollViewContainer.frame.size.width-(2*(30/widthRatio)), 20*widthRatio)];
        self.contentTitleLabel.numberOfLines=1;
        self.contentTitleLabel.text=[self.contentTitleArray objectAtIndex:i];
        self.contentTitleLabel.lineBreakMode=UILineBreakModeTailTruncation;
        self.contentTitleLabel.textAlignment = UITextAlignmentCenter;
        [scrollViewContainer addSubview:self.contentTitleLabel];
        
        
        self.contentDescLabel=[[UILabel alloc]initWithFrame:CGRectMake(30/widthRatio, self.contentTitleLabel.frame.size.height+self.contentTitleLabel.frame.origin.y-(5*widthRatio), scrollViewContainer.frame.size.width-(2*(30/widthRatio)), 90*widthRatio)];
        self.contentDescLabel.numberOfLines=3;
        self.contentDescLabel.textAlignment = UITextAlignmentCenter;
        self.contentDescLabel.text=[self.contentDescArray objectAtIndex:i];
        self.contentDescLabel.lineBreakMode=UILineBreakModeTailTruncation;
        [scrollViewContainer addSubview:self.contentDescLabel];
        
        
        self.lastPageDismissButton=[[UIButton alloc]initWithFrame:CGRectMake(30/widthRatio, self.contentDescLabel.frame.size.height+self.contentDescLabel.frame.origin.y, scrollViewContainer.frame.size.width-(2*(30/widthRatio)), 50*widthRatio)];
        [self.lastPageDismissButton setBackgroundColor:[UIColor whiteColor]];
        [self.lastPageDismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.lastPageDismissButton setTitle:NSLocalizedString(@"howToLastPageDissmissBtnTitle", nil) forState:UIControlStateNormal];

        [self.lastPageDismissButton addTarget:self
                                       action:@selector(dismissView)
                             forControlEvents:UIControlEventTouchUpInside];
        [scrollViewContainer addSubview:self.lastPageDismissButton];
        
        if(i==2){
            [self.lastPageDismissButton setHidden:false];
        }
        else{
            [self.lastPageDismissButton setHidden:true];
        }
        
        
        
        
        self.pagerView=[[UIView alloc]initWithFrame:CGRectMake(30/widthRatio, self.lastPageDismissButton.frame.size.height+self.lastPageDismissButton.frame.origin.y+(10*widthRatio),scrollViewContainer.frame.size.width-(2*30/widthRatio), 35*widthRatio)];
        [scrollViewContainer addSubview:self.pagerView];
        
        self.gotoPrevPageButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80*widthRatio,self.pagerView.frame.size.height)];
        [self.gotoPrevPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.gotoPrevPageButton setTitle:NSLocalizedString(@"howToPrevPageBtnTitle", nil) forState:UIControlStateNormal];
        [self.gotoPrevPageButton addTarget:self
                                    action:@selector(goToPrevPage)
                          forControlEvents:UIControlEventTouchUpInside];
        
        if(i==1||i==2){
            
            [self.gotoPrevPageButton setHidden:false];
        }
        else{
            [self.gotoPrevPageButton setHidden:true];
        }
        
        [self.pagerView addSubview:self.gotoPrevPageButton];
        
        self.gotoSecondPageButton=[[UIButton alloc]initWithFrame:CGRectMake(0,0, 80*widthRatio,self.pagerView.frame.size.height)];
        [self.gotoSecondPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.gotoSecondPageButton.center = CGPointMake(self.pagerView.frame.size.width  / 2,
                                                       self.pagerView.frame.size.height / 2);
        [self.gotoSecondPageButton setTitle:NSLocalizedString(@"howToNextPageBtnTitle", nil) forState:UIControlStateNormal];
        [self.gotoSecondPageButton addTarget:self
                                      action:@selector(goToSecondPage)
                            forControlEvents:UIControlEventTouchUpInside];
       
        [self.pagerView addSubview:self.gotoSecondPageButton];
        
        if(i==0){
            
            [self.gotoSecondPageButton setHidden:false];
        }
        else{
            [self.gotoSecondPageButton setHidden:true];
        }
        
        
        self.self.gotoNextPageButton=[[UIButton alloc]initWithFrame:CGRectMake(self.pagerView.frame.size.width-(80*widthRatio),0, 80*widthRatio,self.pagerView.frame.size.height)];
        [self.gotoNextPageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.self.gotoNextPageButton setTitle:NSLocalizedString(@"howToNextPageBtnTitle", nil) forState:UIControlStateNormal];
        [self.gotoNextPageButton addTarget:self
                                    action:@selector(goToNextPage)
                          forControlEvents:UIControlEventTouchUpInside];
        [self.pagerView addSubview:self.gotoNextPageButton];
        
        if(i==1){
            
            [self.gotoNextPageButton setHidden:false];
        }
        else{
            [self.gotoNextPageButton setHidden:true];
        }
    }
    

}

- (void)populateContentArrays{
    
    self.contentImageFileNamesArray=[[NSMutableArray alloc]init];
    [self.contentImageFileNamesArray addObject:@"how_to_img_start.png"];
    [self.contentImageFileNamesArray addObject:@"how_to_img_middle.png"];
    [self.contentImageFileNamesArray addObject:@"how_to_img_end.png"];
    
    
    self.contentTitleArray=[[NSMutableArray alloc]init];
    [self.contentTitleArray addObject:NSLocalizedString(@"howToTitleOne", nil)];
    [self.contentTitleArray addObject:NSLocalizedString(@"howToTitleTwo", nil)];
    [self.contentTitleArray addObject:NSLocalizedString(@"howToTitleThree", nil)];
    
    
    
    self.contentDescArray=[[NSMutableArray alloc]init];
    [self.contentDescArray addObject:NSLocalizedString(@"howToDescOne", nil)];
    [self.contentDescArray addObject:NSLocalizedString(@"howToDescTwo", nil)];
    [self.contentDescArray addObject:NSLocalizedString(@"howToDescThree", nil)];

}

- (void)goToNextPage{
    index=index+1;
    [self scrollToIndexPageNo];
}

- (void)goToSecondPage{
    index=index+1;
    [self scrollToIndexPageNo];
}
- (void)goToPrevPage{
    index=index-1;
    [self scrollToIndexPageNo];
}

- (void)scrollToIndexPageNo{
    CGRect frame = self.contentScrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [self.contentScrollView scrollRectToVisible:frame animated:YES];
}

- (void)dismissView{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)dismissViewControllerButtonPressed:(id)sender {
    
   [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}
@end
