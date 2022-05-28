import React from 'react'
import NavBar from '../components/NavBar'
import exampleImg from '../images/example.png'
import ProgressBar from '../components/ProgressBar'


const testData = [
    { bgcolor: "#6a1b9a", completed: 60 },
];

function ProjectPage () {
    return (

        <div class={"flex flex-col"}>

            <NavBar/>

            <div class="mx-5">
                <div class="mx-auto flex w-96 flex-col justify-center bg-white rounded-2xl shadow-xl shadow-slate-300/60">
                    <img className="object-fill" src={exampleImg} alt="Logo"/>
                </div>

                <div>
                    <h1 class="text-5xl font-bold text-slate-600 pb-2 mt-4"> Neural Rad</h1>
                    <p class="text-xl text-slate-600">
                        Neural Rad is a web application that allows users to create and share neural networks.
                        Users can then use the neural network to predict the outcome of a given set of inputs.
                        Neural Rad is built using React, Express, Node, and PostgreSQL.
                    </p>
                </div>

                <div>


                    <h1 className="text-5xl font-bold text-slate-600 pb-2 mt-4"> Goal </h1>
                    {testData.map((item, idx) => (
                        <ProgressBar key={idx} bgcolor={item.bgcolor} completed={item.completed} />
                    ))}
                    <p className="text-xl text-slate-600">
                        Neural Rad is a web application that allows users to create and share neural networks.
                        Users can then use the neural network to predict the outcome of a given set of inputs.
                        Neural Rad is built using React, Express, Node, and PostgreSQL.
                    </p>
                </div>

                <div>
                    <h1 className="text-5xl font-bold text-slate-600 pb-2 mt-4"> Project Description </h1>
                    <p className="text-xl text-slate-600">
                        Neural Rad is a web application that allows users to create and share neural networks.
                        Users can then use the neural network to predict the outcome of a given set of inputs.
                        Neural Rad is built using React, Express, Node, and PostgreSQL.
                    </p>
                </div>


                <div>
                    <h1 className="text-5xl font-bold text-slate-600 pb-2 mt-4"> Pioneers </h1>
                    <p className="text-xl text-slate-600">
                        Neural Rad is a web application that allows users to create and share neural networks.
                        Users can then use the neural network to predict the outcome of a given set of inputs.
                        Neural Rad is built using React, Express, Node, and PostgreSQL.
                    </p>
                </div>
            </div>

        </div>

    )
}


export default ProjectPage;