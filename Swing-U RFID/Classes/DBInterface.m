//
//  DBInterface.m
//  iManager
//
//  Created by jinugi011 on 2015. 7. 9..
//  Copyright (c) 2015년 nethom. All rights reserved.
//

#import "DBInterface.h"
#import <sqlite3.h>

#define aDB_FILENAME @"rfid_item.sqlite"


@interface DBInterface()
@property (copy, nonatomic) NSString *givenFilename;
@property (copy, nonatomic) NSString *dbPath;
@end

@implementation DBInterface
@synthesize dbPath=_dbPath;



+ (id)sharedInstance
{
	static DBInterface* this	= nil;

	if (!this)
    {
		this = [[DBInterface alloc] init];
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        this.filepath = [documentsDirectory stringByAppendingPathComponent:aDB_FILENAME];
    }

	return this;
}


-(void)createDatabase
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //도큐먼트 위치에 db.sqlite명으로 파일패스 설정
    _filepath = [documentsDirectory stringByAppendingPathComponent:aDB_FILENAME];
    //데이터베이스를 연결한다.
    //해당 위치에 데이터베이스가 없을경우에는 생성해서 연결한다.
    sqlite3 *database;

    if (sqlite3_open([_filepath UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error");
    }

    [self table_create_category:database];
    [self table_create_item:database];
    [self table_create_tag_list:database];
    sqlite3_close(database);
    
}


-(void)table_create_category:(sqlite3*)Db
{
	 char *sql = "CREATE TABLE IF NOT EXISTS [CAT] ([NAME] TEXT PRIMARY KEY NOT NULL UNIQUE);";
	 if (sqlite3_exec(Db, sql, nil,nil,nil) != SQLITE_OK) {
	        sqlite3_close(Db);
	        NSLog(@"Error");
     }else{
         NSLog(@"CAT is create");
     }
	// const char *sql = [[NSString stringWithFormat:@"SELECT COUNT(*) FROM [CAT] WHERE [NAME] = 'UNREGISTERED'"]UTF8String];
}

-(void)table_create_item:(sqlite3*)Db
{
	 char *sql = "CREATE TABLE IF NOT EXISTS [ITEM] ([UID] TEXT PRIMARY KEY NOT NULL UNIQUE, [CAT] TEXT NOT NULL, [NAME] TEXT NOT NULL, [COUNT] TEXT NOT NULL,[LAT] TEXT NULL,[LNG] TEXT NULL);";
		 if (sqlite3_exec(Db, sql, nil,nil,nil) != SQLITE_OK) {
		        sqlite3_close(Db);
		        NSLog(@"Error");
         }else{
                NSLog(@"ITEM is create");
         }
}
-(void)table_create_tag_list:(sqlite3*)Db
{
	 char *sql = "CREATE TABLE IF NOT EXISTS [TAG_LIST] ([UID] TEXT PRIMARY KEY NOT NULL UNIQUE );";
		 if (sqlite3_exec(Db, sql, nil,nil,nil) != SQLITE_OK) {
		        sqlite3_close(Db);
		        NSLog(@"Error");
         }else{
             
                NSLog(@"TAGLIST is create");
         }
}



-(NSString *)dbPath
{
    if(!_dbPath)
    {
        NSFileManager *fileman = [NSFileManager defaultManager];
        NSURL *documentPathURL = [[fileman URLsForDirectory:NSDocumentationDirectory inDomains:NSUserDomainMask]firstObject];
        NSString *databaseFilename = [self.givenFilename stringByAppendingString:@".sqlite"];
        
        _dbPath = [[documentPathURL URLByAppendingPathComponent:databaseFilename] path];
        
        if(![fileman fileExistsAtPath:_dbPath])
        {
            NSString *dbSource = [[NSBundle mainBundle] pathForResource:@"source" ofType:@"sqlite"];
            [fileman copyItemAtPath:dbSource toPath:_dbPath error:nil];
        }
    }
    return _dbPath;
}

-(id)initWithDataBaseFilename:(NSString*)databaseFilename
{
    self = [super init];
    if(self){
        self.givenFilename = databaseFilename;
    }
    return self;
}

-(void)updateRecordWithName:(NSString *)name description:(NSString*)description atID:(int)recordID
{
    sqlite3 *db;
    if(sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        const char *sql = "UPDATE test SET name=?, description=? WHERE id=?";
        sqlite3_stmt *stmt;
        if( sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            sqlite3_bind_text(stmt, 1, [name UTF8String], -1, NULL);
            sqlite3_bind_text(stmt, 2, [description UTF8String], -1, NULL);
            sqlite3_bind_int(stmt, 3, recordID);
            if(sqlite3_step(stmt) != SQLITE_DONE) {
                /* Process Error */
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
}

-(void)insertTagValue:(NSString *)strUid
{

	 NSLog(@" Call insertTag open is good");


	 sqlite3 *db;
	    if(sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
            NSLog(@" sqlite open is good");
	    	 const char *sql = [[NSString stringWithFormat:@"INSERT INTO [TAG_LIST] ([UID]) VALUES (\"%@\")",strUid] UTF8String];

	    	 sqlite3_stmt *updateStmt = nil;
	    	        if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL) != SQLITE_OK)
	    	        {
	    	        	 NSLog(@"insert is fail");
	    	        }
	    	        if (SQLITE_DONE != sqlite3_step(updateStmt)){

	    	        	 NSLog(@"db open is not done");
	    	        }

	    	        if (SQLITE_DONE == sqlite3_step(updateStmt)){

						 NSLog(@"db open is  done");
					}

	    	        sqlite3_reset(updateStmt);
	    	        sqlite3_finalize(updateStmt);
	    	    }
	    	    else{
                    NSLog(@"db open is fail");
	    	    }

	      sqlite3_close(db);
}


-(void)deleteTagvalues
{
	 sqlite3 *db;
	    if(sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
	    	 const char *sql = [[NSString stringWithFormat:@"DELETE FROM [TAG_LIST]"] UTF8String];
	    	 sqlite3_stmt *updateStmt = nil;
	    	        if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL) != SQLITE_OK)
	    	        {
	    	        }
	    	        if (SQLITE_DONE != sqlite3_step(updateStmt)){
	    	        }
	    	        sqlite3_reset(updateStmt);
	    	        sqlite3_finalize(updateStmt);
	    	    }
	    	    else{
	    	    }
	      sqlite3_close(db);
}


