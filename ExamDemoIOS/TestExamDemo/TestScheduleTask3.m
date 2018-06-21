//
//  BaseTast.m
//  TestExamDemo
//
//  Created by George She on 2018/6/8.
//  Copyright © 2018年 CMRead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Schedule.h"
#import "ReturnCodeKeys.h"

@interface TestScheduleTask3 : XCTestCase
@property(nonatomic, strong) Schedule * schedule;
@end

@implementation TestScheduleTask3
/** 测试调度方案是否符合
 *
 * @param expecteds 期望的测试结果
 * @param actual 实际返回结果
 */
-(void) assertPlanEqual:(NSArray *)expecteds actual:(NSMutableArray<TaskInfo *> *)actual
{
    XCTAssertEqual(expecteds.count, actual.count);
    for (int i = 0; i < actual.count; i++)
    {
        NSArray* arr = expecteds[i];
        XCTAssertEqual(((NSNumber *)arr[0]).intValue, actual[i].taskId);
        XCTAssertEqual(((NSNumber *)arr[1]).intValue, actual[i].nodeId);
    }
}

- (void)setUp {
    [super setUp];
    self.schedule = [[Schedule alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

// /**
//  * 检查无法调度，10分
//  */
- (void) test
{
    int actual = [self.schedule clean];
    [self.schedule registerNode:1];
    [self.schedule registerNode:2];
    
    [self.schedule addTask:1 withConsumption:15];
    [self.schedule addTask:2 withConsumption:10];
    [self.schedule addTask:3 withConsumption:35];
    [self.schedule addTask:4 withConsumption:35];
    [self.schedule addTask:5 withConsumption:125];
    [self.schedule addTask:6 withConsumption:115];
    
    actual = [self.schedule scheduleTask:10];
    NSMutableArray *tasks = [[NSMutableArray alloc] init];
    [self.schedule queryTaskStatus:tasks];
    NSArray *expecteds = @[
                           @[@1, @1],
                           @[@2, @2],
                           @[@3, @1],
                           @[@4, @2],
                           @[@5, @2],
                           @[@6, @1]];
    [self assertPlanEqual:expecteds actual:tasks];
    
    [self.schedule deleteTask:5];
    
    actual = [self.schedule scheduleTask:10];
    XCTAssertEqual(kE014, actual);
    
}
@end
