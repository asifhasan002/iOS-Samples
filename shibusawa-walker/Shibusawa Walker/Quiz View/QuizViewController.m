//
//  QuizViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/9/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController{
    
    NSArray *titleArray,*textArray, *imageArray;
}

@synthesize tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //table view header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.width/2)+20.0)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/2)];
    [headerView addSubview:imageView];
    imageView.image = [UIImage imageNamed:@"aa.jpg"];
    tableView.tableHeaderView = headerView;
    
    //table view footer
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    titleArray = @[ @"Title1", @"Title2" ];
    textArray = @[ @"Text1 Text1 Text1", @"Text2 Text2 Text2" ];
    imageArray = @[ @"g1.jpg", @"g2.jpg" ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [textArray count];
}

// create the table rows and show the cell texts from database
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = titleArray[indexPath.row];
    cell.detailTextLabel.text = textArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageArray[indexPath.row]];
    
    return cell;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    QuizSelectionViewController *quizVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizSelectionViewControllerID"];
    quizVC.text = titleArray[indexPath.row];
    [self.navigationController pushViewController:quizVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88.0;
}



@end
