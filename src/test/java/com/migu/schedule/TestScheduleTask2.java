package com.migu.schedule;

import com.migu.schedule.constants.ReturnCodeKeys;
import com.migu.schedule.info.TaskInfo;
import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class TestScheduleTask2 extends BaseTest {
    /**
     * 任务数平均，并且功耗差值小，升序序列，服务节点小的节点运行任务数小，10分
     */
    @Test
    public void test()
    {
        int actual = schedule.init();
        schedule.registerNode(7);
        schedule.registerNode(1);
        schedule.registerNode(6);

        schedule.addTask(1, 2);
        schedule.addTask(3, 3);
        schedule.addTask(2, 14);
        schedule.addTask(5, 6);
        schedule.addTask(4, 16);
        schedule.addTask(7, 7);
        schedule.addTask(6, 4);

        actual = schedule.scheduleTask(10);

        Assert.assertEquals(ReturnCodeKeys.E013, actual);

        List<TaskInfo> tasks = new ArrayList<TaskInfo>();

        actual = schedule.queryTaskStatus(tasks);

        Assert.assertEquals(ReturnCodeKeys.E015, actual);

        int expecteds[][] = {
                {1, 7},
                {2, 1},
                {3, 1},
                {4, 7},
                {5, 6},
                {6, 6},
                {7, 6}};

        assertPlanEqual(expecteds, tasks);
    }
}
