import NavBar from '../components/NavBar';
import ProjectCard from '../components/ProjectCard';
import LandingSlide from '../components/LandingSlide';
import ProjectGallery from '../components/ProjectGallery';
import React from 'react'

function HomePage() {
    return (
        <div>
            <NavBar />
            <div className="py-20">
                <h1 className="text-8xl font-semibold text-center">Make Things Happen.</h1>
            </div>
            {/* <LandingSlide />
            <ProjectCard /> */}
            <ProjectGallery>

            </ProjectGallery>
        </div>
    )
}

export default HomePage;