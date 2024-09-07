//
//  QuizSelectionViewController.m
//  Shibusawa Walker
//
//  Created by XOR Geek 03 on 1/15/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "QuizSelectionViewController.h"

@interface QuizSelectionViewController ()

@end

@implementation QuizSelectionViewController{
    
    NSArray *titleArray,*textArray, *imageArray;
}

@synthesize tableView,text;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //table view header
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width/3)];
   
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, (self.view.frame.size.width/3)+10, self.view.frame.size.width, 60.0)];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (imageView.frame.size.height+label.frame.size.height)+15.0)];
    [headerView addSubview:imageView];
    [headerView addSubview:label];
    
    imageView.image = [UIImage imageNamed:@"aa.jpg"];
    label.text = text;
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
    
    QuizDetailViewController *quizVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizDetailViewControllerID"];
    [self.navigationController pushViewController:quizVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88.0;
}


@end
