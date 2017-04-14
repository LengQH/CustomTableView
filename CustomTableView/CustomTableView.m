//
//  CustomTableView.m
//  CustomTableView
//
//  Created by 冷求慧 on 15/12/29.
//  Copyright © 2015年 gdd. All rights reserved.
//
#import "CustomTableView.h"
#import "CustomBtn.h"
#define btnH 32 // 按钮的高度
#define btnTitleFont [UIFont systemFontOfSize:11.0] //按钮文字的字体大小
#define cellTitleFont [UIFont systemFontOfSize:14.0] //Cell显示的字体的大小

@interface customIndexPath(){  //对customIndexPath这个类 进行扩展
}
@end
@implementation customIndexPath //实现customIndexPath类中的方法
-(instancetype)initWithIndexPath:(NSInteger)selectBtnParam  selectTable:(NSInteger)selectTableParam selecSection:(NSInteger)sectionParam selectRow:(NSInteger)customRowParam{
    if(self=[super init]){
        self.selectBtn=selectBtnParam;
        self.selectTableView=selectTableParam;
        self.customSection=sectionParam;
        self.customRow=customRowParam;
    }
    return self;
}
+(instancetype)customIndexPath:(NSInteger)selectBtnParam  selectTable:(NSInteger)selectTableParam selecSection:(NSInteger)sectionParam selectRow:(NSInteger)customRowParam{
    return [[customIndexPath alloc]initWithIndexPath:selectBtnParam selectTable:selectTableParam selecSection:sectionParam selectRow:customRowParam];
}
@end
@interface CustomTableView()<UITableViewDelegate,UITableViewDataSource>{ //,类扩展是一个匿名的分类
    UITableView *tableViewOne,*tableViewTwo,*tableViewThree;
    CustomBtn *cusBtn;
}
/** 选中的按钮 */
@property (nonatomic,weak)UIButton *selectBtn;
/** 点击按钮是否创建TableView */
@property (nonatomic,assign)BOOL isCreateTable;
@end

