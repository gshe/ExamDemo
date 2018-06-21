package com.migu.schedule;


import com.migu.schedule.constants.ReturnCodeKeys;
import com.migu.schedule.info.ScheduleNode;
import com.migu.schedule.info.TaskInfo;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

//按照TaskId升序排列
class SortTaskInfoByTaskId implements Comparator {
    public int compare(Object o1, Object o2) {
        TaskInfo s1 = (TaskInfo) o1;
        TaskInfo s2 = (TaskInfo) o2;

        if (s1.getTaskId() < s2.getTaskId()) {
            return -1;
        }else if (s1.getTaskId() > s2.getTaskId()){
            return 1;
        }else{
            return 0;
        }
    }
}
//按照consumption降序排列
class SortTaskInfoByConsumption implements Comparator {
    public int compare(Object o1, Object o2) {
        TaskInfo s1 = (TaskInfo) o1;
        TaskInfo s2 = (TaskInfo) o2;
        if (s1.getConsumption() > s2.getConsumption()) {
            return -1;
        }else if (s1.getConsumption() < s2.getConsumption()) {
            return 1;
        }else{
            return 0;
        }
    }
}
//按照sum大小降序排列，如果sum一样，则节点上任务多的分配到 节点Id大的节点上
class SortScheduleNode implements Comparator {
    public int compare(Object o1, Object o2) {
        ScheduleNode s1 = (ScheduleNode) o1;
        ScheduleNode s2 = (ScheduleNode) o2;
        if (s1.getSum() > s2.getSum()) {
            return 1;
        }else if (s1.getSum() == s2.getSum()) {
            if (s1.getTaskInfoList().size() > s2.getTaskInfoList().size()){
                return 1;
            }else{
                return -1;
            }
        }else{
            return -1;
        }
    }
}
//按照NodeId升序排列
class SortNodeListByNodeId implements Comparator {
    public int compare(Object o1, Object o2) {
        Integer n1 = (Integer) o1;
        Integer n2 = (Integer) o2;
        if (n1 > n2) {
            return 1;
        }else if (n1 < n2) {
            return -1;
        }else{
            return 0;
        }
    }
}

/*
*类名和方法不能修改
 */
public class Schedule {
    private List<TaskInfo> taskInfoList;
    private List<Integer> nodeList;


    public int init() {
        taskInfoList = new ArrayList<TaskInfo>();
        nodeList = new ArrayList<Integer>();
        return ReturnCodeKeys.E001;
    }


    public int registerNode(int nodeId) {
        if (nodeId <= 0){
            return ReturnCodeKeys.E004;
        }

        boolean isFound = false;
        for (Integer node:nodeList
             ) {
            if (node == nodeId){
                isFound = true;
                break;
            }
        }

        if (isFound){
            return ReturnCodeKeys.E005;
        }
        nodeList.add(nodeId);
        return ReturnCodeKeys.E003;
    }

    public int unregisterNode(int nodeId) {
        if (nodeId <= 0) {
            return ReturnCodeKeys.E004;
        }

        int index = -1;
        for (int i = 0; i < nodeList.size(); i++) {
            if (nodeId == nodeList.get(i)) {
                index = i;
                break;
            }
        }


        if (index == -1) {
            return ReturnCodeKeys.E007;
        }
        nodeList.remove(index);
        return ReturnCodeKeys.E006;
    }


    public int addTask(int taskId, int consumption) {
        if (taskId <= 0){
            return ReturnCodeKeys.E009;
        }

        boolean isFound = false;
        for (TaskInfo task :taskInfoList) {
            if (task.getTaskId() == taskId){
                isFound = true;
                break;
            }
        }

        if (isFound){
            return ReturnCodeKeys.E010;
        }

        TaskInfo taskInfo = new TaskInfo();
        taskInfo.setTaskId(taskId);
        taskInfo.setConsumption (consumption);
        taskInfoList.add(taskInfo);
        return ReturnCodeKeys.E008;
    }


    public int deleteTask(int taskId) {
        if (taskId <= 0){
            return ReturnCodeKeys.E009;
        }

        TaskInfo taskInfo = null;
        for (TaskInfo task :taskInfoList) {
            if (task.getTaskId() == taskId){
                taskInfo = task;
                break;
            }
        }

        if (taskInfo ==  null){
            return ReturnCodeKeys.E012;
        }

        taskInfoList.remove(taskInfo);
        return ReturnCodeKeys.E011;
    }


    public int scheduleTask(int threshold) {
        if (threshold <= 0){
            return ReturnCodeKeys.E002;
        }

        boolean scheduleStatus = this.scheduleAlgorithm(threshold);
        if (scheduleStatus){
            return ReturnCodeKeys.E013;
        }else{
            return ReturnCodeKeys.E014;
        }
    }


    public int queryTaskStatus(List<TaskInfo> tasks) {
        if (tasks == null) {
            return ReturnCodeKeys.E016;
        }

        //题目要求，按照升序排列task
        List<TaskInfo> tmpTaskInfoList = taskInfoList.subList(0, taskInfoList.size());
        Collections.sort(tmpTaskInfoList, new SortTaskInfoByTaskId());

        for (TaskInfo task : tmpTaskInfoList) {
            tasks.add(task);
        }
        return ReturnCodeKeys.E015;
    }