-(NSMutableArray *)getTagList:(NSString *)filter
{
    NSMutableArray *result = [NSMutableArray array];
    sqlite3 *db;
    if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        const char *sql = [[NSString stringWithFormat:@"SELECT [UID] FROM [TAG_LIST] WHERE UID LIKE \"%%%@%%\";",filter] UTF8String];
        sqlite3_stmt *stmt;
        if( sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(stmt)==SQLITE_ROW) {
                NSString *uid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                NSDictionary *anItem = @{@"uid":uid};
                [result addObject:anItem];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    if([result count] == 0) return nil;
    return result;
}


-(NSArray*)getcategory
{

	NSLog(@"DBInterface getcategory");

	    NSMutableArray *result = [NSMutableArray array];
	    sqlite3 *db;
	    if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
	        const char *sql = [[NSString stringWithFormat:@"SELECT [NAME] FROM [CAT] "] UTF8String];
	        sqlite3_stmt *stmt;
	        if( sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
	            while(sqlite3_step(stmt)==SQLITE_ROW) {
	            	NSString *cat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
	                NSDictionary *anItem = @{@"NAME":cat};
	                [result addObject:anItem];
	            }
	            sqlite3_finalize(stmt);
	        }
	        sqlite3_close(db);
	    }
	    if([result count] == 0) return nil;
	    return result;

}



-(NSArray *)getItems
{
	//([UID] TEXT PRIMARY KEY NOT NULL UNIQUE, [CAT] TEXT NOT NULL, [NAME] TEXT NOT NULL, [COUNT] TEXT NOT NULL,[LAT] TEXT NULL,[LNG] TEXT NULL)
    NSMutableArray *result = [NSMutableArray array];
    sqlite3 *db;
    if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM [ITEM]"] UTF8String];
        sqlite3_stmt *stmt;
        if( sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(stmt)==SQLITE_ROW) {
                NSString *uid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                NSString *cat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                NSString *count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                NSString *lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];;
                NSString *lng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                
                NSDictionary *anItem = @{@"UID":uid,@"CAT":cat,@"NAME":name,@"COUNT":count,@"LAT":lat,@"LNG":lng};
                [result addObject:anItem];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    if([result count] == 0) return nil;
    return result;
}



-(NSArray *)getItems:(NSString *)filter
{
	NSMutableArray *result = [NSMutableArray array];
	    sqlite3 *db;
	    if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
	        const char *sql = [[NSString stringWithFormat:@"SELECT [NAME] FROM [ITEM] WHERE [CAT] = %@ GROUP BY [NAME] ",filter] UTF8String];
	        sqlite3_stmt *stmt;
	        if( sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
	            while(sqlite3_step(stmt)==SQLITE_ROW) {
	                NSString *index = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];

	                NSDictionary *anItem = @{@"INDEX":index};
	                [result addObject:anItem];
	            }
	            sqlite3_finalize(stmt);
	        }
	        sqlite3_close(db);
	    }
	    if([result count] == 0) return nil;
	    return result;
}

