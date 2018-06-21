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

@interface TestScheduleTask : XCTestCase
@property(nonatomic, strong) Schedule * schedule;
@end

/**
 * 每题5分，一共10道题
 */
@implementation TestScheduleTask
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
@end
