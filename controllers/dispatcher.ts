import { gql } from "@apollo/client";
import { apollo } from "../lib/apollo";
import {
  CreateSetDispatcherTypedDataDocument,
  SetDispatcherRequest,
} from "../utils/graphql/generated";

const CREATE_SET_DISPATCHER_TYPED_DATA = `
mutation($request: SetDispatcherRequest!) { 
  createSetDispatcherTypedData(request: $request) {
    id
    expiresAt
    typedData {
      types {
        SetDispatcherWithSig {
          name
          type
        }
      }
      domain {
        name
        chainId
        version
        verifyingContract
      }
      value {
        nonce
        deadline
        profileId
        dispatcher
      }
    }
  }
}
`;

export const enableDispatcherWithTypedData = async (
  request: SetDispatcherRequest
) => {
  const result = await apollo.mutate({
    mutation: CreateSetDispatcherTypedDataDocument,
    variables: {
      request,
    },
  });

  return result.data!.createSetDispatcherTypedData;
};

export const disableDispatcherWithTypedData = async (
  request: SetDispatcherRequest
) => {
  const result = await apollo.mutate({
    mutation: CreateSetDispatcherTypedDataDocument,
    variables: {
      request,
    },
  });

  return result.data!.createSetDispatcherTypedData;
};