-(NSArray *)getItemLoc:(NSString *)filter
{
	NSMutableArray *result = [NSMutableArray array];
	sqlite3 *db;
	if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
		const char *sql = [[NSString stringWithFormat:@"SELECT * FROM [ITEM] WHERE [UID] = %@ ",filter] UTF8String];
		sqlite3_stmt *stmt;
		if( sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
			while(sqlite3_step(stmt)==SQLITE_ROW) {
                NSString *uid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                NSString *cat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                NSString *count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                NSString *lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];;
                NSString *lng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                
				NSDictionary *anItem = @{@"UID":uid,@"CAT":cat,@"NAME":name,@"COUNT":count,@"LAT":lat,@"LNG":lng};
				[result addObject:anItem];
			}
			sqlite3_finalize(stmt);
		}
		sqlite3_close(db);
	}
	if([result count] == 0) return nil;
	return result;
}

-(BOOL)itemcheck:(NSString *)tagId
{
    
    BOOL recordExist=NO;
    int itemcount = 0;
    
    sqlite3 *db;
    if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        const char *sql = [[NSString stringWithFormat:@"SELECT [UID] FROM [ITEM] WHERE [UID] = \"%@\" ",tagId] UTF8String];
        sqlite3_stmt *stmt;
        if( sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(stmt)==SQLITE_ROW) {
                itemcount++;
                NSLog(@"Item exist");
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    
    if(itemcount > 0)
    {
        recordExist = YES;
    }else{
        recordExist = NO;
    }
    
    NSLog(@"recode exist = %d",itemcount);
    
    return recordExist;
}


-(NSArray *)getItemCategory:(NSString *)category
{
    NSMutableArray *result = [NSMutableArray array];
    sqlite3 *db;
    if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM [ITEM] WHERE [CAT] = %@ ",category] UTF8String];
        sqlite3_stmt *stmt;
        if( sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            while(sqlite3_step(stmt)==SQLITE_ROW) {
                NSString *uid = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                NSString *cat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                NSString *name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                NSString *count = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                NSString *lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];;
                NSString *lng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
                
                NSDictionary *anItem = @{@"UID":uid,@"CAT":cat,@"NAME":name,@"COUNT":count,@"LAT":lat,@"LNG":lng};
                [result addObject:anItem];
            }
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    if([result count] == 0) return nil;
    return result;
}

-(InventoryItems *)getItem:(NSString *)tagId
{
    InventoryItems *result = [InventoryItems alloc];
    
    sqlite3 *db;
    if (sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        
        const char *sql = [[NSString stringWithFormat:@"SELECT * FROM [ITEM] WHERE [UID]=\"%@\"",tagId] UTF8String];
        
        NSLog(@"get item one = %s",sql);
        
        sqlite3_stmt *stmt = nil;
        
        if(sqlite3_prepare(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
            
            while(sqlite3_step(stmt)==SQLITE_ROW)
            {
                
                result.TagId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 0)];
                result.category = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
                result.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
                result.Num = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
                result.Lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
                result.Lng = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
          
            }
            
            
            sqlite3_finalize(stmt);
        }
        
        
        
        sqlite3_close(db);
    }
    
    return result;
}


-(void)addCategory:(NSString *)name
{

	NSLog(@"DBInterface addCategory %@",name);

	sqlite3 *db;
	if(sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
		const char *sql = [[NSString stringWithFormat:@"INSERT INTO [CAT] ([NAME]) VALUES (\"%@\")",name] UTF8String];

		sqlite3_stmt *updateStmt = nil;
		if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL) != SQLITE_OK)
		{
			NSLog(@"insert is fail");
		}
		if (SQLITE_DONE != sqlite3_step(updateStmt)) {

		}
		if (SQLITE_DONE == sqlite3_step(updateStmt)) {
		}

		sqlite3_reset(updateStmt);
		sqlite3_finalize(updateStmt);
	}
	else {
		NSLog(@"db open is fail");
	}

	sqlite3_close(db);
}


