import React from 'react'
import ProjectGallery from '../components/ProjectGallery';

function HomePage() {
    return (
        <div>
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