@implementation CustomTableView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self createButton];
    }
    return self;
}
//创建UIButton
-(void)createButton{
    NSArray *arrBtnData=@[@"区域",@"工种",@"类型",@"排序",];
    for (int i=0; i<arrBtnData.count; i++) {
        cusBtn=[[CustomBtn alloc]initWithFrame:CGRectMake((self.width/4)*i, 0, self.width/4, btnH)];
        cusBtn.tag=i;
        cusBtn.titleLabel.font=btnTitleFont;
        cusBtn.titleLabel.lineBreakMode=NSLineBreakByCharWrapping;
        [cusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cusBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [cusBtn setTitle:arrBtnData[i] forState:UIControlStateNormal];
        [cusBtn setTitle:arrBtnData[i] forState:UIControlStateHighlighted];
        [cusBtn setImage:[UIImage imageNamed:@"button_up"] forState:UIControlStateNormal];
        [cusBtn setImage:[UIImage imageNamed:@"button_up"] forState:UIControlStateHighlighted];
        [cusBtn setBackgroundColor:[UIColor whiteColor]];
        [cusBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cusBtn];
    }
}
// 点击了按钮
-(void)clickBtn:(UIButton *)button{
    //都是一个目的(赋值),但是赋值方式不一样,前2个都是通过 重写set方法,后一个就直接是通过成员变量
//    [self setSelectBtn:button];
//    self.selectBtn=button;
    _selectBtn=button;
    
    self.isCreateTable=!self.isCreateTable;
    if(self.isCreateTable){
        [self createView];
    }else{
        [self removeTableView];
    }
}
//创建相关的View
-(void)createView{
    [self removeTableView];
    tableViewOne=[[UITableView alloc]initWithFrame:CGRectMake(0, btnH, self.width, self.height-btnH) style:UITableViewStylePlain];
    tableViewOne.tag=0;
    tableViewOne.delegate=self;
    tableViewOne.dataSource=self;
    [self addSubview:tableViewOne];
}
#pragma  mark-tableView-dataSource(数据源方法)
// Section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    customIndexPath *tableNum=[self deliverTableView:tableView];
    if ([self.customViewDataSource respondsToSelector:@selector(showSectionNum:cusIndexPath:)]) {
        NSInteger showNum=[self.customViewDataSource showSectionNum:self cusIndexPath:tableNum];
        return showNum;
    }
    else{
        return 0;
    }
}
// Row的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    customIndexPath *sectionNum=[self deliverTableView:tableView selectSection:section];
    if ([self.customViewDataSource respondsToSelector:@selector(showRowNum:cusIndexPath:)]) {
        return [self.customViewDataSource showRowNum:self cusIndexPath:sectionNum];
    }
    return 0;
}
//显示的UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *strCellID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:strCellID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCellID];
    }
    customIndexPath *sectionRow=[self deliverTableView:tableView selectSection:indexPath.section selectRow:indexPath.row];
    if ([self.customViewDataSource respondsToSelector:@selector(showCellData:cusIndexPath:)]) {
        cell.textLabel.text=[self.customViewDataSource showCellData:self cusIndexPath:sectionRow];
    }
    cell.textLabel.font=cellTitleFont;
    return cell;
}
#pragma mark-tableView-delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.customViewDelegate respondsToSelector:@selector(selectTableIndexPath:cusIndexPath:)]){
        customIndexPath *customObject=[self deliverTableView:tableView selectSection:indexPath.section selectRow:indexPath.row];
        [self.customViewDelegate selectTableIndexPath:self cusIndexPath:customObject];
    }
    UITableViewCell *selectCell=[tableView cellForRowAtIndexPath:indexPath];
    [_selectBtn setTitle:selectCell.textLabel.text forState:UIControlStateNormal]; //选中Cell给按钮重新赋值
    [_selectBtn setTitle:selectCell.textLabel.text forState:UIControlStateHighlighted]; //选中Cell给按钮重新赋值
    
    if (indexPath.row==0) {
        [self removeTableView];
        self.isCreateTable=!self.isCreateTable;
    }
    else{
        if (tableView==tableViewOne) {
            
            if ((self.selectBtn.tag==2||self.selectBtn.tag==3)) { //按钮为 类型 和排序 不用创建2级和3级TableView
                [self removeTableView];
                self.isCreateTable=!self.isCreateTable;
            }
            else{
                [self createCityTableView];
            }
        }
        if (tableView==tableViewTwo) {
            [self createTownTableView];
        }
        if (tableView==tableViewThree){
            [self removeTableView];
            self.isCreateTable=!self.isCreateTable;
        }
    }
}
//创建市级TableView
-(void)createCityTableView{
    tableViewOne.frame=CGRectMake(0, btnH, self.width/2, self.height-btnH);
    [tableViewTwo removeFromSuperview];
    tableViewTwo=[[UITableView alloc]initWithFrame:CGRectMake(self.width/2, btnH, self.width/2, self.height-btnH) style:UITableViewStylePlain];
    tableViewTwo.tag=1;
    
    tableViewTwo.delegate=self;
    tableViewTwo.dataSource=self;
    [self addSubview:tableViewTwo];
}
//创建县级TableView
-(void)createTownTableView{
    tableViewOne.frame=CGRectMake(0, btnH, self.width/3, self.height-btnH);
    tableViewTwo.frame=CGRectMake(self.width/3, btnH, self.width/3, self.height-btnH);
    [tableViewThree removeFromSuperview];
    tableViewThree=[[UITableView alloc]initWithFrame:CGRectMake(self.width/3*2, btnH, self.width/3, self.height-btnH) style:UITableViewStylePlain];
    tableViewThree.tag=2;
    tableViewThree.delegate=self;
    tableViewThree.dataSource=self;
    [self addSubview:tableViewThree];
}
#pragma mark TableView的标识
-(customIndexPath *)deliverTableView:(UITableView *)selectTableView{
    return [[customIndexPath alloc]initWithIndexPath:self.selectBtn.tag selectTable:0 selecSection:0 selectRow:0];
}
#pragma mark Section的标识
-(customIndexPath *)deliverTableView:(UITableView *)selectTableView selectSection:(NSInteger)section{
    return [[customIndexPath alloc]initWithIndexPath:self.selectBtn.tag selectTable:selectTableView.tag selecSection:section selectRow:0];
}
#pragma mark Section和Row的标识
-(customIndexPath *)deliverTableView:(UITableView *)selectTableView selectSection:(NSInteger)section selectRow:(NSInteger)row{
    return [[customIndexPath alloc]initWithIndexPath:self.selectBtn.tag selectTable:selectTableView.tag selecSection:section selectRow:row];
}
//移除3个TableView
-(void)removeTableView{
    for (UIView *deleteView in self.subviews) {
        if ([deleteView isKindOfClass:[UITableView class]]) {
            [deleteView removeFromSuperview];
        }
    }
}
@end