    private ScheduleNode findMinSumScheduleNode(List<ScheduleNode> scheduleNodeList){
        int min = Integer.MAX_VALUE;
        ScheduleNode ret = null;

        for (ScheduleNode node : scheduleNodeList) {
            if (node.getSum() < min){
                ret = node;
                min = node.getSum();
            }
        }

        return ret;
    }

    private void swapIfEqual(ScheduleNode scheduleNode1, ScheduleNode scheduleNode2) {
        List<TaskInfo> taskInfoList1 = scheduleNode1.getTaskInfoList();
        List<TaskInfo> taskInfoList2 = scheduleNode2.getTaskInfoList();
        boolean isFound = false;

        do {
            isFound = false;
            int i = 0;
            int j = 0;
            TaskInfo task1 = null;
            TaskInfo task2 = null;
            for (i = 0; i < taskInfoList1.size(); i++) {
                task1 = taskInfoList1.get(i);
                for (j = 0; j < taskInfoList2.size(); j++) {
                    task2 = taskInfoList2.get(j);
                    if (task1.getConsumption() == task2.getConsumption() &&
                            task1.getTaskId() > task2.getTaskId()) {
                        isFound = true;
                        break;
                    }
                }
                if (isFound){
                    break;
                }
            }
            if (isFound) {
                taskInfoList1.set(i, task2);
                taskInfoList2.set(j, task1);
            }
        } while (isFound);

    }

    private boolean scheduleAlgorithm(int threshold) {
        boolean scheduleStatus = true;

        //按照 Consumption 降序排列 TaskInfo
        List<TaskInfo> tmpTaskInfoList = taskInfoList.subList(0, taskInfoList.size());
        Collections.sort(tmpTaskInfoList, new SortTaskInfoByConsumption());

        //按照 nodeId 升序排列 NodeList
        List<Integer> tmpNodeList = nodeList.subList(0, nodeList.size());
        Collections.sort(tmpNodeList, new SortNodeListByNodeId());

        //将taskInfo 按照由大到小的顺序进行第一次赋值
        List<ScheduleNode> scheduleNodeList = new ArrayList<ScheduleNode>();
        for (int i = 0; i<tmpNodeList.size(); i++){
            TaskInfo taskInfo = tmpTaskInfoList.get(i);
            ScheduleNode scheduleNode = new ScheduleNode();
            scheduleNode.setNodeId(tmpNodeList.get(i));
            scheduleNode.setSum(taskInfo.getConsumption());
            scheduleNode.getTaskInfoList().add(taskInfo);
            scheduleNodeList.add(scheduleNode);
        }

        //将剩下的TaskInfo 依次赋值给sum最小的ScheduleNode
        for (int i = tmpNodeList.size(); i<tmpTaskInfoList.size(); i++) {
            TaskInfo taskInfo = tmpTaskInfoList.get(i);
            ScheduleNode scheduleNode = findMinSumScheduleNode(scheduleNodeList);
            scheduleNode.getTaskInfoList().add(taskInfo);
            scheduleNode.setSum(scheduleNode.getSum() + taskInfo.getConsumption());
        }

        //如果迁移后，有任意两台服务器的总消耗率相同，则应保证编号小的服务器的运行任务总数量少；
        //如果迁移后，所有的物理服务器的总消耗率不相同，保证编号大的服务器的总消耗大于编号小的服务器的总消耗。
        Collections.sort(scheduleNodeList, new SortScheduleNode());

        //如果存在资源消耗率相同的任务，则优先将编号小的任务迁移到编号小的服务器上
        for (int i=0; i< scheduleNodeList.size(); i++) {
            ScheduleNode scheduleNode1 = scheduleNodeList.get(i);
            scheduleNode1.setNodeId(tmpNodeList.get(i));
            for (int j=i+1; j< scheduleNodeList.size(); j++) {
                ScheduleNode scheduleNode2 = scheduleNodeList.get(j);
                 swapIfEqual(scheduleNode1, scheduleNode2);
            }
        }

        //打完收工，给任务赋值节点Id
        for (int i=0; i< scheduleNodeList.size(); i++) {
            ScheduleNode scheduleNode = scheduleNodeList.get(i);
            for (TaskInfo task :scheduleNode.getTaskInfoList()) {
                task.setNodeId(scheduleNode.getNodeId());
            }
        }

        //判断阈值
        for (int i = 0; i<scheduleNodeList.size(); i++) {
            ScheduleNode scheduleNode1 = scheduleNodeList.get(i);
            for (int j = i+1; j< scheduleNodeList.size(); j++) {
                ScheduleNode scheduleNode2 = scheduleNodeList.get(j);
                if (Math.abs(scheduleNode1.getSum() - scheduleNode2.getSum()) > threshold){
                    scheduleStatus = false;
                    break;
                }
            }

            if (!scheduleStatus){
                break;
            }
        }
        return scheduleStatus;
    }


}
