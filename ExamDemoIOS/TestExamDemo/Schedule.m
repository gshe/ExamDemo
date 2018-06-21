//
//  Schedule.m
//  ExamDemo
//
//  Created by George She on 2018/6/8.
//  Copyright © 2018年 CMRead. All rights reserved.
//

#import "Schedule.h"
#import "ReturnCodeKeys.h"

@interface TempSchedule : NSObject
@property(nonatomic, strong) NSMutableArray<TaskInfo *> *scheduleTasks;
@property(nonatomic, assign) int nodeId;
@property(nonatomic, assign) int sum;
@end

@implementation TempSchedule
-(instancetype)init{
    self = [super init];
    if (self){
        self.scheduleTasks = [NSMutableArray array];
    }
    return self;
}
@end

@interface Schedule()
@property(nonatomic, strong) NSMutableArray<TaskInfo *> *allTasks;
@property(nonatomic, strong) NSMutableArray<NSNumber *> *allNodes;
@end

@implementation Schedule
-(int)clean{
    self.allTasks = [[NSMutableArray alloc] init];
    self.allNodes = [[NSMutableArray alloc] init];
    return kE001;
}

-(int)registerNode:(int)nodeId{
    if (nodeId <= 0){
        return kE004;
    }
    
    BOOL isFound = NO;
    for (NSNumber *node in self.allNodes) {
        if (node.intValue == nodeId){
            isFound = YES;
            break;
        }
    }
    
    if (isFound){
        return kE005;
    }
    
    NSNumber *node = [NSNumber numberWithInt:nodeId];
    [self.allNodes addObject:node];
    return kE003;
}

-(int)unregisterNode:(int)nodeId{
    if (nodeId <= 0){
        return kE004;
    }
    
    NSNumber *foundNode = nil;
    for (NSNumber *node in self.allNodes) {
        if (node.intValue == nodeId){
            foundNode = node;
            break;
        }
    }
    
    if (!foundNode){
        return kE007;
    }
    
    [self.allNodes removeObject:foundNode];
    return kE006;
}

-(int)addTask:(int)taskId withConsumption:(int)consumption{
    if (taskId <= 0){
        return kE009;
    }
    
    BOOL isFound = NO;
    for (TaskInfo *task in self.allTasks) {
        if (task.taskId == taskId){
            isFound = YES;
            break;
        }
    }
    
    if (isFound){
        return kE010;
    }
    
    TaskInfo *taskInfo = [[TaskInfo alloc] init];
    taskInfo.taskId = taskId;
    taskInfo.consumption = consumption;
    [self.allTasks addObject:taskInfo];
    return kE008;
}

-(int)deleteTask:(int)taskId{
    if (taskId <= 0){
        return kE009;
    }
    
    TaskInfo *taskInfo = nil;
    for (TaskInfo *task in self.allTasks) {
        if (task.taskId == taskId){
            taskInfo = task;
            break;
        }
    }
    
    if (!taskInfo){
        return kE012;
    }
    
    [self.allTasks removeObject:taskInfo];
    return kE011;
}

-(int)scheduleTask:(int)threshold{
    if (threshold <= 0){
        return kE002;
    }
    
    BOOL scheduleStatus = [self scheduleAlgorithm2WithThreshold:threshold];
    if (scheduleStatus){
        return kE013;
    }else{
        return kE014;
    }
}

