package com.migu.schedule;

import com.migu.schedule.Schedule;
import com.migu.schedule.info.TaskInfo;
import org.junit.Assert;

import java.util.List;

public class BaseTest {
    /**
     * TaskSchedule实例
     */
    protected Schedule schedule = new Schedule();

    /** 测试调度方案是否符合
     *
     * @param expecteds 期望的测试结果
     * @param actual 实际返回结果
     */
    void assertPlanEqual(int expecteds[][], List<TaskInfo> actual)
    {
        Assert.assertEquals(expecteds.length, actual.size());

        for (int i = 0; i < actual.size(); i++)
        {
            Assert.assertEquals(expecteds[i][0], actual.get(i).getTaskId());
            Assert.assertEquals(expecteds[i][1], actual.get(i).getNodeId());
        }
    }
}
