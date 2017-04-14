//
//  LoadProvinceData.h
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/30.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CityMess;
@interface LoadProvinceData : NSObject

/** 返回的SQLite3里面查询的对象结果 */
-(NSMutableArray *)finaModelData:(NSString *)SQLStr;

/** 条件查询省市县 */
-(NSMutableArray *)selectData:(NSString *)SQLStr;

/** 得到省份的数据 */
-(NSMutableArray *)loadProvinceMess;
/** 得到市级的数据 */
-(NSMutableArray *)loadCityMess:(CityMess *)province;
/** 得到县级的数据 */
-(NSMutableArray *)loadTownMess:(CityMess *)city;

/** 添加新的省份数据 */
-(void)addNewData:(NSArray *)city;
@end
