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

@interface TestScheduleTask1 : XCTestCase
@property(nonatomic, strong) Schedule * schedule;
@end

@implementation TestScheduleTask1
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

- (void)  test
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule registerNode:3];
    
    [self.schedule addTask:1 withConsumption:10];
    [self.schedule addTask:2 withConsumption:30];
    [self.schedule addTask:3 withConsumption:10];
    [self.schedule addTask:4 withConsumption:30];
    
    actual = [self.schedule scheduleTask:10];
    XCTAssertEqual(kE013, actual);
    
    NSMutableArray *tasks = [[NSMutableArray alloc] init];
    actual = [self.schedule queryTaskStatus:tasks];
    XCTAssertEqual(kE015, actual);
    
    NSArray *expecteds = @[
        @[@1, @1],
        @[@2, @1],
        @[@3, @3],
        @[@4, @3]];
    [self assertPlanEqual:expecteds actual:tasks];
}

- (void) testDeleteTask1
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule addTask:1 withConsumption:10];
    actual = [self.schedule deleteTask:2];
    XCTAssertEqual(kE012, actual);
}

- (void)  testScheduleTask0
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule registerNode:2];
    
    actual = [self.schedule addTask:1 withConsumption:50];
    actual = [self.schedule addTask:2 withConsumption:10];
    actual = [self.schedule addTask:3 withConsumption:10];
    actual = [self.schedule addTask:4 withConsumption:10];
    
    actual = [self.schedule scheduleTask:10];
     actual = [self.schedule scheduleTask:10];
    XCTAssertEqual(kE014, actual);
}
@end
