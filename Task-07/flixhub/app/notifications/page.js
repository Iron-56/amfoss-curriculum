'use client';

import Image from "next/image";
import { Poppins, Inter } from 'next/font/google';
import { useState } from 'react';
import ProfilePopup from "@/components/ProfilePopup";

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
		<div className="flex flex-col gap-6 p-2 sm:p-6 md:p-12">
			<p className="text-3xl mt-2 font-black">Notifications</p>
			<div className="flex flex-col gap-2">
				<div className="flex w-full bg-[#282828] justify-between gap-4 sm:flex-row flex-col lg:flex-nowrap px-6 py-4 rounded-2xl shadow-[0_8px_30px_rgba(0,0,0,0.35)]">
					<button className="flex gap-6 items-center" onClick={() => setIsPopupOpen(true)}>
						<img src="profile.svg" className="h-10 w-10 rounded-xl"/>
						<p>User has followed you.</p>
					</button>
					<div className="flex gap-2 sm:flex-col justify-between items-end sm:justify-center">
						<p className="text-[#0094D4] text-lg">Follow back</p>
						<p className="text-sm">18d</p>
					</div>
				</div>
				<div className="flex w-full bg-[#282828] justify-between gap-4 flex-row items-end lg:flex-nowrap px-6 py-4 rounded-2xl shadow-[0_8px_30px_rgba(0,0,0,0.35)]">
					<div className="flex gap-6 items-center">
						<img src="chat.svg" className="h-8 w-8"/>
						<div className="flex-col flex">
							<p>You commented on</p>
							<p className="text-[#099EB8]">Batman Begins</p>
						</div>
					</div>
					<p className="text-sm">18d</p>
				</div>
				<div className="flex w-full bg-[#282828] justify-between gap-4 sm:flex-row flex-col lg:flex-nowrap px-6 py-4 rounded-2xl shadow-[0_8px_30px_rgba(0,0,0,0.35)]">
					<div className="flex gap-6 items-center">
						<img src="profile.svg" className="h-10 w-10 rounded-xl"/>
						<p>User has followed you.</p>
					</div>
					<div className="flex gap-2 sm:flex-col justify-between items-end sm:justify-center">
						<p className="text-[#0094D4] text-lg">Follow back</p>
						<p className="text-sm">18d</p>
					</div>
				</div>
				<div className="flex w-full bg-[#282828] justify-between gap-4 sm:flex-row flex-col lg:flex-nowrap px-6 py-4 rounded-2xl shadow-[0_8px_30px_rgba(0,0,0,0.35)]">
					<div className="flex gap-6 items-center">
						<img src="profile.svg" className="h-10 w-10 rounded-xl"/>
						<p>User has followed you.</p>
					</div>
					<div className="flex gap-2 sm:flex-col justify-between items-end sm:justify-center">
						<p className="text-[#0094D4] text-lg">Follow back</p>
						<p className="text-sm">18d</p>
					</div>
				</div>
				<div className="flex w-full bg-[#282828] justify-between gap-4 sm:flex-row flex-col lg:flex-nowrap px-6 py-4 rounded-2xl shadow-[0_8px_30px_rgba(0,0,0,0.35)]">
					<div className="flex gap-6 items-center">
						<img src="profile.svg" className="h-10 w-10 rounded-xl"/>
						<p>User has followed you.</p>
					</div>
					<div className="flex gap-2 sm:flex-col justify-between items-end sm:justify-center">
						<p className="text-[#0094D4] text-lg">Follow back</p>
						<p className="text-sm">18d</p>
					</div>
				</div>
			</div>
			<ProfilePopup isOpen={isPopupOpen} onClose={() => setIsPopupOpen(false)} />
		</div>
	);
}