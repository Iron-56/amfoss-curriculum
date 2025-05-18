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

export default function WatchLater() {
	return (
		<div className="flex flex-col gap-3 p-2 h-full sm:p-6 md:p-12 ">
			<p className="text-3xl text-center sm:text-left font-black">Watch Later</p>
			<div className="flex w-full h-full bg-[#151515] rounded-4xl flex-col xl:flex-row gap-4 p-4">
				<div className="flex sm:flex-1 bg-gradient-to-b from-[#8C0000] sm:h-full xl:max-w-150 to-[#001919] rounded-4xl flex-col sm:flex-row gap-4 p-4">
					<div className="flex flex-col gap-4 w-full">
						<img src="poster2.png" className="rounded-xl w-full h-auto max-h-46 object-cover"/>
						<div className="flex items-center justify-between flex-row">
							<div className="flex flex-col gap-4 w-min text-sm text-gray-300 mb-2">
								<h1 className="text-3xl font-black">Batman Begins</h1>
								<p className="flex justify-between text-[#6A6A6A]">2016</p>
							</div>
							<div className="flex p-6 shadow-xl/60 gap-6 sm:flex-row flex-col rounded-2xl h-fit w-min font-semibold justify-center items-center overflow-visible">
								<button className="flex-1 rounded-xl">
									<img src="Play.svg" className="inline-block min-w-4 min-h-4" />
								</button>
								<button className=" flex-1">
									<img src="trash.svg" className="inline-block min-w-4 min-h-4" />
								</button>
								<button className=" flex-1">
									<img src="Plus.svg" className="inline-block min-w-6 min-h-6" />
								</button>
							</div>
						</div>
					</div>
				</div>
				<div className="flex flex-1 gap-4 flex-col w-full overflow-auto">
					<div className="flex gap-4 shadow-xl/30 p-4 rounded-2xl">
						<img src="playlist1.png" className="w-[98px] h-[56px]"/>
						<div>
							<p className="text-[#A9A9A9]">Batman v Superman: Dawn of Justice</p>
							<p className="text-[#414141]">2016</p>
						</div>
					</div>

					<div className="flex gap-4 shadow-xl/30 p-4 rounded-2xl">
						<img src="playlist2.png" className="w-[98px] h-[56px]"/>
						<div>
							<p className="text-[#A9A9A9]">Suicide Squad 2016</p>
							<p className="text-[#414141]">2016</p>
						</div>
					</div>

					<div className="flex gap-4 shadow-xl/30 p-4 rounded-2xl">
						<img src="playlist3.png" className="w-[98px] h-[56px]"/>
						<div>
							<p className="text-[#A9A9A9]">Zack Snyder's Justice League</p>
							<p className="text-[#414141]">2021</p>
						</div>
					</div>

					<div className="flex gap-4 shadow-xl/30 p-4 rounded-2xl">
						<img src="movie1.png" className="w-[98px] h-[56px]"/>
						<div>
							<p className="text-[#A9A9A9]">Justice league 2017</p>
							<p className="text-[#414141]">2021</p>
						</div>
					</div>
				</div>
			</div>
		</div>

	);
}