import NavBar from '../components/NavBar';
import ProjectCard from '../components/ProjectCard';
import LandingSlide from '../components/LandingSlide';


function HomePage() {
    return(
        <div>
            <LandingSlide/>
            <NavBar/>
            <ProjectCard/>

        </div>
    )
}

export default HomePage;