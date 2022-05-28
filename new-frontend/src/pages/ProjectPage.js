import React from 'react'
import exampleImg from '../images/example.png'
import ProgressBar from '../components/ProgressBar'


const testData = [
    { bgcolor: "#6a1b9a", completed: 60 },
];


//Read from data (get link data)


function ProjectPage() {
    return (

        <div className="mx-10 mt-20 flex flex-col">

            <div className="mx-5">

                <div>
                    <h1 className="text-5xl font-bold text-gray-900 pb-2 mt-4 mb-8"> Neural Rad</h1>
                    <p className="text-lg text-gray-800">
                        Neural Rad is a web application that allows users to create and share neural networks.
                        Users can then use the neural network to predict the outcome of a given set of inputs.
                        Neural Rad is built using React, Express, Node, and PostgreSQL.
                    </p>
                </div>

                <div className='mt-10'>
                    <h1 className="text-4xl font-bold text-gray-900 pb-2 mt-4"> Goal </h1>

                    <div className="flex flex-row mb-10">
                        {testData.map((item, idx) => (
                            <ProgressBar key={idx} bgcolor={item.bgcolor} completed={item.completed} />
                        ))}
                    </div>

                    <button className="h-12 px-4 bg-transparent text-black font-semibold border border-black rounded hover:bg-black hover:text-white hover:border-transparent transition ease-in duration-200 transform w-58"
                    > Become a contributor
                    </button>

                </div>

            </div>

        </div>

    )
}


export default ProjectPage;