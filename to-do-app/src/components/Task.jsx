import React from 'react';

const Task = ({ task, onDelete, onToggle }) => {
  return (
    <div style={{ display: 'flex', alignItems: 'center', marginBottom: '10px' }}>
      <input
        type="checkbox"
        checked={task.completed}
        onChange={() => onToggle(task.id)}
        style={{ marginRight: '10px' }}
      />
      <span
        style={{
          textDecoration: task.completed ? 'line-through' : 'none',
          flexGrow: 1,
        }}
      >
        {task.text}
      </span>
      <button onClick={() => onDelete(task.id)} style={{ marginLeft: '10px' }}>
        Delete
      </button>
    </div>
  );
};

export default Task;