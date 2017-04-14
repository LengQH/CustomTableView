//
//  LoadProvinceData.m
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/30.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "LoadProvinceData.h"
#import <sqlite3.h>
#import "CityMess.h"
@interface LoadProvinceData(){
    sqlite3 *dataBase;
    NSMutableArray *arrProvinceModel;
}
@property (strong,nonatomic)NSMutableArray *arrCityModel;
@property (strong,nonatomic)NSMutableArray *arrTownModel;
@end
@implementation LoadProvinceData
-(NSMutableArray *)arrCityModel{
    if (_arrCityModel==nil) {
        _arrCityModel=[NSMutableArray array];
    }
    return _arrCityModel;
}
-(NSMutableArray *)arrTownModel{
    if (_arrTownModel==nil) {
        _arrTownModel=[NSMutableArray array];
    }
    return _arrTownModel;
}
/**
 *  打开数据库 sqlite3_open()
 */
- (void)openDB
{
    //保存sqlite的沙盒路径
    //    NSString *strPath=provincePath;
    
    NSString *strPath=[[NSBundle mainBundle]pathForResource:@"ProvinceDB.sqlite" ofType:nil];//本地存放的路径
    // 如果数据库不存在,新建并打开一个数据库，否则直接打开
    sqlite3_open(strPath.UTF8String, &dataBase); // UTF8String是将 OC中的NSString转化成 C中的char
}
/**
 * 创建表和添加字段 qlite3_exec(单步sql指令)
 */
-(void)createTable{
    char *errMess;
    NSString *strSQL=@"CREATE TABLE IF NOT EXISTS Province (sort TEXT, regionname TEXT, regionid TEXT, parentid TEXT)";//创建表(Province)里面有4个字段
    sqlite3_exec(dataBase, strSQL.UTF8String, NULL, NULL, &errMess);
}
/**
 * 给字段里面添加数据
 */
-(void)insertData:(CityMess *)provinceModel{
    char *errMess;
    //给表里面的字段插入数据
    NSString *strSQL=[NSString stringWithFormat:@"INSERT INTO Province (sort, regionname, regionid, parentid) VALUES ('%@', '%@', '%@', '%@')", provinceModel.sort, provinceModel.regionname,provinceModel.regionid,provinceModel.parentid];//字符串用:'%@'  int用:%zi
    sqlite3_exec(dataBase, strSQL.UTF8String, NULL, NULL, &errMess);
}
/**
 * 查询结果
 */
-(NSMutableArray *)finaResult:(NSString *)SQLStr{
    NSMutableArray *cityMessModelArrFina=[NSMutableArray array]; //用来得到返回的数据,不能用全局变量,否则就会叠加数据
    // 1. 评估准备SQL语法是否正确
    sqlite3_stmt *stmt = NULL;
    
    NSString *strSQL=SQLStr; //@"select  *from Province";
    if (sqlite3_prepare_v2(dataBase, strSQL.UTF8String, -1, &stmt, nil) == SQLITE_OK) {
        //        NSLog(@"select ok");
        while (sqlite3_step(stmt) ==SQLITE_ROW) {
            //            int _idOne =sqlite3_column_int(stmt,0); //得到d对应的ID
            
            //得到第一个字段的值
            char *sort = (char*)sqlite3_column_text(stmt,1);//得到第一个字段的值(char)
            NSString *strSort = [[NSString alloc]initWithUTF8String:sort];//将char转为NSString
            //同理得到第二个字段的值
            char *regionname=(char*)sqlite3_column_text(stmt, 2);
            NSString *strRegionname=[[NSString alloc]initWithUTF8String:regionname];
            //同理得到得到第三个字段的值
            char *regionid=(char*)sqlite3_column_text(stmt, 3);
            NSString *strRegionid=[[NSString alloc]initWithUTF8String:regionid];
            //同理得到得到第四个字段的值
            char *parentid=(char*)sqlite3_column_text(stmt, 4);
            NSString *strParentid=[[NSString alloc]initWithUTF8String:parentid];
            
            
            CityMess *proModel=[CityMess cityMess:strSort regionname:strRegionname regionid:strRegionid parentid:strParentid];//返回模型数据
            [cityMessModelArrFina addObject:proModel];
        }
    }
    else{
        NSLog(@"SQL语句错误");
    }
    // 4. 释放句柄
    sqlite3_finalize(stmt);
    sqlite3_close(dataBase);//查询完就关闭数据库
    
    return cityMessModelArrFina;
}
//返回的SQLite3里面查询的结果
-(NSMutableArray *)finaModelData:(NSString *)SQLStr{
    [self openDB];
    return [self finaResult:SQLStr];
}
/** 条件查询省市县 */
-(NSMutableArray *)selectData:(NSString *)SQLStr{
    NSMutableArray *getData=[self finaModelData:SQLStr];
    return getData;
}

