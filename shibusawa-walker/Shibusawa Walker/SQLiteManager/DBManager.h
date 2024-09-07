//
//  DBManager.h
//  SQLiteDemo
//
//  Created by XOR Co. Ltd. on 6/4/15.
//  Copyright (c) 2015 XOR Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@interface DBManager : NSObject

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *arrResults;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
