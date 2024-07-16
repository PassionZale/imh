/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    outputFileTracingIncludes: {
      "/api/users/[id]": ["./app/database/**/*.json"],
    },
  },
};

export default nextConfig;
