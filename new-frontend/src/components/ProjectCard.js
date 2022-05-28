import React from 'react'
import "./projectCard.css";

function ProjectCard({ isLoading, name, description }) {
    return (
        <div
            className="bg-white rounded-lg border border-gray-300 h-[200px] flex">
            <div className="p-5 flex flex-col">
                <a href="#">
                    {isLoading ?
                        <div data-placeholder class="mb-4 h-10 w-40 overflow-hidden relative bg-gray-300 rounded-lg" > </div>
                        :
                        <h5 className="mb-2 text-2xl font-bold tracking-tight text-gray-900 text-ellipsis">{name}</h5>
                    }
                </a>
                {isLoading ?
                    <div data-placeholder class="mb-2 h-40 w-100 overflow-hidden relative bg-gray-200 rounded-lg" />
                    :
                    <p className="mb-3 font-normal text-gray-700 text-ellipsis">{description}</p>
                }
                {!isLoading &&
                    <button className="mt-auto h-8 px-4 bg-transparent text-black font-semibold border border-black rounded hover:bg-black hover:text-white hover:border-transparent transition ease-in duration-200 transform w-36"
                    > Read More
                    </button>
                }
            </div>
        </div>
    )
}

export default ProjectCard;