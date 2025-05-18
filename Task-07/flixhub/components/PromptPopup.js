
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

export default function PromptPopup({ isOpen, prompt, warning, accept, onClose }) {
	if (!isOpen) return null;
	const [enabled, setEnabled] = useState(true);

	return (
		<div className="fixed text-center inset-0 bg-[rgba(2.25,40,46,0.85)] flex items-center justify-center p-4 z-50">
			<div className="bg-[#1E1E1E] w-full max-w-md flex flex-col items-center border border-[#000000] shadow-2xl rounded-2xl">
				<div className="p-6 space-y-2 text-sm sm:text-base">
					<p className="text-white font-medium">{prompt}</p>
					<p className="text-[#B90000]">{warning}</p>
				</div>

				<div className="flex w-full border-t border-black divide-y sm:divide-y-0 sm:divide-x divide-black flex-col text-sm sm:flex-row sm:text-base">
					<button onClick={onClose} className="py-4 flex-1 text-white hover:bg-[#2a2a2a] rounded-bl-xl transition">Cancel</button>
					<button className="py-4 flex-1 text-[#B90000] hover:bg-[#2a2a2a] rounded-br-xl transition">{accept}</button>
				</div>
			</div>
		</div>
	);
}
