import { ApolloClient, InMemoryCache } from "@apollo/client";

export const client = new ApolloClient({
  uri: process.env.NEXT_PUBLIC_GRAPH_PROTOCOL_QUERY_URI,
  cache: new InMemoryCache(),
});
