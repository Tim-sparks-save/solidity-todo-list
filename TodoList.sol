// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TodoList {
    
    // Define what a Task looks like
    struct Task {
        string content;
        bool isCompleted;
    }

    // Mapping from user address to their specific list of tasks
    // This ensures users can only see and manage their own tasks!
    mapping(address => Task[]) private userTasks;

    // Events to track changes on the blockchain
    event TaskCreated(address indexed user, uint256 taskId, string content);
    event TaskStatusToggled(address indexed user, uint256 taskId, bool isCompleted);

    // 1. Create a new task
    function createTask(string calldata _content) external {
        require(bytes(_content).length > 0, "Task content cannot be empty");

        userTasks[msg.sender].push(Task({
            content: _content,
            isCompleted: false
        }));

        uint256 taskId = userTasks[msg.sender].length - 1;
        emit TaskCreated(msg.sender, taskId, _content);
    }

    // 2. Toggle task completion (Incomplete <-> Completed)
    function toggleComplete(uint256 _taskId) external {
        require(_taskId < userTasks[msg.sender].length, "Task does not exist");
        
        // Grab the task from storage and flip its true/false status
        Task storage task = userTasks[msg.sender][_taskId];
        task.isCompleted = !task.isCompleted;

        emit TaskStatusToggled(msg.sender, _taskId, task.isCompleted);
    }

    // 3. Fetch all tasks for the calling wallet address
    function getMyTasks() external view returns (Task[] memory) {
        return userTasks[msg.sender];
    }
}
