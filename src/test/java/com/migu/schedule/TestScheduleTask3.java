package com.migu.schedule;

import com.migu.schedule.constants.ReturnCodeKeys;
import com.migu.schedule.info.TaskInfo;
import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class TestScheduleTask3 extends BaseTest{
    // /**
    //  * 检查无法调度，10分
    //  */
    // @Test
    // public void test()
    // {
    //     int actual = schedule.init();
    //     schedule.registerNode(1);
    //     schedule.registerNode(2);

    //     schedule.addTask(1, 15);
    //     schedule.addTask(2, 10);
    //     schedule.addTask(3, 35);
    //     schedule.addTask(4, 35);
    //     schedule.addTask(5, 125);
    //     schedule.addTask(6, 115);

    //     actual = schedule.scheduleTask(10);
    //     schedule.deleteTask(5);

    //     actual = schedule.scheduleTask(10);
    //     List<TaskInfo> tasks = new ArrayList<TaskInfo>();
    //     schedule.queryTaskStatus(tasks);

    //     int expecteds[][] = {
    //             {1, 1},
    //             {2, 2},
    //             {3, 1},
    //             {4, 2},
    //             {6, 1}};

    //     assertPlanEqual(expecteds, tasks);

    //     Assert.assertEquals(ReturnCodeKeys.E014, actual);
    // }

    @Test
    public void testScheduleTask3()
    {
        int actual = schedule.init();
        schedule.registerNode(1);
        schedule.registerNode(2);
        
        schedule.addTask(1, 15);
        schedule.addTask(2, 10);
        schedule.addTask(3, 35);
        schedule.addTask(4, 35);
        schedule.addTask(5, 125);
        schedule.addTask(6, 115);
        
        actual = schedule.scheduleTask(10);
        List<TaskInfo> tasks = new ArrayList<TaskInfo>();
        schedule.queryTaskStatus(tasks);
        int expecteds[][] = {
        {1, 1},
        {2, 2},
        {3, 1},
        {4, 2},
        {5, 2},
        {6, 1}};
        assertPlanEqual(expecteds, tasks);

        schedule.deleteTask(5);
        actual = schedule.scheduleTask(10);
        
        Assert.assertEquals(ReturnCodeKeys.E014, actual);
    }
}
