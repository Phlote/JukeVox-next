import { apollo } from "../lib/apollo";
import {
  PublicationsDocument,
  PublicationsQueryRequest,
  PublicationTypes,
} from "../utils/graphql/generated";

const getPublicationsRequest = async (request: PublicationsQueryRequest) => {
  const result = await apollo.query({
    query: PublicationsDocument,
    variables: {
      request,
    },
  });

  return result.data.publications;
};

export const getPublications = async (profile: any) => {
  if (!profile?.id) {
    throw new Error("Lens profile not found");
  }

  const result = await getPublicationsRequest({
    profileId: profile.id,
    publicationTypes: [
      PublicationTypes.Post,
      PublicationTypes.Comment,
      PublicationTypes.Mirror,
    ],
  });

  return result;
};
