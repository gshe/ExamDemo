package com.migu.schedule;

import com.migu.schedule.constants.ReturnCodeKeys;
import org.junit.Assert;
import org.junit.Test;

/**
 * 每题5分，一共10道题
 */
public class TestScheduleTask extends BaseTest{

    @Test
    public void testInit()
    {
        int actual = schedule.init();
        Assert.assertEquals(ReturnCodeKeys.E001, actual);
    }

    @Test
    public void testRegisterNode1()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        Assert.assertEquals(ReturnCodeKeys.E003, actual);
    }

    @Test
    public void testRegisterNode2()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(-1);
        Assert.assertEquals(ReturnCodeKeys.E004, actual);
    }

    @Test
    public void testRegisterNode3()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.registerNode(1);
        Assert.assertEquals(ReturnCodeKeys.E005, actual);
    }

    @Test
    public void testUnregisterNode1()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.unregisterNode(1);
        Assert.assertEquals(ReturnCodeKeys.E006, actual);
    }

    @Test
    public void testUnregisterNode2()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.unregisterNode(2);
        Assert.assertEquals(ReturnCodeKeys.E007, actual);
    }

    @Test
    public void testAddTask0()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.addTask(1, 10);
        Assert.assertEquals(ReturnCodeKeys.E008, actual);
    }

    @Test
    public void testAddTask1()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.addTask(0, 10);
        Assert.assertEquals(ReturnCodeKeys.E009, actual);
    }

    @Test
    public void testAddTask2()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.addTask(1, 10);
        actual = schedule.addTask(1, 10);
        Assert.assertEquals(ReturnCodeKeys.E010, actual);
    }

    @Test
    public void testDeleteTask0()
    {
        int actual = schedule.init();
        actual = schedule.registerNode(1);
        actual = schedule.addTask(1, 10);
        actual = schedule.deleteTask(1);
        Assert.assertEquals(ReturnCodeKeys.E011, actual);
    }
}
