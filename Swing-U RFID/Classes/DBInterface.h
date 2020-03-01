//
//  DBInterface.h
//  iManager
//
//  Created by jinugi011 on 2015. 7. 9..
//  Copyright (c) 2015년 nethom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "InventoryItems.h"

@interface DBInterface : NSObject


@property(strong,nonatomic) NSString* filepath;

-(id)initWithDataBaseFilename:(NSString*)databaseFilename;
-(void)updateRecordWithName:(NSString *)name description:(NSString*)description atID:(int)recordID;

-(void)createDatabase;
-(void)table_create_category:(sqlite3*)Db;
-(void)table_create_item:(sqlite3*)Db;
-(void)table_create_tag_list:(sqlite3*)Db;


-(void)insertTagValue:(NSString *)strUid;
-(void)deleteTagvalues;
-(void)deleteItemsvalues;

-(NSMutableArray *)getTagList:(NSString *)filter;

-(NSArray*)getcategory;
-(NSArray *)getItems;
-(NSArray *)getItems:(NSString *)filter;
-(NSArray *)getItemLoc:(NSString *)filter;

-(InventoryItems *)getItem:(NSString *)tagId;


-(void)addCategory:(NSString *)name;
-(void)additem:(NSString*)category_u name_u:(NSString*)name_u uid_u:(NSString*)uid_u tagcount_u:(NSString*)tagcount_u lat_u:(NSString*)lat_u lng_u:(NSString*)lng_u;
-(void)updateitem:(NSString*)category name:(NSString*)name uid:(NSString*)uid tagcount:(NSString*)tagcount lat:(NSString*)lat lng:(NSString*)lng;


-(BOOL)itemcheck:(NSString *)tagId;

-(NSArray *)getItemCategory:(NSString *)category;



-(NSMutableString*) sqlite3StmtToString:(sqlite3_stmt*) statement;


+ (id)sharedInstance;


@end
