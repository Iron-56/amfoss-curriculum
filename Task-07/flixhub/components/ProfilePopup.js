
import React from "react";
import { Poppins, Inter } from 'next/font/google';
import { useState } from "react";


const poppins = Poppins({
	subsets: ['latin'],
	weight: ['400', '600'],
	variable: '--font-poppins',
});

const inter = Inter({
	subsets: ['latin'],
	weight: ['400', '600'],
	variable: '--font-inter',
});

export default function SettingsPopup({ isOpen, onClose }) {
	if (!isOpen) return null;
	const [enabled, setEnabled] = useState(true);

	return (
		<div className="fixed inset-0 bg-[rgba(2.25,40,46,0.85)]  flex items-center justify-center sm:p-4 z-50">
			<div className="bg-[#1E1E1E] flex flex-col items-center w-full h-full sm:w-[500] sm:h-fit border border-[#ff0000] shadow-2xl sm:justify-around gap-2 sm:rounded-2xl relative">
			
				<nav className="bg-[#1A1A1A] flex rounded-t-2xl w-full justify-between">
					<div className="flex items-center gap-4 p-6">
						<img src="profile.svg" className="w-6 h-6 rounded-full" />
						<p>Username</p>
					</div>
					<div className="flex items-center gap-4 p-6">
						<button className="bg-[#2C2C2C] flex items-center p-2 gap-2 rounded-lg">
							<img src="Followed-Check.svg" className="w-[20px] h-[20px]"/>
						</button>
						<button onClick={onClose} className="bg-[#2C2C2C] p-2.5 rounded-lg text-[#989898] text-xl flex items-center justify-center w-[36px] h-[36px]">✖</button>
					</div>
				</nav>

				<div className="p-6 w-full flex flex-col sm:max-h-150 overflow-auto text-sm gap-6">
					<div>
						<p className="text-[#CCCCCC] text-xl font-semibold">Recent</p>
						<div className="flex flex-col w-full p-4 gap-4">
							<div className="flex gap-4 flex-2/3 flex-col sm:flex-row">
								<div className="relative bg-[url('/poster2.png')] md:min-w-1/2 bg-cover  bg-center rounded-3xl overflow-hidden flex-2">
									<div className="absolute inset-0 bg-gradient-to-r from-black to-transparent"></div>
									<div className="justify-between relative h-full p-6 text-white flex flex-col">
										<div className="flex flex-col gap-4 w-min text-sm text-gray-300 mb-2">
											<h1 className="text-3xl font-black">Batman Begins</h1>
											<div className="flex justify-between">
												<p>2016</p>
											</div>
										</div>
										<div className="flex gap-2 w-min font-semibold justify-center items-center">
											<button className="bg-[#FF0000] py-2 flex-1 px-4 rounded-xl">Watch</button>
										</div>
									</div>
								</div>
								<div className="flex gap-4 sm:flex-col min-w-fit overflow-auto m-auto justify-around">
									<img src="playlist1.png" className="w-18"/>
									<img src="playlist2.png" className="w-18"/>
									<img src="playlist3.png" className="w-18"/>
									<img src="movie1.png" className="w-18"/>
								</div>
							</div>
						</div>
						
						
						<div>
							<p className="text-[#CCCCCC] text-xl font-semibold">Interests</p>
							<div className="flex flex-wrap justify-center gap-4 p-4 w-full items-center">
								<div className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Horror</div>
								<div className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Thriller</div>
								<div className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Action</div>
								<div className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Crime & Investigation</div>
								<div className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Sports</div>
								<div className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Action</div>
								<div className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Adventure</div>
							</div>
						</div>

						<a><p className="text-[#0094D4] cursor-pointer text-md mt-6 text-center font-semibold">Check out my Playlists!</p></a>
					</div>
				</div>
			</div>
		</div>
		
	);
}
