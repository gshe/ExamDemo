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

@interface TestScheduleTask2 : XCTestCase
@property(nonatomic, strong) Schedule * schedule;
@end

@implementation TestScheduleTask2
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

/**
 * 任务数平均，并且功耗差值小，升序序列，服务节点小的节点运行任务数小，10分
 */

- (void)  test
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:7];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule registerNode:6];
    
    [self.schedule addTask:1 withConsumption:2];
    [self.schedule addTask:3 withConsumption:3];
    [self.schedule addTask:2 withConsumption:14];
    [self.schedule addTask:5 withConsumption:6];
    [self.schedule addTask:4 withConsumption:16];
    [self.schedule addTask:7 withConsumption:7];
    [self.schedule addTask:6 withConsumption:4];
    
    actual = [self.schedule scheduleTask:10];
    XCTAssertEqual(kE013, actual);
    
    NSMutableArray *tasks = [[NSMutableArray alloc] init];
    actual = [self.schedule queryTaskStatus:tasks];
    XCTAssertEqual(kE015, actual);
    
    NSArray *expecteds = @[
        @[@1, @7],
        @[@2, @1],
        @[@3, @1],
        @[@4, @7],
        @[@5, @6],
        @[@6, @6],
        @[@7, @6]];
    [self assertPlanEqual:expecteds actual:tasks];
}

@end
