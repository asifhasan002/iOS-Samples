//
//  SelectFrameViewController.m
//  LLSimpleCameraExample
//
//  Created by XORGEEK3 on 1/3/17.
//  Copyright © 2017 Ömer Faruk Gül. All rights reserved.
//

#import "SelectFrameViewController.h"
#import "SnapViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SelectFrameViewController ()

@end

@implementation SelectFrameViewController{
    int selectedFrameIndex;
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat widthRatio;
    int checkInVale;
    NSArray *titleArray,*textArray,*imageArray;
    CGFloat lockedCellHeight;
    
    NSMutableArray *rowHeightArray;
    
}

-(BOOL)prefersStatusBarHidden{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    lockedCellHeight=0;
    
    rowHeightArray=[[NSMutableArray alloc]init];
    
     CGRect screenRect = [[UIScreen mainScreen] bounds];
     screenWidth = screenRect.size.width;
     screenHeight = screenRect.size.height;
    
    //checkInVale = 1;
    DBManager *dataManager = [[DBManager alloc] initWithDatabaseFilename:DATABASE_NAME];;
    NSString *chechinQuery = [NSString stringWithFormat:@"SELECT DATE(%@) as d from %@ GROUP by d", CHECKIN_TIME, CHECKIN_TABLE];
    checkInVale = (int)[dataManager loadDataFromDB:chechinQuery].count;
    
    [self fetchFrameFileNames];
    
     widthRatio=320.0/screenWidth;
    // checkInVale = 1;
    // [self fetchFrameFileNames];
    
     selectedFrameIndex=0;
    
    
    
    self.bannerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 220/widthRatio)];
 
    self.currentFrameImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  self.bannerView.frame.size.width,  self.bannerView.frame.size.height)];
    self.currentFrameImageView.image=[UIImage imageNamed:@"aa.jpg"];
    [ self.bannerView addSubview:self.currentFrameImageView];
    
    self.cameraImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 30, 25,25)];

    self.cameraImgView.image=[UIImage imageNamed:@"ic_img_camera.png"];
    [ self.bannerView addSubview:self.cameraImgView];
    
    
     self.currentFrameDescTextView=[[UILabel alloc]initWithFrame:CGRectMake(60, 27, 170/widthRatio, 32)];

     self.currentFrameDescTextView.textColor=[UIColor whiteColor];
    
     self.desc=[[UILabel alloc]initWithFrame:CGRectMake(20, 56, 170/widthRatio, 32)];
 self.desc.text=@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABBBBBBBBBBBBBBBBBBCCCCCCCCCCDDDDDDEE";
     self.desc.font=[self.desc.font fontWithSize:14];

     self.desc.numberOfLines=0;
    
    CGRect newFrame = self.desc.frame;
    newFrame.size.height =[self getLabelHeight:self.desc];
    self.desc.frame = newFrame;
    
    
     self.desc.textColor=[UIColor whiteColor];
     self.currentFrameDescTextView.text=@"12345678";
    
     [ self.bannerView addSubview:self.currentFrameDescTextView];
     [ self.bannerView addSubview:self.desc];
    
    
    titleArray = @[ @"Title1", @"Title2" ];
    textArray = @[ @"Text1 Text1 Text1", @"Text2 Text2 Text2" ];
    imageArray = @[ @"g1.jpg", @"g2.jpg" ];
    
    self.tableView.tableHeaderView = self.bannerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.rowTitleArray=[[NSMutableArray alloc]init];
    self.rowSubTitleArray=[[NSMutableArray alloc]init];
    self.rowDescArray=[[NSMutableArray alloc]init];
   
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count=[self.frameFileNameArray count];
    if(checkInVale<3){
        count+=1;
    }
    return count;
}

