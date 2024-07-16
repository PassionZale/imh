/** @type {import('next').NextConfig} */
const nextConfig = {
	outputFileTracingIncludes: {
		'/api/usrs/[id]': ['./app/database/**/*.json']
	}
};

export default nextConfig;
