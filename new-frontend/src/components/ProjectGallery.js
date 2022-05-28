import React from "react";
import ProjectCard from "./ProjectCard";
import { useMoralisQuery } from "react-moralis";

function ProjectGallery() {

    const { data, error, isLoading } = useMoralisQuery("endeavours");

    console.log(data);

    return (
        <>
            <div className="px-10 grid grid-cols-3 gap-6">
                {isLoading ?
                    (<>
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                        <ProjectCard isLoading={true} />
                    </>
                    ) :
                    (
                        data.map((endeavour, index) =>
                            // Only do this if items have no stable IDs
                            <ProjectCard key={index} name={endeavour.get("name")} description={endeavour.get("description")} id={endeavour.id} />
                        )
                    )

                }

            </div>
        </>
    )
}

export default ProjectGallery;