-(int)queryTaskStatus:(NSMutableArray<TaskInfo *> *)tasks{
    if (!tasks){
        return kE016;
    }
    NSMutableArray *tmpArray = [self.allTasks mutableCopy];
    [tmpArray sortUsingComparator:^NSComparisonResult(TaskInfo * _Nonnull obj1, TaskInfo * _Nonnull obj2) {
        if (obj1.taskId < obj2.taskId){
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    for (TaskInfo *task in tmpArray) {
        [tasks addObject:task];
    }
    return kE015;
}


#pragma mark schedule algorithm
-(void)swapIfEqual:(NSMutableArray *)array1 array2:(NSMutableArray *)array2{
    for (NSUInteger i = 0; i< array1.count; i++) {
        TaskInfo *task1 = array1[i];
         for (NSUInteger j = 0; j< array2.count; j++) {
             TaskInfo *task2 = array2[j];
             if (task1.consumption == task2.consumption &&
                 task1.taskId > task2.taskId){
                 [array1 replaceObjectAtIndex:i withObject:task2];
                 [array2 replaceObjectAtIndex:j withObject:task1];
             }
         }
    }
}

-(TempSchedule *) findMin2:(NSMutableArray *)xx{
    int min = 99999;
    TempSchedule *ret = nil;
    
    for (TempSchedule *node in xx) {
        if (node.sum < min){
            ret = node;
            min = node.sum;
        }
    }
    
    return ret;
}

- (BOOL) scheduleAlgorithm2WithThreshold:(int)threshold{
    BOOL isValid = YES;
    NSMutableArray *tmpArray = [self.allTasks mutableCopy];
    [tmpArray sortUsingComparator:^NSComparisonResult(TaskInfo * _Nonnull obj1, TaskInfo * _Nonnull obj2) {
        if (obj1.consumption < obj2.consumption){
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    
    [self.allNodes sortUsingComparator:^NSComparisonResult(NSNumber * _Nonnull obj1, NSNumber * _Nonnull obj2) {
        if (obj1.intValue < obj2.intValue){
            return NSOrderedAscending;
        }else{
            return NSOrderedDescending;
        }
    }];
    
    NSMutableArray *scheduleNodes = [NSMutableArray array];
    for (NSUInteger i=0; i<self.allNodes.count; i++) {
        TaskInfo *info =  tmpArray[i];
        TempSchedule *tmp = [[TempSchedule alloc] init];
        tmp.nodeId =self.allNodes[i].intValue;
        [tmp.scheduleTasks addObject:info];
        tmp.sum = info.consumption;
        [scheduleNodes addObject:tmp];
    }
    
    for(NSUInteger i = self.allNodes.count; i < tmpArray.count; i++){
        TaskInfo *task = tmpArray[i];
        TempSchedule *node = [self findMin2:scheduleNodes];
        [node.scheduleTasks addObject:task];
        node.sum += task.consumption;
    }
    
    [scheduleNodes sortUsingComparator:^NSComparisonResult(TempSchedule  *_Nonnull obj1, TempSchedule * _Nonnull obj2) {
        if (obj1.sum < obj2.sum){
            return NSOrderedAscending;
        }else if (obj1.sum == obj2.sum){
            if (obj1.scheduleTasks.count <= obj2.scheduleTasks.count){
                return NSOrderedAscending;
            }else{
                return NSOrderedDescending;
            }
        }
        else{
            return NSOrderedDescending;
        }
    }];
    
    for (int i=0; i< scheduleNodes.count; i++) {
        TempSchedule *tasks1 = scheduleNodes[i];
        tasks1.nodeId = self.allNodes[i].intValue;
        for (int j=i+1; j< scheduleNodes.count; j++) {
            TempSchedule *tasks2 = scheduleNodes[j];
            [self swapIfEqual:tasks1.scheduleTasks array2:tasks2.scheduleTasks];
        }
    }
    
    for (int i=0; i< scheduleNodes.count; i++) {
        TempSchedule *tasks = scheduleNodes[i];
        for (TaskInfo *task in tasks.scheduleTasks) {
            task.nodeId  = tasks.nodeId;
        }
    }
    
    for (NSUInteger i = 0; i<scheduleNodes.count; i++) {
        TempSchedule *a = scheduleNodes[i];
        for (NSUInteger j = i+1; j< scheduleNodes.count; j++) {
            TempSchedule *b = scheduleNodes[j];
            if (abs(a.sum - b.sum) > threshold){
                isValid = NO;
                break;
            }
        }
        
        if (!isValid){
            break;
        }
    }
    
    return isValid;
}
@end
