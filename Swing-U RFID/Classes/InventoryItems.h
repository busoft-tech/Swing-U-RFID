//
//  InventoryItems.h
//  iManager
//
//  Created by jinugi011 on 2015. 7. 21..
//  Copyright (c) 2015년 nethom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryItems : NSObject
{
	int count;
	int number;
	NSString *TagId;
}


@property (nonatomic) int count;
@property (nonatomic) int number;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * TagId;
@property (nonatomic, retain) NSString * Lat;
@property (nonatomic, retain) NSString * Lng;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * Num;
@property (nonatomic) BOOL search;



//초기화해주는 메서드 : 객체가 생성되는 순서대로 number의 일련번호를 대입.
-(id)init;
//rank를 비교해서 그 결과를 리턴해주는 메서드
/*
-(NSComparisonResult)rankCompare:(InventoryItems *)Obj;
//name을 비교해서 그 결과를 리턴해주는 메서드
-(NSComparisonResult)nameCompare:(InventoryItems *)Obj;
*/

-(void)setSearch:(BOOL)search;
-(BOOL)getSearch;

@end

