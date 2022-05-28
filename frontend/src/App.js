import './App.css';
import NavBar from './components/NavBar.js';
import HomePage from './pages/HomePage.js';
import ProjectPage from './pages/ProjectPage.js';
import React from 'react'
import { Route, Routes } from "react-router-dom";

function App() {
  return (
    <>
      <NavBar />
      <Routes>
        <Route exact path='/' element={<HomePage />} />
        <Route exact path=":id" element={<ProjectPage />} />
      </Routes>
    </>
  );
}

export default App;
