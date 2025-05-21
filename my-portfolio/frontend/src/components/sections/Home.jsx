import React, { useState, useEffect } from 'react';

function Home() {
  return (
    <div className='page'>
      <h1>Home</h1>
      <p>Welcome to my portfolio website!</p>
      <ProductDemo />
    </div>
  );
}

const productData = {
  1: { name: "Laptop Pro", description: "High-performance laptop with 16GB RAM", price: "$1299" },
  2: { name: "SmartPhone X", description: "Latest smartphone with amazing camera", price: "$899" },
  3: { name: "Wireless Headphones", description: "Noise-cancelling bluetooth headphones", price: "$249" }
};

function ProductDemo() {
  const [productId, setProductId] = useState(1);
  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);
  const [lastUpdated, setLastUpdated] = useState("");

  useEffect(() => {
    console.log(`Getting info for product #${productId}`);
    

    setProduct(null);
    setLoading(true);
    
    const timeoutId = setTimeout(() => {
      setProduct(productData[productId]);
      setLoading(false);
      setLastUpdated(new Date().toLocaleTimeString());
    }, 1000); 
    
    // Cleanup function runs when component unmounts or before effect runs again
    return () => clearTimeout(timeoutId);
  }, [productId]); //tells React to run this whole effect only when the product ID changes.

  return (
    <div className="product-demo">
      <h3>useEffect Demo: Product Selector</h3>
      
      <select 
        value={productId}
        onChange={(e) => setProductId(parseInt(e.target.value))}
        className="product-select"
      >
        <option value="1">Laptop Pro</option>
        <option value="2">SmartPhone X</option>
        <option value="3">Wireless Headphones</option>
      </select>
      
      <div className="product-display">
        {loading ? (
          <p>Loading product information...</p>
        ) : (
          <div>
            <h2>{product?.name}</h2>
            <p>{product?.description}</p>
            <p><strong>Price:</strong> {product?.price}</p>
            <small>Last updated: {lastUpdated}</small>
          </div>
        )}
      </div>
    </div>
  );
}

export default Home;