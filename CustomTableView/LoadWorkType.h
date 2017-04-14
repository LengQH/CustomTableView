//
//  LoadWorkType.h
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/30.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorkType;
@interface LoadWorkType : NSObject
/** 返回的SQLite3里面查询的对象结果 */
-(NSMutableArray *)finaModelData:(NSString *)SQLStr;
/** 得到查询的一级结果 */
-(NSMutableArray *)selectAllWorkTypeResult:(NSString *)SQLStr;

/** 工种第一层数据 */
-(NSMutableArray *)loadProvinceMess;
/** 工种第二层数据 */
-(NSMutableArray *)loadCityMess:(WorkType *)province;
/** 工种第三层数据 */
-(NSMutableArray *)loadTownMess:(WorkType *)city;
/** 添加新的工种信息 */
-(void)addNewWorkerTypeMess:(NSArray *)typeMess;
@end
