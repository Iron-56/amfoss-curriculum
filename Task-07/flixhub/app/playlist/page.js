"use client"
import Image from "next/image";
import { Poppins, Inter } from 'next/font/google';
import { useState } from 'react';
import PromptPopup from "@/components/PromptPopup";

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

export default function Home() {
	const [isPopupOpen, setIsPopupOpen] = useState(false);

	return (
		<div className="flex flex-col gap-12 p-2 sm:p-6 md:p-12">

			<div>
				<div className="flex w-full justify-between gap-4 items-stretch flex-wrap lg:flex-nowrap">
					<p className="text-3xl font-black">Batman - DC</p>
					<div className="flex gap-2 items-center">
						<p>3k</p>
						<img src="Heart.svg" className="w-6"/>
					</div>
				</div>
				<div className="flex w-full justify-between items-center flex-col sm:flex-row gap-4">
					<div className="bg-[#151515] mt-4 rounded-4xl p-4 flex-col min-h-80 flex md:flex-row gap-4">
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
										<button className="bg-[#fff]">
											<img src="like.svg" className="inline-block w-4 h-4" />
											{/* What the fuck is going on here */}
										</button>
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
						
						<div className="bg-[#151515] rounded-xl flex flex-1/3 flex-col justify-center items-center">
							
							<div className="flex gap-3 items-start p-4">
								<img src="profile.svg" className="w-4 h-4 lg:w-6 lg:h-6" />
								<div className="max-h-40 overflow-auto">
									<p className="text-white text-xs sm:text-sm">
										Ajax, a twisted scientist, experiments on Wade Wilson, a mercenary, to cure him of cancer and give him healing powers. However, the experiment leaves Wade disfigured and he decides to exact revenge.
									</p>
									<div className="flex items-center gap-2 mt-2 text-gray-400 text-sm">
										<img src="like.svg" className="inline-block w-4 h-4" />
										<p>3k</p>
									</div>
								</div>
							</div>
							<button className="text-[#ffffff] bg-[#1A1A1A] p-4 rounded-2xl font-bold text-center mt-4 sm:text-lg">Comments</button>
						</div>
					</div>
					<div className="flex flex-row px-4 gap-4 justify-start bg-[#151515] sm:px-0 sm:flex-col h-fit mt-4 py-4 rounded-xl min-w-[60px] items-center">
						{[
							{ src: "shuffle.svg"},
							{ src: "Plus.svg"},
							{ src: "share.svg"},
							{ src: "trash.svg"},
						].map((item, i) => (
							<img key={i} src={item.src} className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
						))}
					</div>
				</div>
			</div>
			<div>
				<div className="flex w-full justify-between gap-4 items-stretch flex-wrap lg:flex-nowrap">
					<p className="text-3xl font-black">Batman - DC</p>
					<div className="flex gap-2 items-center">
						<p>3k</p>
						<img src="Heart.svg" className="w-6"/>
					</div>
				</div>
				<div className="flex w-full justify-between items-center flex-col sm:flex-row gap-4">
					<div className="bg-[#151515] mt-4 rounded-4xl p-4 flex-col min-h-80 flex md:flex-row gap-4">
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
										<button className="bg-[#fff]">
											<img src="like.svg" className="inline-block w-4 h-4" />
											{/* What the fuck is going on here */}
										</button>
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
						
						<div className="bg-[#151515] rounded-xl flex flex-1/3 flex-col justify-center items-center">
							
							<div className="flex gap-3 items-start p-4">
								<img src="profile.svg" className="w-4 h-4 lg:w-6 lg:h-6" />
								<div className="max-h-40 overflow-auto">
									<p className="text-white text-xs sm:text-sm">
										Ajax, a twisted scientist, experiments on Wade Wilson, a mercenary, to cure him of cancer and give him healing powers. However, the experiment leaves Wade disfigured and he decides to exact revenge.
									</p>
									<div className="flex items-center gap-2 mt-2 text-gray-400 text-sm">
										<img src="like.svg" className="inline-block w-4 h-4" />
										<p>3k</p>
									</div>
								</div>
							</div>
							<button className="text-[#ffffff] bg-[#1A1A1A] p-4 rounded-2xl font-bold text-center mt-4 sm:text-lg">Comments</button>
						</div>
					</div>
					<div className="flex flex-row px-4 gap-4 justify-start bg-[#151515] sm:px-0 sm:flex-col h-fit mt-4 py-4 rounded-xl min-w-[60px] items-center">
						<img src="shuffle.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
						<img src="Plus.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
						<button onClick={() => setIsPopupOpen(true)}>
							<img src="share.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
						</button>
						<img src="trash.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
					</div>
				</div>
			</div>

			<div>
				<div className="flex w-full justify-between gap-4 items-stretch flex-wrap lg:flex-nowrap">
					<p className="text-3xl font-black">Batman - DC</p>
					<div className="flex gap-2 items-center">
						<p>3k</p>
						<img src="Heart.svg" className="w-6"/>
					</div>
				</div>
				<div className="flex w-full justify-between items-center flex-col sm:flex-row gap-4">
					<div className="bg-[#151515] mt-4 rounded-4xl p-4 flex-col min-h-80 flex md:flex-row gap-4">
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
										<button className="bg-[#fff]">
											<img src="like.svg" className="inline-block w-4 h-4" />
											{/* What the fuck is going on here */}
										</button>
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
						
						<div className="bg-[#151515] rounded-xl flex flex-1/3 flex-col justify-center items-center">
							
							<div className="flex gap-3 items-start p-4">
								<img src="profile.svg" className="w-4 h-4 lg:w-6 lg:h-6" />
								<div className="max-h-40 overflow-auto">
									<p className="text-white text-xs sm:text-sm">
										Ajax, a twisted scientist, experiments on Wade Wilson, a mercenary, to cure him of cancer and give him healing powers. However, the experiment leaves Wade disfigured and he decides to exact revenge.
									</p>
									<div className="flex items-center gap-2 mt-2 text-gray-400 text-sm">
										<img src="like.svg" className="inline-block w-4 h-4" />
										<p>3k</p>
									</div>
								</div>
							</div>
							<button className="text-[#ffffff] bg-[#1A1A1A] p-4 rounded-2xl font-bold text-center mt-4 sm:text-lg">Comments</button>
						</div>
					</div>
					<div className="flex flex-row px-4 gap-4 justify-start bg-[#151515] sm:px-0 sm:flex-col h-fit mt-4 py-4 rounded-xl min-w-[60px] items-center">
						<img src="shuffle.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
						<img src="Plus.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
						<button onClick={() => setIsPopupOpen(true)}>
							<img src="share.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
						</button>
						<img src="trash.svg" className="p-2 w-8 h-8 bg-[#2C2C2C] rounded-lg"/>
					</div>
				</div>
			</div>

			<PromptPopup isOpen={isPopupOpen} prompt="Are you sure you want to Unshare?" warning="All comments and likes will be erased." accept="Unshare" onClose={() => setIsPopupOpen(false)}/>
		</div>
	);
}