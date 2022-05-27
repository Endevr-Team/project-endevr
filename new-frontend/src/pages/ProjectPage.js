import React from 'react'
import NavBar from '../components/NavBar'
import exampleImg from '../images/example.png'

function ProjectPage () {
    return (

        <div class={"flex flex-col"}>

            <NavBar/>

            <div class="mx-5">
                <div class="mx-auto flex w-96 flex-col justify-center bg-white rounded-2xl shadow-xl shadow-slate-300/60">
                    <img className="object-fill" src={exampleImg} alt="Logo"/>
                </div>

                <h1 class="text-5xl font-bold text-slate-600 pb-2 mt-4"> Neural Rad</h1>
                <p class="text-xl text-slate-600">
                    Neural Rad is a web application that allows users to create and share neural networks.
                    Users can then use the neural network to predict the outcome of a given set of inputs.
                    Neural Rad is built using React, Express, Node, and PostgreSQL.
                </p>

                <h1 className="text-5xl font-bold text-slate-600 pb-2 mt-4"> Goals </h1>


                <div className="w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700">
                    <div className="bg-blue-600 h-2.5 rounded-full" style="width: 45%"></div>
                </div>

                <p className="text-xl text-slate-600">
                    Neural Rad is a web application that allows users to create and share neural networks.
                    Users can then use the neural network to predict the outcome of a given set of inputs.
                    Neural Rad is built using React, Express, Node, and PostgreSQL.
                </p>

                <h1 className="text-5xl font-bold text-slate-600 pb-2 mt-4"> Project Description </h1>
                <p className="text-xl text-slate-600">
                    Neural Rad is a web application that allows users to create and share neural networks.
                    Users can then use the neural network to predict the outcome of a given set of inputs.
                    Neural Rad is built using React, Express, Node, and PostgreSQL.
                </p>

                <h1 className="text-5xl font-bold text-slate-600 pb-2 mt-4"> Pioneers </h1>
                <p className="text-xl text-slate-600">
                    Neural Rad is a web application that allows users to create and share neural networks.
                    Users can then use the neural network to predict the outcome of a given set of inputs.
                    Neural Rad is built using React, Express, Node, and PostgreSQL.
                </p>




            </div>

        </div>

    )
}


export default ProjectPage;