-(void)additem:(NSString*)category_u name_u:(NSString*)name_u uid_u:(NSString*)uid_u tagcount_u:(NSString*)tagcount_u lat_u:(NSString*)lat_u lng_u:(NSString*)lng_u;
{
	//NSLog(@"sql = %@",[NSString stringWithFormat:@"INSERT INTO [ITEM] ([UID],[CAT],[NAME],[COUNT],[LAT],[LNG]) VALUES ('\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\" )",uid,category,name,tagcount,lat,lng]);
    sqlite3 *db;
	if(sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        
        
        NSString *sql_stmnt =[NSString stringWithFormat:@"INSERT INTO [ITEM] ([UID],[CAT],[NAME],[COUNT],[LAT],[LNG]) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",uid_u,category_u,name_u,tagcount_u,lat_u,lng_u];
        const char *sql = [sql_stmnt UTF8String];
        
        NSLog(@"%@",sql_stmnt);

      sqlite3_stmt *updateStmt = nil;
		if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL) != SQLITE_OK)
		{
			NSLog(@"insert is fail SQLITE_OK");
            [self sqlite3StmtToString:updateStmt];
		}
		if (SQLITE_DONE != sqlite3_step(updateStmt)) {
			NSLog(@"insert is fail");
		}
		if (SQLITE_DONE == sqlite3_step(updateStmt)) {
            NSLog(@"insert is success");
		}

		sqlite3_reset(updateStmt);
		sqlite3_finalize(updateStmt);
	}
	else {
		NSLog(@"db open is fail");
	}

	sqlite3_close(db);
}

-(void)updateitem:(NSString*)category name:(NSString*)name uid:(NSString*)uid tagcount:(NSString*)tagcount lat:(NSString*)lat lng:(NSString*)lng;
{
        NSLog(@"UPDATE CALL");
    
        sqlite3 *db;
		if(sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
            
            
            NSString *sql_stmnt =[NSString stringWithFormat:@"UPDATE [ITEM] set [CAT] = \"%@\",[NAME] = \"%@\",[COUNT] = \"%@\",[LAT] = \"%@\",[LNG] = \"%@\"  where [UID]= \"%@\" ",category,name,tagcount,lat,lng,uid];
            const char *sql = [sql_stmnt UTF8String];
            
            NSLog(@"%@",sql_stmnt);
        
			
	       sqlite3_stmt *updateStmt = nil;
			if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL) != SQLITE_OK)
			{
				NSLog(@"insert is fail SQLITE_OK");
	            [self sqlite3StmtToString:updateStmt];
			}
			if (SQLITE_DONE != sqlite3_step(updateStmt)) {
				NSLog(@"insert is fail");
			}
			if (SQLITE_DONE == sqlite3_step(updateStmt)) {
                NSLog(@"insert Ok");
			}

			sqlite3_reset(updateStmt);
			sqlite3_finalize(updateStmt);
		}
		else {
			NSLog(@"db open is fail");
		}

		sqlite3_close(db);
}

-(void)deleteItemsvalues
{
    
    NSLog(@"DELETE ALL ITEMS1");
    
    
    sqlite3 *db;
    if(sqlite3_open([_filepath UTF8String], &db) == SQLITE_OK) {
        const char *sql = [[NSString stringWithFormat:@"DELETE FROM [ITEM]"] UTF8String];
        sqlite3_stmt *updateStmt = nil;
        
        
        NSLog(@"DELETE ALL ITEMS2");
        if(sqlite3_prepare_v2(db, sql, -1, &updateStmt, NULL) != SQLITE_OK)
        {
            NSLog(@"Delete fail");
        }
        if (SQLITE_DONE != sqlite3_step(updateStmt)){
            NSLog(@"Delete fail2");
        }
        
        if(SQLITE_DONE == sqlite3_step(updateStmt))
        {
            NSLog(@"Success all data ");
        }
        sqlite3_reset(updateStmt);
        sqlite3_finalize(updateStmt);
    }
    else{
        
        NSLog(@"db open is fail");
        
    }
    sqlite3_close(db);
}




-(NSMutableString*) sqlite3StmtToString:(sqlite3_stmt*) statement
{
    NSMutableString *s = [NSMutableString new];
    [s appendString:@"{\"statement\":["];
    for (int c = 0; c < sqlite3_column_count(statement); c++){
        [s appendFormat:@"{\"column\":\"%@\",\"value\":\"%@\"}",[NSString stringWithUTF8String:(char*)sqlite3_column_name(statement, c)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, c)]];
        if (c < sqlite3_column_count(statement) - 1)
            [s appendString:@","];
    }
    [s appendString:@"]}"];

    NSLog(@" statusment = %@",s);

    return s;
}



@end
