// @ts-check

/**
 * @type {import('next').NextConfig}
 **/
module.exports = {
  reactStrictMode: true,
  // swcMinify: true,
  images: {
    domains: [
      "alytqvwillylytpmdjai.supabase.co",
      "erirxjohgmjhfdmzlqsa.supabase.co",
      "goekxcdbwpktmthbsbih.supabase.co",
    ],
    minimumCacheTTL: 60,
  },
};
