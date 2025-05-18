
import { Poppins, Inter } from 'next/font/google';
import './globals.css';
import LayoutWrapper from './LayoutWrapper';

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

export const metadata = {
	title: 'FlixHub',
	icons: {
		icon: '/favicon.ico',
		shortcut: '/favicon.ico',
	},
	description: 'Movie browsing app',
};

export default function RootLayout({ children }) {
	return (
		<html lang="en">
			<body className="antialiased">
				<LayoutWrapper poppins={poppins} inter={inter}>
					{children}
				</LayoutWrapper>
			</body>
		</html>
	);
}
