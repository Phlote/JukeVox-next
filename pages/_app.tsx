import { Web3ReactProvider } from "@web3-react/core";
import type { AppProps } from "next/app";
import Head from "next/head";
import { QueryClient, QueryClientProvider } from "react-query";
import "tailwindcss/tailwind.css";
import "../styles/globals.css";
import getLibrary from "../utils/getLibrary";

const queryClient = new QueryClient();

const NextWeb3App = ({ Component, pageProps }: AppProps) => {
  return (
    <>
      <Head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <title>Phlote Search</title>
        <link rel="icon" href="/favicon.svg" type="image/svg+xml" />
        {/* TODO edit this png to be a square */}
        <link rel="icon" type="image/png" href="/favicon.png" />
        <link rel="icon" href="/favicon.ico" sizes="any" />
      </Head>
      <QueryClientProvider client={queryClient}>
        <Web3ReactProvider getLibrary={getLibrary}>
          <Component {...pageProps} />
        </Web3ReactProvider>
      </QueryClientProvider>
    </>
  );
};

export default NextWeb3App;
