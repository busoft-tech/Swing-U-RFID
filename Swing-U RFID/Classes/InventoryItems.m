//
//  InventoryItems.m
//  iManager
//
//  Created by jinugi011 on 2015. 7. 21..
//  Copyright (c) 2015년 nethom. All rights reserved.
//

#import "InventoryItems.h"

@implementation InventoryItems


static int sequence = 1; // 일련번호 를 주기 위해서는 static변수를 이용.
@synthesize count;
@synthesize TagId;
@synthesize number;

@synthesize name;
@synthesize Lat;
@synthesize Lng;
@synthesize category;
@synthesize search;
@synthesize Num;


-(id)init
{
	if((self = [super init])!=nil)
	{
		number = sequence++;
	}
	return self;
}
-(BOOL)getSearch{
    return search;
}

@end
