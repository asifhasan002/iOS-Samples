//
//  RecipeCollectionViewController.h
//  RecipePhoto
//
//  Created by Simon on 13/1/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleViewController.h"
#import "Default.h"
#import "DBManager.h"

@interface ImageCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextView *txtView;




@end
