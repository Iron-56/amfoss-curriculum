'use client';

import { useState } from 'react';
import LoginPopup from '@/components/LoginPopup';
import SettingsPopup from '@/components/SettingsPopup';

export default function LayoutWrapper({ children, poppins, inter }) {
	const [isPopupOpen, setIsPopupOpen] = useState("null");

	return (
		<div className="flex h-screen overflow-hidden">
			<aside className="min-w-fit max-w-70 w-[30%] bg-[#151515] hidden lg:block flex-col p-4">
				
				<p className={`${poppins.className} text-center text-2xl font-black my-1`}>
					<span className="text-[#099EB8]">Flix</span><span className="text-[#FD3232]">Hub</span>
				</p>

				<hr className="border-[#1E1E1E] mt-4"/>

				<div className="flex flex-col justify-between h-full p-4">

					<div className={`${inter.className} text-[#FFFFFF] font-normal text-lg  flex flex-col gap-6 mt-10`}>
						<a className="flex">
							<img src="Browse.svg" className="w-6 mr-2"/>
							<p>Browse</p>
						</a>
						<a className="flex">
							<img src="Clock.svg" className="w-6 mr-2" />
							<p>Watch Later</p>
						</a>
						<a className="flex">
							<img src="Followed.svg" className="w-6 mr-2" />
							<p>Following</p>
						</a>
						<a className="flex">
							<img src="profile.svg" className="w-6 mr-2" />
							<p>Followers</p>
						</a>
						<button className="flex" onClick={() => setIsPopupOpen("settings")}>
							<img src="Settings.svg" className="w-6 mr-2" />
							<p>Settings</p>
						</button>
						<a className="flex">
							<img src="Playlist.svg" className="w-6 mr-2" />
							<p>My Playlists</p>
						</a>
						<a className="flex">
							<img src="History.svg" className="w-6 mr-2" />
							<p>History</p>
						</a>
					</div>

					<div className={`${poppins.className} text-[#888888] font-bold flex flex-col gap-2 max-w-20`}>
						<br></br>
						<h2 className="font-thin mb-4">Categories</h2>
						<p>Trending</p>
						<p>Action</p>
						<p>Horror</p>
						<p>Adventure</p>
						<p>Crime & Investigation</p>
						<p>Superhero</p>
						<p>Sport</p>
						<p>Studio</p>
					</div>
				</div>
			</aside>
			
			<main className={`${poppins.className} w-full h-full bg-[#1E1E1E] overflow-y-auto flex flex-col`}>

				<nav className="bg-[#1A1A1A] text-white p-4 flex flex-wrap gap-4 justify-between items-center">
					
					<p className={`${poppins.className} text-center text-2xl font-black my-1 hidden sm:block lg:hidden `}>
						<span className="text-[#099EB8]">Flix</span><span className="text-[#FD3232]">Hub</span>
					</p>

					<div className="flex items-center bg-[#272727] rounded-2xl px-4 py-2 min-w-40 flex-1 justify-between">
						<div className="flex min-w-0 ">
							<img src="Search.svg" />
							<input type="text" placeholder="Search" className="pl-4 min-w-0 bg-transparent outline-none text-gray-300 placeholder:text-gray-500" />
						</div>
						<img src="Filter.svg" />
					</div>

					<div className="flex gap-4 items-center justify-between w-full sm:w-auto">
						<button onClick={() => setIsPopupOpen("login")}>
							<img src="profile.svg" className="w-[24px] h-[24px] rounded-full" />
						</button>
						<img src="Settings.svg" className="w-[24px] h-[24px] rounded-full" />
					</div>
				</nav>
				{children}
			</main>

			<LoginPopup isOpen={isPopupOpen} onClose={() => setIsPopupOpen("null")} />
			<SettingsPopup isOpen={isPopupOpen} onClose={() => setIsPopupOpen("null")} />
		</div>
	);
}