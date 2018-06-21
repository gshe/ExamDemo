package com.migu.schedule.info;

import java.util.ArrayList;
import java.util.List;

public class ScheduleNode {
    private  int sum;
    private int nodeId;
    private List<TaskInfo> taskInfoList = new ArrayList<TaskInfo>();

    public int getSum() {
        return sum;
    }

    public void setSum(int sum) {
        this.sum = sum;
    }

    public int getNodeId() {
        return nodeId;
    }

    public void setNodeId(int nodeId) {
        this.nodeId = nodeId;
    }

    public List<TaskInfo> getTaskInfoList() {
        return taskInfoList;
    }

    public void setTaskInfoList(List<TaskInfo> taskInfoList) {
        this.taskInfoList = taskInfoList;
    }
}
