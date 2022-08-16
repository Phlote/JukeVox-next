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
      colors: {
        phlote: {
          container: "rgba(242, 244, 248, 0.17)",
          button: "rgba(0, 0, 0, 0.47)",
          // these should only be used for firefox because they don't support filter-blur
          "ff-modal": "#292929",
          "ff-sidenav": "#1d1d1d",
          dropdown: "#1d1d1d",
        },
      },
    },
  },
  plugins: [],
};
