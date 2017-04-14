//
//  CityMess.m
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/30.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "CityMess.h"

@implementation CityMess
//构造方法
-(id)initWithCityMess:(NSString *)strSort regionname:(NSString *)strRegionname regionid:(NSString *)strRegionid parentid:(NSString *)strParentid{
    if(self=[super init]){ //父类的init方法
        self.sort=strSort;
        self.regionname=strRegionname;
        self.regionid=strRegionid;
        self.parentid=strParentid;
    }
    return self;
}
//类方法
+(id)cityMess:(NSString *)strSort regionname:(NSString *)strRegionname regionid:(NSString *)strRegionid parentid:(NSString *)strParentid{
    CityMess *mess=[[CityMess alloc]init];
    mess.sort=strSort;
    mess.regionname=strRegionname;
    mess.regionid=strRegionid;
    mess.parentid=strParentid;
    return mess;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.sort forKey:@"sort"];
    [aCoder encodeObject:self.regionname forKey:@"regionname"];
    [aCoder encodeObject:self.regionid forKey:@"regionid"];
    [aCoder encodeObject:self.parentid forKey:@"parentid"];
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.sort=[aDecoder decodeObjectForKey:@"sort"];
        self.regionname=[aDecoder decodeObjectForKey:@"regionname"];
        self.regionid=[aDecoder decodeObjectForKey:@"regionid"];
        self.parentid=[aDecoder decodeObjectForKey:@"parentid"];
    }
    return self;
}
@end
