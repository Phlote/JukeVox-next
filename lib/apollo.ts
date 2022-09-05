import {
  HttpLink,
  ApolloClient,
  InMemoryCache,
  ApolloLink,
} from "@apollo/client";

const APIURL = "https://api-mumbai.lens.dev/";

const httpLink = new HttpLink({
  uri: APIURL,
  fetchOptions: "no-cors",
  fetch,
});

const authLink = new ApolloLink((operation, forward) => {
  const accessToken = localStorage.getItem("accessToken");
  operation.setContext({
    headers: {
      "x-access-token": accessToken ? `Bearer ${accessToken}` : "",
    },
  });
  return forward(operation);
});

export const apollo = new ApolloClient({
  link: authLink.concat(httpLink),
  cache: new InMemoryCache(),
});
