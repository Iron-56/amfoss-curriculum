'use client';

import Image from "next/image";
import { useState } from 'react';
import { Poppins, Inter } from 'next/font/google';
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
		<div>
			<div className="flex flex-col gap-6 p-2 sm:p-6 md:p-12">
				<p className="text-3xl mt-2 font-black">Following</p>
				<div className="flex flex-col gap-2">
					<div className="flex w-full bg-[#282828] justify-between gap-4 sm:flex-row flex-col lg:flex-nowrap px-6 py-4 rounded-2xl shadow-[0_8px_30px_rgba(0,0,0,0.35)]">
						<div className="flex gap-6 items-center">
							<img src="profile.svg" className="h-10 w-10 rounded-xl"/>
							<p>Username</p>
						</div>
						<div className="flex gap-2 sm:flex-col justify-between items-end sm:justify-center">
							<button onClick={() => setIsPopupOpen(true)} className="bg-[#1A1A1A] px-4 py-2 rounded-xl">Following</button>
							<p className="text-sm">18d</p>
						</div>
					</div>
				</div>
				
			</div>

			<PromptPopup isOpen={isPopupOpen} prompt="Are you sure you want to Unfollow?" warning="" accept="Delete" onClose={() => setIsPopupOpen(false)}/>
		</div>
		
	);
}