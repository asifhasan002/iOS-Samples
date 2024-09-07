//
//  CheckinHistoryViewController.m
//  Shibusawa Walker
//
//  Created by XOR Co. Ltd. on 1/9/17.
//  Copyright © 2017 XOR Co. Ltd. All rights reserved.
//

#import "CheckinHistoryViewController.h"

@interface CheckinHistoryViewController ()

@end

@implementation CheckinHistoryViewController{
    CGFloat widthRatio;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //configure navigation bar
    [self configureNavigationBar];
    
    widthRatio = [[UIScreen mainScreen]bounds].size.width/320;
    
    //remove table view empty cells
    self.historyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:DATABASE_NAME];
    
    //clear all previous data
    if (self.queryResultArray != nil) {
        self.queryResultArray = nil;
    }
    //load check in history from database
    NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ ORDER BY %@ DESC", CHECKIN_TABLE, ID];
    self.queryResultArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:queryString]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)configureNavigationBar{
    
    //set title navigation controller title
    [self.navigationItem setTitle: NSLocalizedString(@"checkin_history", nil)];
    
    //add close button as left bar button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem=leftBarButton;
}

-(void)dismissViewController{
    
    //dismiss current view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 1){
        return self.queryResultArray.count;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return widthRatio*50.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedString(@"checkin_number", nil);
            break;
        case 1:
            sectionName = NSLocalizedString(@"checkin_history", nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, widthRatio*30.0f)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
//    [label setFont:[UIFont boldSystemFontOfSize:12]];
//    NSString *string =[list objectAtIndex:section];
//    /* Section header is in 0th index... */
//    [label setText:string];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
//    return view;
//}
//set the cell height of the table
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return widthRatio*44.0f;
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

//pass the suitable data to corresponding view controller when a cell clicked
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = nil;
    static NSString *CellIdentifier = @"historyCell";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell != nil) {
        cell=nil;
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.section == 0){
        
        cell.textLabel.text = [NSString stringWithFormat:@"   %@",NSLocalizedString(@"checkin_number", "")];
        //add level
        UILabel *counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(tableView.frame.size.width-130.0f, 0.0f, 100.0f, cell.frame.size.height)];
        //set text alignment
        counterLabel.textAlignment = NSTextAlignmentRight;
        //set text
        counterLabel.text = [NSString stringWithFormat:@"%ld 回",self.queryResultArray.count];
        //add view
        [cell addSubview:counterLabel];
        
        
        
    }else{
        
        cell.textLabel.text = [NSString stringWithFormat:@"   %@",[[self.queryResultArray objectAtIndex:indexPath.row] objectAtIndex:2]];
    }
    return cell;
}

@end
