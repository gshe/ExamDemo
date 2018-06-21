package com.migu.schedule;

import com.migu.schedule.constants.ReturnCodeKeys;
import com.migu.schedule.info.TaskInfo;
import org.junit.Assert;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;

public class TestScheduleTask1 extends BaseTest{
    /**
     * 功耗相同并且升序序列最小，10分
     */
    @Test
    public void test()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.registerNode(3);

        actual = schedule.addTask(1, 10);
        actual = schedule.addTask(2, 30);
        actual = schedule.addTask(3, 10);
        actual = schedule.addTask(4, 30);

        actual = schedule.scheduleTask(10);

        Assert.assertEquals(ReturnCodeKeys.E013, actual);

        List<TaskInfo> tasks = new ArrayList<TaskInfo>();

        actual = schedule.queryTaskStatus(tasks);

        Assert.assertEquals(ReturnCodeKeys.E015, actual);

        int expecteds[][] = {
                {1, 1},
                {2, 1},
                {3, 3},
                {4, 3}};

        assertPlanEqual(expecteds, tasks);
    }

    @Test
    public void testDeleteTask1()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.addTask(1, 10);
        actual = schedule.deleteTask(2);
        Assert.assertEquals(ReturnCodeKeys.E012, actual);
    }

    /**
     * 无论怎么调用都会超过阈值，不能触发调度
     */
    @Test
    public void testScheduleTask0()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.registerNode(2);

        actual = schedule.addTask(1, 50);
        actual = schedule.addTask(2, 10);
        actual = schedule.addTask(3, 10);
        actual = schedule.addTask(4, 10);

        actual = schedule.scheduleTask(10);
        actual = schedule.scheduleTask(10);

        Assert.assertEquals(ReturnCodeKeys.E014, actual);
    }
}