// create the table rows and show the cell texts from database
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell !=nil){
        cell=nil;
    }
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        if(indexPath.row<[self.frameFileNameArray count]){
            
            self.rowImageView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80/widthRatio, 80/widthRatio)];
            self.rowImageView.image=[UIImage imageNamed:self.frameFileNameArray[indexPath.row]];
            
            self.rowTitle=[[UILabel alloc]initWithFrame:CGRectMake((self.rowImageView.frame.size.width+15), 20, screenWidth-100, 32)];
            self.rowTitle.text=@"AAAAAAAAAAA";
            self.rowTitle.numberOfLines=0;
            
            self.rowSubTitle=[[UILabel alloc]initWithFrame:CGRectMake((self.rowImageView.frame.size.width+15), 30, screenWidth-100, 32)];
            self.rowSubTitle.text=@"SS";
            self.rowSubTitle.font=[UIFont systemFontOfSize:12];
            self.rowSubTitle.numberOfLines=0;
            
            
            self.rowDesc=[[UILabel alloc]initWithFrame:CGRectMake((self.rowImageView.frame.size.width+15), 60, screenWidth-100, 32)];
            self.rowDesc.text=@"AA";
            self.rowDesc.font=[UIFont systemFontOfSize:14];
            self.rowDesc.numberOfLines=0;
            
            CGFloat yCord=20;
            //resize UILabel frames accoring to text size
            CGRect rowTitleFrame = CGRectMake((self.rowImageView.frame.size.width+15), yCord, screenWidth-(self.rowImageView.frame.size.width+15), [self getLabelHeight:self.rowTitle]);
            self.rowTitle.frame = rowTitleFrame;
            
            yCord+=[self getLabelHeight:self.rowTitle];
            
            CGRect rowSubTitleFrame = CGRectMake((self.rowImageView.frame.size.width+15), yCord, screenWidth-(self.rowImageView.frame.size.width+15), [self getLabelHeight:self.rowSubTitle]);
            self.rowSubTitle.frame = rowSubTitleFrame;
            
            yCord+=[self getLabelHeight:self.rowSubTitle]+15;
            
            CGRect rowDescFrame = CGRectMake((self.rowImageView.frame.size.width+15), yCord, screenWidth-(self.rowImageView.frame.size.width+15), [self getLabelHeight:self.rowDesc]);
            self.rowDesc.frame = rowDescFrame;
            
            yCord+=[self getLabelHeight:self.rowDesc]+10;
            
            [rowHeightArray addObject:@(yCord)];
            
            
            [cell addSubview:self.rowImageView];
            [cell addSubview:self.rowTitle];
            [cell addSubview:self.rowSubTitle];
            [cell addSubview:self.rowDesc];

        }
        else{
            
            lockedCellHeight=10;
            
            if(checkInVale==1){
                
                
                UIView *lockView=[[UIView alloc]initWithFrame:CGRectMake(10, lockedCellHeight, self.tableView.frame.size.width-20,100)];
                [lockView setBackgroundColor:[UIColor redColor]];
                UIImageView *lockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 32, 32)];
                lockImageView.image=[UIImage imageNamed:@"ic_img_lock.png"];
                [lockView addSubview:lockImageView];
                
                UILabel *lockLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 20, self.tableView.frame.size.width-140, 64)];
                lockLabel.text=@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
                lockLabel.numberOfLines=2;
                
                
                [lockView addSubview:lockLabel];
                [cell addSubview:lockView];
                
                lockedCellHeight+=110;

            }
            
            if(checkInVale<3){
                
                UIView *lockView2=[[UIView alloc]initWithFrame:CGRectMake(10, lockedCellHeight, self.tableView.frame.size.width-20,100 )];
                [lockView2 setBackgroundColor:[UIColor redColor]];
                UIImageView *lockImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 32, 32)];
                lockImageView2.image=[UIImage imageNamed:@"ic_img_lock.png"];
                [lockView2 addSubview:lockImageView2];
                
                UILabel *lockLabel2=[[UILabel alloc]initWithFrame:CGRectMake(80, 20, self.tableView.frame.size.width-140, 64)];
                lockLabel2.text=@"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA";
                lockLabel2.numberOfLines=2;
                
                
                [lockView2 addSubview:lockLabel2];
                [cell addSubview:lockView2];
                lockedCellHeight+=110;

            }
            
        }
    }
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row== self.frameFileNameArray.count){
        return;
    }
    
    selectedFrameIndex=indexPath.row;
    SnapViewController *snapVC=[[SnapViewController alloc] initWithNibName:nil bundle:nil];
    snapVC.frameFileName=[self.frameFileNameArray objectAtIndex:selectedFrameIndex];
    [self presentViewController:snapVC animated:YES completion:^{
    
            }];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.frameFileNameArray.count==indexPath.row){
        return lockedCellHeight;
    }
    return (80/widthRatio)+20;
}





- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}



-(void)fetchFrameFileNames{
    
    //get folder images
    NSString *path1 = [NSString stringWithFormat:@"%@/camera_frames/FrameFolder1",[[NSBundle mainBundle] resourcePath]];
    NSArray *FileNames1 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path1 error:nil];
    
    NSString *path2 = [NSString stringWithFormat:@"%@/camera_frames/FrameFolder2",[[NSBundle mainBundle] resourcePath]];
    NSArray *FileNames2 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path2 error:nil];
    
    NSString *path3 = [NSString stringWithFormat:@"%@/camera_frames/FrameFolder3",[[NSBundle mainBundle] resourcePath]];
    NSArray *FileNames3 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path3 error:nil];
    
    self.frameFileNameArray = [[NSMutableArray alloc] init];
    
    //add folder images according to check in value
    for(int i = 0; i<FileNames1.count; i++){
        
        [self.frameFileNameArray addObject:[NSString stringWithFormat:@"%@/%@",path1,FileNames1[i]]];
    }
    
    
    if(checkInVale == 2){
        
        for(int i = 0; i<FileNames2.count; i++){
            
            [self.frameFileNameArray addObject:[NSString stringWithFormat:@"%@/%@",path2,FileNames2[i]]];
        }
    }
    else if(checkInVale > 2) {
        
        for(int i = 0; i<FileNames2.count; i++){
            
            [self.frameFileNameArray addObject:[NSString stringWithFormat:@"%@/%@",path2,FileNames2[i]]];
        }
        
        for(int i = 0; i<FileNames3.count; i++){
            
            [self.frameFileNameArray addObject:[NSString stringWithFormat:@"%@/%@",path3,FileNames3[i]]];
        }
    }
    
    //show lock image if not check in
    NSString *collectionPath = [NSString stringWithFormat:@"%@/camera_frames",[[NSBundle mainBundle] resourcePath]];
    NSArray *Files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:collectionPath error:nil];
    NSMutableArray *totalFiles = [[NSMutableArray alloc] init];
    
    for (NSString *_String in Files) {
        if ([_String hasSuffix:@".png"]) {
            
            [totalFiles addObject:_String];
        }
    }
    
}

@end
