//
//  RecipeCollectionViewController.m
//  RecipePhoto
//
//  Created by Simon on 13/1/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "ImageCollectionViewController.h"

@interface ImageCollectionViewController () {
    NSMutableArray *ImagesArray;
    int checkInVale;
}

@end

@implementation ImageCollectionViewController

@synthesize txtView,collectionView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set collction view properties
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.contentInset = UIEdgeInsetsMake(0.0, self.view.frame.size.width/9.142857, 5.0, self.view.frame.size.width/9.142857);
    
    //checkInVale = 1;
    DBManager *dataManager = [[DBManager alloc] initWithDatabaseFilename:DATABASE_NAME];;
    NSString *chechinQuery = [NSString stringWithFormat:@"SELECT DATE(%@) as d from %@ GROUP by d", CHECKIN_TIME, CHECKIN_TABLE];
    checkInVale = (int)[dataManager loadDataFromDB:chechinQuery].count;
    
    //get folder images
    NSString *path1 = [NSString stringWithFormat:@"%@/CollectionImages/ImageFolder1",[[NSBundle mainBundle] resourcePath]];
    NSArray *FileNames1 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path1 error:nil];
    
    NSString *path2 = [NSString stringWithFormat:@"%@/CollectionImages/ImageFolder2",[[NSBundle mainBundle] resourcePath]];
    NSArray *FileNames2 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path2 error:nil];
    
    NSString *path3 = [NSString stringWithFormat:@"%@/CollectionImages/ImageFolder3",[[NSBundle mainBundle] resourcePath]];
    NSArray *FileNames3 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path3 error:nil];
    
    ImagesArray = [[NSMutableArray alloc] init];
    
    //add folder images according to check in value
    for(int i = 0; i<FileNames1.count; i++){
        
        [ImagesArray addObject:[NSString stringWithFormat:@"%@/%@",path1,FileNames1[i]]];
    }
    
    if(checkInVale == 2){
       
        for(int i = 0; i<FileNames2.count; i++){
            
            [ImagesArray addObject:[NSString stringWithFormat:@"%@/%@",path2,FileNames2[i]]];
        }
    }
    else if(checkInVale > 2) {
        
        for(int i = 0; i<FileNames2.count; i++){
            
            [ImagesArray addObject:[NSString stringWithFormat:@"%@/%@",path2,FileNames2[i]]];
        }
        
        for(int i = 0; i<FileNames3.count; i++){
            
            [ImagesArray addObject:[NSString stringWithFormat:@"%@/%@",path3,FileNames3[i]]];
        }
    }
    
    
    //show lock image if not check in
    NSString *collectionPath = [NSString stringWithFormat:@"%@/CollectionImages",[[NSBundle mainBundle] resourcePath]];
    NSArray *Files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:collectionPath error:nil];
    NSMutableArray *totalFiles = [[NSMutableArray alloc] init];
    
    for (NSString *_String in Files) {
        if ([_String hasSuffix:@".png"]) {
        
            [totalFiles addObject:_String];
        }
    }
    
    
    if([totalFiles count] > [ImagesArray count]){
        
        for(long i=([ImagesArray count]); i<[totalFiles count]; i++){
            
            [ImagesArray addObject:@"Lock.png"];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//collection view cell count
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ImagesArray.count;
}

//add image to collection view cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/4.5, self.view.frame.size.width/4.5)];
    imgView.image = [UIImage imageNamed:[ImagesArray objectAtIndex:indexPath.row]];
    [cell addSubview:imgView];
    
    return cell;
}

//collection view did select cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![ImagesArray[indexPath.row] isEqualToString:@"Lock.png"]){
    
        //launch puzzle play view controller
        PuzzleViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PuzzleViewControllerID"];
        viewController.originalImage_ = [UIImage imageNamed:[ImagesArray objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

//collection view cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width/4.5, self.view.frame.size.width/4.5);
}

@end
