import React, { useState } from 'react';

function About() {
  const [count, setCount] = useState(0);
  return (
    <div className='page'>
      <h1>About</h1>
      <p>This is my portfolio website. I built it using React.</p>
      <hr />
      <button onClick={() => setCount(count+1)}>Pressed {count} times</button>
    </div>
  );
}

export default About;