import React, { useEffect } from 'react'
import exampleImg from '../images/example.png'
import ProgressBar from '../components/ProgressBar'
import { useLocation } from 'react-router-dom'
import { useMoralisQuery } from "react-moralis";
import { Link } from "react-router-dom";


const testData = [
    { bgcolor: "#6a1b9a", completed: 60 },
];


//Read from data (get link data)


function ProjectPage() {

    const location = useLocation();
    const id = location.pathname.replace('/', '');
    const { data, error, isLoading } = useMoralisQuery("endeavours", (query) => query.equalTo("objectId", id));

    return (

        <div className="mx-10 mt-20 flex flex-col">

            {isLoading ?
                <h1 className="text-4xl font-semibold text-center">Loading</h1>
                :
                <>
                    {
                        data.length == 0 ?

                            <>
                                <h1 className="text-8xl font-semibold text-center">Project Not Found</h1>
                                <Link to="/" className="mt-auto self-center">
                                    <button className="mt-10 self-center h-8 px-4 bg-transparent text-black font-semibold border border-black rounded hover:bg-black hover:text-white hover:border-transparent transition ease-in duration-200 transform w-36"
                                    > Go Home
                                    </button>
                                </Link>
                            </>

                            :

                            <div className="mx-5">

                                <div>
                                    <h1 className="text-5xl font-bold text-gray-900 pb-2 mt-4 mb-8">{data[0].get("name")}</h1>
                                    <p className="text-lg text-gray-800">
                                        {data[0].get("description")}
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
                    }
                </>
            }

        </div>

    )
}


export default ProjectPage;