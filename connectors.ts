import { InjectedConnector } from "@web3-react/injected-connector";
import { POLYGON_CHAIN_ID } from "./constants";

export const injected = new InjectedConnector({
  supportedChainIds: [1, 3, 4, 5, 42, POLYGON_CHAIN_ID],
});
