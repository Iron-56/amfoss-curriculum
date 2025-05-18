
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
	if (isOpen != "settings") return null;
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
						<button className="bg-[#2C2C2C] p-2.5 rounded-lg"><img src="Logout.svg" className="w-4 h-4" /></button>
						<button onClick={onClose} className="bg-[#2C2C2C] p-2.5 rounded-lg text-[#989898] text-xl flex items-center justify-center w-[36px] h-[36px]">✖</button>
					</div>
				</nav>

				<div className="p-6 w-full flex flex-col text-sm gap-6">
					<div>
						<p className="text-[#CCCCCC] text-2xl font-semibold">About You</p>
						<div className="flex flex-col w-full p-4 gap-4">
							<div className="flex justify-between w-full items-center">
								<p>Username: </p>
								<button className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Change</button>
							</div>
							<div className="flex justify-between w-full items-center">
								<p>Password: </p>
								<button className="py-2 px-4 rounded-xl bg-[#2C2C2C]">Change</button>
							</div>
							<div className="flex justify-between w-full items-center">
								<button className="py-2 flex items-center gap-2 px-4 rounded-xl bg-[#2C2C2C]">
									<img src="profile.svg" className="w-6 h-6 rounded-full" />
									<p>Change Profile Picture</p>
								</button>
							</div>
						</div>
					</div>

					<div>
						<p className="text-[#CCCCCC] text-2xl font-semibold">Your Activity</p>
						<div className="flex justify-between p-4 w-full items-center gap-4 flex-wrap">
							<p>Share your Activity</p>
							<div className={`flex items-center space-x-4 ${enabled ? "text-green-600" : "text-red-600"}  rounded`}>
								<span className="hidden sm:block">{enabled ? "Enabled" : "Disabled"}</span>
								<button onClick={() => setEnabled(!enabled)} className={`w-16 h-8 flex items-center rounded-lg p-1 transition-colors duration-300 ${enabled ? "bg-black" : "bg-gray-700"}`}>
									<div className={`w-8 h-6 rounded-lg transition-transform duration-300 ${enabled ? "translate-x-6 bg-green-600" : "translate-x-0 bg-gray-400"}`}></div>
								</button>
							</div>
						</div>
					</div>

					<button className="bg-[#B90000] rounded-xl py-3 px-6 flex items-center self-center sm:self-end gap-2  font-semibold shadow-lg">
						<p>Delete Account</p>
						<img src="trash.svg" className="w-4 h-4" />
					</button>
				</div>
			</div>
		</div>
	);
}
