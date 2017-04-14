//
//  LoadWorkType.m
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/30.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "LoadWorkType.h"
#import <sqlite3.h>
#import "WorkType.h"
@interface LoadWorkType (){
    sqlite3 *dataBase;
    NSMutableArray *arrWorkerFirstModel,*arrWorkerSecondModel,*arrWorkerThirdModel;
}
@property (strong,nonatomic)NSMutableArray *cityArr;
@property (strong,nonatomic)NSMutableArray *townArr;
@end
@implementation LoadWorkType
-(NSMutableArray *)cityArr{
    if (_cityArr==nil) {
        _cityArr=[NSMutableArray array];
    }
    return _cityArr;
}
-(NSMutableArray *)townArr{
    if (_townArr==nil) {
        _townArr=[NSMutableArray array];
    }
    return _townArr;
}

/**
 *  打开数据库 sqlite3_open()
 */
- (void)openDB{
    //保存sqlite的沙盒路径
    //    NSString *strPath=workerTypePath;
    NSString *strPath=[[NSBundle mainBundle]pathForResource:@"WorkerTypeDB.sqlite" ofType:nil];//本地数据库的路径
    // 如果数据库不存在,新建并打开一个数据库，否则直接打开
    sqlite3_open(strPath.UTF8String, &dataBase); // UTF8String是将 OC中的NSString转化成 C中的char
}
/**
 * 创建表和添加字段 qlite3_exec(单步sql指令)
 */
-(void)createTable{
    char *errMess;
    NSString *strSQL=@"CREATE TABLE IF NOT EXISTS workType (wtid TEXT, wtname TEXT, parentid TEXT, sort TEXT)";//创建表(Province)里面有4个字段
    sqlite3_exec(dataBase, strSQL.UTF8String, NULL, NULL, &errMess);
}
/**
 * 给字段里面添加数据
 */
-(void)insertData:(WorkType *)workType{
    char *errMess;
    //给表里面的字段插入数据
    NSString *strSQL=[NSString stringWithFormat:@"INSERT INTO workType (wtid, wtname, parentid, sort) VALUES ('%@', '%@', '%@', '%@')", workType.wtid, workType.wtname,workType.parentid,workType.sort];//字符串用:'%@'  int用:%zi
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
            
            WorkType *proModel=[WorkType workTypeMess:strSort wtname:strRegionname parentid:strRegionid sort:strParentid];//返回模型数据
            [cityMessModelArrFina addObject:proModel];
        }
    }
    else{
        NSLog(@"SQL语句错误");
    }
    //     4. 释放句柄
    sqlite3_finalize(stmt);
    sqlite3_close(dataBase);//查询完就关闭数据库
    
    return cityMessModelArrFina;
}
//返回的SQLite3里面查询的结果
-(NSMutableArray *)finaModelData:(NSString *)SQLStr{
    [self openDB];
    return [self finaResult:SQLStr];
}
/** 得到查询的查询结果 */
-(NSMutableArray *)selectAllWorkTypeResult:(NSString *)SQLStr{
    NSMutableArray *getData=[self finaModelData:SQLStr];
    return getData;
}
/** 工种第一层数据 */
-(NSMutableArray *)loadProvinceMess{
    arrWorkerFirstModel=[self selectAllWorkTypeResult:@"SELECT rowid, * FROM workType WHERE parentid =0"];
    WorkType *insertFirstData=[WorkType workTypeMess:@"-1" wtname:@"全部" parentid:@"0" sort:@"0"];//返回模型数据
    [arrWorkerFirstModel insertObject:insertFirstData atIndex:0];
    
    return arrWorkerFirstModel;
}
/** 工种第二层数据 */
-(NSMutableArray *)loadCityMess:(WorkType *)province{
    WorkType *insertFirst=[WorkType workTypeMess:province.wtid wtname:[NSString stringWithFormat:@"全部-%@",province.wtname] parentid:province.parentid sort:province.sort];
    arrWorkerSecondModel=[self selectAllWorkTypeResult:[NSString stringWithFormat:@"SELECT rowid, * FROM workType WHERE parentid =%@",province.wtid]];
    [arrWorkerSecondModel insertObject:insertFirst atIndex:0];
    
    return arrWorkerSecondModel;
}
/** 工种第三层数据 */
-(NSMutableArray *)loadTownMess:(WorkType *)city{
    WorkType *insertSecond=[WorkType workTypeMess:city.wtid wtname:[NSString stringWithFormat:@"全部-%@",city.wtname] parentid:city.parentid sort:city.sort]; //将要加入的数据(就是拼接选中的数据Model)
    arrWorkerThirdModel=[self selectAllWorkTypeResult:[NSString stringWithFormat:@"SELECT rowid, * FROM workType WHERE parentid =%@",city.wtid]];
    [arrWorkerThirdModel insertObject:insertSecond atIndex:0];
    
    return arrWorkerThirdModel;
}
/** 跟新数据 */
-(void)UpdataMess:(NSString *)strSQL{
    char *errMess;
    sqlite3_exec(dataBase, strSQL.UTF8String, NULL, NULL, &errMess);
}
/** 添加新的工种信息 */
-(void)addNewWorkerTypeMess:(NSArray *)typeMess{
    [self openDB];//先删除表workType,再新建表workType 最后插入全部的输入
    [self UpdataMess:[NSString stringWithFormat:@"drop table 'workType'"]];
    [self createTable];
    for (WorkType *typeModel in typeMess) {
        [self insertData:typeModel];
    }
}
@end