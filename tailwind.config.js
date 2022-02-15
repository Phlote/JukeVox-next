module.exports = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx}",
    "./components/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Jeko", "sans-serif"],
      },
      textUnderlineOffset: {
        16: "16px",
      },
    },
  },
  plugins: [],
};
