//
//  TestExamDemo.m
//  TestExamDemo
//
//  Created by George She on 2018/6/8.
//  Copyright © 2018年 CMRead. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Schedule.h"
#import "ReturnCodeKeys.h"

@interface TestExamDemo : XCTestCase
@property(nonatomic, strong) Schedule * schedule;
@end

@implementation TestExamDemo
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

- (void)testInit {
    int actual = [self.schedule clean];
    XCTAssertEqual(kE001, actual);
}

- (void) testRegisterNode1{
     int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
     XCTAssertEqual(kE003, actual);
}

- (void) testRegisterNode2
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:-1];
    XCTAssertEqual(kE004, actual);
}

- (void) testRegisterNode3
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule registerNode:1];
    XCTAssertEqual(kE005, actual);
}

- (void) testUnregisterNode1
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule unregisterNode:1];
    XCTAssertEqual(kE006, actual);
}

- (void) testUnregisterNode2
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule unregisterNode:2];
    XCTAssertEqual(kE007, actual);
}

- (void) testAddTask0
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule addTask:1 withConsumption:10];
    XCTAssertEqual(kE008, actual);
}

- (void) testAddTask1
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule addTask:0 withConsumption:10];
    XCTAssertEqual(kE009, actual);
}

- (void) testAddTask2
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule addTask:1 withConsumption:10];
    actual = [self.schedule addTask:1 withConsumption:10];
    XCTAssertEqual(kE010, actual);
}

- (void) testDeleteTask0
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule addTask:1 withConsumption:10];
    actual = [self.schedule deleteTask:1];
    XCTAssertEqual(kE011, actual);
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
    actual = [self.schedule registerNode:7];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule registerNode:6];
    
    [self.schedule addTask:1 withConsumption:2];
    [self.schedule addTask:2 withConsumption:14];
    [self.schedule addTask:3 withConsumption:4];
    [self.schedule addTask:4 withConsumption:16];
    [self.schedule addTask:5 withConsumption:6];
    [self.schedule addTask:6 withConsumption:5];
    [self.schedule addTask:7 withConsumption:3];
    
    actual = [self.schedule scheduleTask:10];
    XCTAssertEqual(kE013, actual);
    
    NSMutableArray *tasks = [[NSMutableArray alloc] init];
    actual = [self.schedule queryTaskStatus:tasks];
    XCTAssertEqual(kE015, actual);
    
    NSArray *expecteds = @[
        @[@1, @7],
        @[@2, @6],
        @[@3, @7],
        @[@4, @1],
        @[@5, @7],
        @[@6, @7],
        @[@7, @6]];
    [self assertPlanEqual:expecteds actual:tasks];
}

- (void)  testScheduleTask1
{
    int actual = [self.schedule clean];
    actual = [self.schedule registerNode:1];
    actual = [self.schedule registerNode:3];
    
    actual = [self.schedule addTask:1 withConsumption:30];
    actual = [self.schedule addTask:2 withConsumption:30];
    actual = [self.schedule addTask:3 withConsumption:30];
    actual = [self.schedule addTask:4 withConsumption:30];
    
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

- (void) testScheduleTask3
{
    int actual = [self.schedule clean];
    [self.schedule registerNode:1];
    [self.schedule registerNode:2];
    
    [self.schedule addTask:1 withConsumption:15];
    [self.schedule addTask:2 withConsumption:10];
    [self.schedule addTask:3 withConsumption:30];
    [self.schedule addTask:4 withConsumption:35];
    [self.schedule addTask:5 withConsumption:125];
    [self.schedule addTask:6 withConsumption:115];
    
    actual = [self.schedule scheduleTask:10];
    [self.schedule deleteTask:5];
    
    actual = [self.schedule scheduleTask:10];
    XCTAssertEqual(kE014, actual);
    
}
@end
