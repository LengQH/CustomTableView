//
//  CityMess.h
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/30.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityMess : NSObject
@property (nonatomic,copy)NSString *sort;
@property (nonatomic,copy)NSString *regionname;
/** 区域ID */
@property (nonatomic,copy)NSString *regionid;
@property (nonatomic,copy)NSString *parentid;
//构造方法
-(id)initWithCityMess:(NSString *)strSort regionname:(NSString *)strRegionname regionid:(NSString *)strRegionid parentid:(NSString *)strParentid;
//类方法
+(id)cityMess:(NSString *)strSort regionname:(NSString *)strRegionname regionid:(NSString *)strRegionid parentid:(NSString *)strParentid;
@end
