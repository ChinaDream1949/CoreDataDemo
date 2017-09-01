//
//  ViewController.m
//  CoreDataDemo
//
//  Created by 欧阳群峰 on 2017/8/31.
//  Copyright © 2017年 肖疆维. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
//插入数据之间导入模型
#import "Clothes.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong,nonatomic)NSMutableArray* dataSoure;
// 申明一个AppDelegate对象属性，来调用被管理对象上下文
@property(strong,nonatomic)AppDelegate * myAppdelegete;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 初始化数组
    self.dataSoure = [NSMutableArray array];
    // 找到AppDelegate.h
    self.myAppdelegete = [UIApplication sharedApplication].delegate;
    // 查询数据
    // 1.NSFetchRequest对象
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Clothes"];
    // 2.设置排序
    // 2.1 设置排序对象
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"price" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    // 执行查询请求
    NSError *error = nil;
    NSArray *result = [self.myAppdelegete.managedObjectContext executeFetchRequest:request error:&error];
    // 给数据源数组添加数据
    [self.dataSoure addObjectsFromArray:result];
}
// 插入数据
- (IBAction)addModel:(id)sender {
    /**
     *  创建实体描述对象
     */
    NSEntityDescription *descrption = [NSEntityDescription entityForName:@"Clothes" inManagedObjectContext:self.myAppdelegete.managedObjectContext];
    // 插入数据
    Clothes *cloth = [[Clothes alloc]initWithEntity:descrption insertIntoManagedObjectContext:self.myAppdelegete.managedObjectContext];
    
    cloth.name = @"Puma";
    int price  = arc4random()%1000+1;
    cloth.price = [NSNumber numberWithInt:price];
    
    // 插入数据源数组
    [self.dataSoure addObject:cloth];
    // 插入UI
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSoure.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    // 对数据管理器的更改进行永久存储
    [self.myAppdelegete saveContext];
}
#pragma mark UITableViewDelegate和UITableViewDataSource方法
/**
 *  返回分区中行数
 *
 *  @param tableView
 *  @param section   区
 *
 *  @return 几个分区
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoure.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Clothes *cloth = self.dataSoure[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@--%@",cloth.name,cloth.price];
    return cell;
}
// 允许tableview可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
// 编辑类型响应
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除数据源
        // 1.取出模型
        Clothes *cloth = self.dataSoure[indexPath.row];
        // 2.1 删除datasoure数据
        [self.dataSoure removeObject:cloth];
        // 2.2 删除数据管理器（coredata）的数据
        [self.myAppdelegete.managedObjectContext deleteObject:cloth];
        // 2.3 将进行的更改进行永久保存
        [self.myAppdelegete saveContext];
        // 删除单元格
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
// 点击cell的方法修改数据
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 1.0 找到模型对象
    Clothes *cloth = self.dataSoure[indexPath.row];
    cloth.name = @"阿迪达斯";
    // 1.1 刷新单元行,更改数据源
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    // 1.2 对数据进行永久保存
    [self.myAppdelegete saveContext];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
