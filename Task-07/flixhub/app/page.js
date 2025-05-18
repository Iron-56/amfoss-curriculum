import Image from "next/image";

import { Poppins, Inter } from 'next/font/google';

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
	return (
		<div className="flex flex-col gap-4 p-4">
			<div className="flex w-full justify-between gap-4 items-stretch flex-wrap lg:flex-nowrap">

				<img src="poster1.png" className="rounded-xl w-full h-64 object-cover lg:hidden"/>

				<div className="justify-between relative p-6 text-white flex flex-col lg:hidden m-auto w-full gap-4">
					<div className="flex flex-wrap gap-2 w-full font-semibold justify-center">
						<button className="bg-[#FF0000] py-2 px-4 rounded-lg flex-1">Watch</button>
						
						<div className="flex gap-2 justify-center">
							<button className="bg-[#242424] text-[#E0DC5F] w-max flex-1 py-2 px-4 rounded-lg"><img src="star.svg"/></button>
							<button className="bg-[#242424] py-2 px-4 rounded-lg flex-1">+</button>
						</div>
						
					</div>
					<div className="flex flex-col gap-4 w-full text-sm text-gray-300 mb-2">
						<div className="flex justify-between">
							<h1 className="text-2xl font-black sm:text-4xl">Deadpool</h1>
						</div>
						<div className="flex justify-between">
							<p>2016</p>
							<p className="text-[#E0DC5F]">8.5/10</p>
						</div>
						<p className="mb-4 text-xs text-gray-300 max-w-xl lg:hidden sm:text-sm">
							Ajax, a twisted scientist, experiments on Wade Wilson, a mercenary, to cure him of cancer and give him healing powers. However, the experiment leaves Wade disfigured and he decides to exact revenge.
						</p>
					</div>
				</div>
				
				<div className="relative bg-[url('/poster1.png')] bg-cover bg-center rounded-xl overflow-hidden hidden lg:flex flex-2">
				
					<div className="absolute inset-0 bg-gradient-to-r from-black/80 via-black/40 to-transparent"></div>
					<div className="justify-between relative p-6 text-white flex flex-col">
						<div className="flex flex-col gap-4 w-min text-sm text-gray-300 mb-2">
						<h1 className="text-4xl font-black">Deadpool</h1>
						<div className="flex justify-between">
							<p>2016</p>
							<p className="text-[#E0DC5F]">8.5/10</p>
						</div>
						<p className="mb-4 text-sm text-gray-300 max-w-xl hidden lg:block">
							Ajax, a twisted scientist, experiments on Wade Wilson, a mercenary, to cure him of cancer and give him healing powers. However, the experiment leaves Wade disfigured and he decides to exact revenge.
						</p>
						</div>
						<div className="flex flex-col gap-2 w-min font-semibold">
						<button className="bg-[#FF0000] py-2 px-4 rounded-lg">Watch</button>
						<div className="flex flex-1 gap-2">
							<button className="bg-[#242424] text-[#E0DC5F] w-max py-2 px-4 rounded-lg">Rate Now!</button>
							<button className="bg-[#242424] py-2 px-4 rounded-lg">+</button>
						</div>
						</div>
					</div>
				</div>

				<div className="bg-[#151515] rounded-xl overflow-hidden min-w-64 flex-1 max-h-65 lg:max-h-full flex-col">
					<div className="bg-[#1A1A1A] px-4 py-2">
						<h4 className="text-[#ffffff] font-bold text-base mt-4 sm:text-lg">Comments</h4>
					</div>
					<div className="flex gap-3 items-start p-4">
						<img src="profile.svg" className="w-4 h-4 lg:w-6 lg:h-6" />
						<div>
							<p className="text-white text-xs sm:text-sm">
								Ajax, a twisted scientist, experiments on Wade Wilson, a mercenary, to cure him of cancer and give him healing powers. However, the experiment leaves Wade disfigured and he decides to exact revenge.
							</p>
							<div className="flex items-center gap-2 mt-2 text-gray-400 text-sm">
								<img src="like.svg" className="inline-block w-4 h-4" />
								<p>3k</p>
							</div>
						</div>
					</div>
				</div>
			</div>

			<div className="overflow-x-hidden overflow-y-auto px-4 pb-10 gap-4 flex flex-col font-bold text-lg">
				<h4 className="text-[#ffffff] font-bold text-lg">Similar</h4>
				<div className="flex gap-4 overflow-x-scroll">
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
				</div>
				<h4 className="text-[#ffffff] font-bold text-lg">Suggested</h4>
				<div className="flex gap-4 overflow-x-scroll">
				<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
				</div>
				<h4 className="text-[#ffffff] font-bold text-lg">Trending</h4>
				<div className="flex gap-4 overflow-x-scroll">
				<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
				</div>
				<h4 className="text-[#ffffff] overflow-x-scroll font-bold text-lg">Discover</h4>
				<div className="flex gap-4 overflow-x-scroll">
				<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
					<img src="movie1.png" className="rounded-xl"/>
					<img src="movie2.png" className="rounded-xl"/>
					<img src="movie3.png" className="rounded-xl"/>
					<img src="movie4.png" className="rounded-xl"/>
				</div>
			</div>
		</div>
	);
}