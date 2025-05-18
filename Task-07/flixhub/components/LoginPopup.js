
import React from "react";
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

export default function LoginPopup({ isOpen, onClose }) {
	if (isOpen != "login") return null;

	return (
		<div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
			<div className="bg-[#1E1E1E] p-14 flex flex-col items-center w-[350px] border border-[#ff0000] justify-around gap-8 rounded-2xl relative">
				<button onClick={onClose} className="absolute top-2 right-3 text-white text-xl">✖</button>

				<p className={`${poppins.className} text-center text-2xl font-black m-0`}>
					<span className="text-[#099EB8]">Flix</span><span className="text-[#FD3232]">Hub</span>
				</p>

				<div className="flex w-full flex-col sm:flex-row gap-6">
					<button className="bg-[#2C2C2C] flex-1 w-full rounded-lg p-2">Register</button>
					<button className="bg-[#2C2C2C] flex-1 w-full rounded-lg p-2">Login</button>
				</div>

				<div className="flex w-full text-left text-[#717171] flex-col items-center justify-center gap-4">
					<div className="w-full">
						<p>Username</p>
						<input type="text" className="bg-[#151515] w-full h-[33px] rounded-xl mt-2" />
					</div>
					<div className="w-full">
						<p>Password</p>
						<input type="password" className="bg-[#151515] w-full h-[33px] rounded-xl mt-2" />
					</div>
				</div>

				<button className="bg-[#2C2C2C] flex-1 w-full rounded-lg p-2 border border-[#099EB8]">SIGN UP!</button>
			</div>
		</div>
	);
}
