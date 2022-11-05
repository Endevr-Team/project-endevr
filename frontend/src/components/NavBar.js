import React from 'react'
import { useMoralis } from "react-moralis";
import { Link } from "react-router-dom";

import fullLogo from "../images/logo-full.png"

function NavBar() {

    const { authenticate, logout, isAuthenticated, user, isAuthenticating } = useMoralis();
    console.log(user);

    return (
        <div className="flex my-4 mx-10 h-12 justify-between">
            <Link style={{ width: "150px" }} to="/">
                <img className="py-1" src={fullLogo} />
            </Link>
            <div className="">
                {isAuthenticated ?
                    <button className="h-12 py-2 px-4 bg-transparent text-black font-semibold border border-black rounded hover:bg-black hover:text-white hover:border-transparent transition ease-in duration-200 transform w-44 text-ellipsis overflow-hidden"
                        onClick={() => logout()}
                        disabled={isAuthenticating}
                    > {user.get("ethAddress")} </button> :
                    <button className="h-12 py-2 px-4 bg-transparent text-black font-semibold border border-black rounded hover:bg-black hover:text-white hover:border-transparent transition ease-in duration-200 transform w-36"
                        onClick={() => authenticate({ signingMessage: "Connect to Endevr to donate to projects" })}
                        disabled={isAuthenticating}
                    > Connect </button>
                }
            </div >
        </div>
    )
}

export default NavBar;