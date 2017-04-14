//
//  ViewController.m
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/29.
//  Copyright © 2015年 gdd. All rights reserved.
//

#import "ViewController.h"
#import "CustomTableView.h"
#import "LoadProvinceData.h"
#import "CityMess.h"
#import "LoadWorkType.h"
#import "WorkType.h"
@interface ViewController ()<CustomTableViewDataSource,CustomTableViewDelegate>{
    LoadProvinceData *loadProvince;
    LoadWorkType *workType;
    NSMutableArray *arrProvinceModel,*arrWorkerFirstModel;
    NSArray *arrOtherType,*arrOrder;
}
@property (strong, nonatomic) NSMutableArray *arrCityModel;
@property (strong, nonatomic) NSMutableArray *arrTownModel;
@property (strong, nonatomic) NSMutableArray *arrWorkerSecondModel;
@property (strong, nonatomic) NSMutableArray *arrWorkerThirdModel;

@property (strong,nonatomic) NSMutableArray *finaData;
@end

@implementation ViewController
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
-(NSMutableArray *)arrWorkerSecondModel{
    if (_arrWorkerSecondModel==nil) {
        _arrWorkerSecondModel=[NSMutableArray array];
    }
    return _arrWorkerSecondModel;
}
-(NSMutableArray *)arrWorkerThirdModel{
    if (_arrWorkerThirdModel==nil) {
        _arrWorkerThirdModel=[NSMutableArray array];
    }
    return _arrWorkerThirdModel;
}
-(NSMutableArray *)finaData{
    if (_finaData==nil) {
        _finaData=[NSMutableArray array];
    }
    return _finaData;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    loadProvince=[[LoadProvinceData alloc]init];
    workType=[[LoadWorkType alloc]init];
    
    // 数据来源
    arrProvinceModel=[loadProvince loadProvinceMess];//得到省份的数据
    arrWorkerFirstModel=[workType  loadProvinceMess];//得到类型的数据
    arrOtherType=@[@"全部",@"点工",@"点包",@"包工",@"全包"];
    arrOrder=@[@"全部",@"按照发布日期排序",@"按照开工日期排序",@"按照距离排序"];
    
    [self showFinaData]; // 将要显示的数据
    
    CustomTableView *cusView=[[CustomTableView alloc]initWithFrame:CGRectMake(0, 20, self.view.width,230)]; //CustomTableView 的高度一定要大于 32(按钮的高度)
    [self.view addSubview:cusView];
    cusView.customViewDataSource=self;
    cusView.customViewDelegate=self;
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    
}
#pragma mark 显示的数据结构(看懂了这个就OK了)
-(void)showFinaData{
    [self.finaData removeAllObjects];
    NSMutableArray *arrProduce=[NSMutableArray arrayWithArray:@[@[arrProvinceModel,self.arrCityModel,self.arrTownModel],@[arrWorkerFirstModel,self.arrWorkerSecondModel,self.arrWorkerThirdModel],@[arrOtherType],@[arrOrder]]];
    [self.finaData addObjectsFromArray:(NSArray *)arrProduce];
}

#pragma mark-CustomTableViewDataSource
// Section的个数
-(NSInteger)showSectionNum:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath{
    return 1;
}
// Row的个数
-(NSInteger)showRowNum:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath{
    NSMutableArray *arrModelData=self.finaData[indexPath.selectBtn];
    NSMutableArray *arrCount=arrModelData[indexPath.selectTableView];
    return arrCount.count;
}
// 显示的cell上面的数据
-(NSString *)showCellData:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath{
    NSString *backFinaStr=@"";
    
    CityMess *cityModel;
    WorkType *workModel;
    
    NSMutableArray *arrMutable=self.finaData[indexPath.selectBtn];
    NSMutableArray *arrDa=arrMutable[indexPath.selectTableView];
    if (indexPath.selectBtn==0) {             // 因为这里我的省份和工种是面向模型开发的,所有要单独进行判断,先得到模型数据
        cityModel=arrDa[indexPath.customRow];
        return cityModel.regionname;
    }
    if (indexPath.selectBtn==1) {
        workModel=arrDa[indexPath.customRow];
        return workModel.wtname;
    }
    else{
        backFinaStr=arrDa[indexPath.customRow];
    }
    return backFinaStr;
}
// 选中的下标,加载下一级显示数据
-(void)selectTableIndexPath:(CustomTableView *)cusView cusIndexPath:(customIndexPath *)indexPath{
    NSMutableArray *arrMutable=self.finaData[indexPath.selectBtn];
    NSMutableArray *arrDa=arrMutable[indexPath.selectTableView];
    
    NSMutableArray *arrAddNextValue=[NSMutableArray array];
    if (indexPath.selectBtn==0) {
        arrAddNextValue=[loadProvince loadCityMess:arrDa[indexPath.customRow]];
        if (indexPath.selectTableView==0) {
            self.arrCityModel=arrAddNextValue;
        }
        if (indexPath.selectTableView==1) {
            self.arrTownModel=arrAddNextValue; // 得到县城数据
        }
    }
    if (indexPath.selectBtn==1) {
        
        arrAddNextValue=[workType loadTownMess:arrDa[indexPath.customRow]];
        
        if (indexPath.selectTableView==0) {
            self.arrWorkerSecondModel=arrAddNextValue;
        }
        if (indexPath.selectTableView==1) {
            self.arrWorkerThirdModel=arrAddNextValue;
        }
    }
    [self showFinaData];
}
@end
