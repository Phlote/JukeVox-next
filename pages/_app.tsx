import { Web3ReactProvider } from "@web3-react/core";
import type { AppProps } from "next/app";
import { QueryClient, QueryClientProvider } from "react-query";
import getLibrary from "../getLibrary";
import "../styles/globals.css";
import { MoralisProvider } from "react-moralis";

const queryClient = new QueryClient();

const NextWeb3App = ({ Component, pageProps }: AppProps) => {
  return (
    <QueryClientProvider client={queryClient}>
      <Web3ReactProvider getLibrary={getLibrary}>
        <MoralisProvider
          appId={process.env.NEXT_PUBLIC_MORALIS_APP_ID}
          serverUrl={process.env.NEXT_PUBLIC_MORALIS_SERVER_URL}
        >
          <Component {...pageProps} />
        </MoralisProvider>
      </Web3ReactProvider>
    </QueryClientProvider>
  );
};

export default NextWeb3App;