/** 得到省份的数据 */
-(NSMutableArray *)loadProvinceMess{
    arrProvinceModel=[self selectData:@"SELECT rowid, * FROM Province WHERE parentid =0"];//省份模型数组
    CityMess *insertProvinceData=[CityMess cityMess:@"0" regionname:@"全部" regionid:@"-1" parentid:@"0"];//插入一条数据
    [arrProvinceModel insertObject:insertProvinceData atIndex:0];
    
    return arrProvinceModel;
}
/** 得到市级的数据 */
-(NSMutableArray *)loadCityMess:(CityMess *)province{
    CityMess *insertProvince=[CityMess cityMess:province.sort regionname:[NSString stringWithFormat:@"全部-%@",province.regionname] regionid:province.regionid parentid:province.parentid];//插入省份数据
    
    self.arrCityModel=[self selectData:[NSString stringWithFormat:@"SELECT rowid, * FROM Province WHERE parentid =%@",province.regionid]];//查询数据库得到市级模型数组
    [self.arrCityModel insertObject:insertProvince atIndex:0];
    
    return self.arrCityModel;
}
/** 得到县级的数据 */
-(NSMutableArray *)loadTownMess:(CityMess *)city{
    CityMess *insertCity=[CityMess cityMess:city.sort regionname:[NSString stringWithFormat:@"全部-%@",city.regionname] regionid:city.regionid parentid:city.parentid];//插入城市数据
    
    self.arrTownModel=[self selectData:[NSString stringWithFormat:@"SELECT rowid, * FROM Province WHERE parentid =%@",city.regionid]];//查询数据库得到市级模型数组
    [self.arrTownModel insertObject:insertCity atIndex:0];
    return self.arrTownModel;
}
/** 跟新表里面的数据 */
-(void)UpdataMess:(NSString *)strSQL{
    char *errMess;
    sqlite3_exec(dataBase, strSQL.UTF8String, NULL, NULL, &errMess);
}
/** 添加新的省份数据 */
-(void)addNewData:(NSArray *)city{
    [self openDB];
    for (CityMess *messModel in city) {  //先判断是否有这条数据,有的话就替换,没有的话就插入
        if ([self isExits:messModel]) {//存在就代替
            [self UpdataMess:[NSString stringWithFormat:@"UPDATE Province SET sort = '%@', regionname = '%@', parentid = '%@' WHERE regionid = '%@'",messModel.sort,messModel.regionname,messModel.parentid,messModel.regionid]];
        }
        else{
            [self insertData:messModel];//不存在就插入
        }
    }
}
/** 是否存在该数据 */
-(BOOL)isExits:(CityMess *)mess{
    NSMutableArray *arrData=[self selectData:[NSString stringWithFormat:@"SELECT rowid, * FROM Province WHERE regionid =%@",mess.regionid]];
    if (arrData.count>0) {
        return YES;
    }
    else{
        return NO;
    }
}
@end
