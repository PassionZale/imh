/** @type {import('next').NextConfig} */
const nextConfig = {
  experimental: {
    outputFileTracingIncludes: {
      "/api/usrs/[id]": ["./app/database/**/*"],
    },
  },
};

export default nextConfig;
