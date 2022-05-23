import { TypedDocumentNode as DocumentNode } from '@graphql-typed-document-node/core';
export type Maybe<T> = T | null;
export type InputMaybe<T> = Maybe<T>;
export type Exact<T extends { [key: string]: unknown }> = { [K in keyof T]: T[K] };
export type MakeOptional<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]?: Maybe<T[SubKey]> };
export type MakeMaybe<T, K extends keyof T> = Omit<T, K> & { [SubKey in K]: Maybe<T[SubKey]> };
/** All built-in and custom scalars, mapped to their actual values */
export type Scalars = {
  ID: string;
  String: string;
  Boolean: boolean;
  Int: number;
  Float: number;
  BigDecimal: number;
  BigInt: number;
  Bytes: Uint8Array;
};

/** The block at which the query should be executed. */
export type Block_Height = {
  /** Value containing a block hash */
  hash?: InputMaybe<Scalars['Bytes']>;
  /** Value containing a block number */
  number?: InputMaybe<Scalars['Int']>;
  /**
   * Value containing the minimum block number.
   * In the case of `number_gte`, the query will be executed on the latest block only if
   * the subgraph has progressed to or past the minimum block number.
   * Defaults to the latest block when omitted.
   *
   */
  number_gte?: InputMaybe<Scalars['Int']>;
};

export type CuratorAdminRole = {
  __typename?: 'CuratorAdminRole';
  id: Scalars['ID'];
  isCuratorAdmin?: Maybe<Scalars['Boolean']>;
};

export type CuratorAdminRole_Filter = {
  id?: InputMaybe<Scalars['ID']>;
  id_gt?: InputMaybe<Scalars['ID']>;
  id_gte?: InputMaybe<Scalars['ID']>;
  id_in?: InputMaybe<Array<Scalars['ID']>>;
  id_lt?: InputMaybe<Scalars['ID']>;
  id_lte?: InputMaybe<Scalars['ID']>;
  id_not?: InputMaybe<Scalars['ID']>;
  id_not_in?: InputMaybe<Array<Scalars['ID']>>;
  isCuratorAdmin?: InputMaybe<Scalars['Boolean']>;
  isCuratorAdmin_in?: InputMaybe<Array<Scalars['Boolean']>>;
  isCuratorAdmin_not?: InputMaybe<Scalars['Boolean']>;
  isCuratorAdmin_not_in?: InputMaybe<Array<Scalars['Boolean']>>;
};

export enum CuratorAdminRole_OrderBy {
  Id = 'id',
  IsCuratorAdmin = 'isCuratorAdmin'
}

export type CuratorRole = {
  __typename?: 'CuratorRole';
  id: Scalars['ID'];
  isCurator?: Maybe<Scalars['Boolean']>;
};

export type CuratorRole_Filter = {
  id?: InputMaybe<Scalars['ID']>;
  id_gt?: InputMaybe<Scalars['ID']>;
  id_gte?: InputMaybe<Scalars['ID']>;
  id_in?: InputMaybe<Array<Scalars['ID']>>;
  id_lt?: InputMaybe<Scalars['ID']>;
  id_lte?: InputMaybe<Scalars['ID']>;
  id_not?: InputMaybe<Scalars['ID']>;
  id_not_in?: InputMaybe<Array<Scalars['ID']>>;
  isCurator?: InputMaybe<Scalars['Boolean']>;
  isCurator_in?: InputMaybe<Array<Scalars['Boolean']>>;
  isCurator_not?: InputMaybe<Scalars['Boolean']>;
  isCurator_not_in?: InputMaybe<Array<Scalars['Boolean']>>;
};

export enum CuratorRole_OrderBy {
  Id = 'id',
  IsCurator = 'isCurator'
}

/** Defines the order direction, either ascending or descending */
export enum OrderDirection {
  Asc = 'asc',
  Desc = 'desc'
}

export type Query = {
  __typename?: 'Query';
  /** Access to subgraph metadata */
  _meta?: Maybe<_Meta_>;
  curatorAdminRole?: Maybe<CuratorAdminRole>;
  curatorAdminRoles: Array<CuratorAdminRole>;
  curatorRole?: Maybe<CuratorRole>;
  curatorRoles: Array<CuratorRole>;
  submission?: Maybe<Submission>;
  submissions: Array<Submission>;
  submissionsSearch: Array<Submission>;
};


export type Query_MetaArgs = {
  block?: InputMaybe<Block_Height>;
};


export type QueryCuratorAdminRoleArgs = {
  block?: InputMaybe<Block_Height>;
  id: Scalars['ID'];
  subgraphError?: _SubgraphErrorPolicy_;
};


export type QueryCuratorAdminRolesArgs = {
  block?: InputMaybe<Block_Height>;
  first?: InputMaybe<Scalars['Int']>;
  orderBy?: InputMaybe<CuratorAdminRole_OrderBy>;
  orderDirection?: InputMaybe<OrderDirection>;
  skip?: InputMaybe<Scalars['Int']>;
  subgraphError?: _SubgraphErrorPolicy_;
  where?: InputMaybe<CuratorAdminRole_Filter>;
};


export type QueryCuratorRoleArgs = {
  block?: InputMaybe<Block_Height>;
  id: Scalars['ID'];
  subgraphError?: _SubgraphErrorPolicy_;
};


export type QueryCuratorRolesArgs = {
  block?: InputMaybe<Block_Height>;
  first?: InputMaybe<Scalars['Int']>;
  orderBy?: InputMaybe<CuratorRole_OrderBy>;
  orderDirection?: InputMaybe<OrderDirection>;
  skip?: InputMaybe<Scalars['Int']>;
  subgraphError?: _SubgraphErrorPolicy_;
  where?: InputMaybe<CuratorRole_Filter>;
};


export type QuerySubmissionArgs = {
  block?: InputMaybe<Block_Height>;
  id: Scalars['ID'];
  subgraphError?: _SubgraphErrorPolicy_;
};


export type QuerySubmissionsArgs = {
  block?: InputMaybe<Block_Height>;
  first?: InputMaybe<Scalars['Int']>;
  orderBy?: InputMaybe<Submission_OrderBy>;
  orderDirection?: InputMaybe<OrderDirection>;
  skip?: InputMaybe<Scalars['Int']>;
  subgraphError?: _SubgraphErrorPolicy_;
  where?: InputMaybe<Submission_Filter>;
};


export type QuerySubmissionsSearchArgs = {
  block?: InputMaybe<Block_Height>;
  first?: InputMaybe<Scalars['Int']>;
  skip?: InputMaybe<Scalars['Int']>;
  subgraphError?: _SubgraphErrorPolicy_;
  text: Scalars['String'];
};

export type Submission = {
  __typename?: 'Submission';
  artistName: Scalars['String'];
  artistWallet?: Maybe<Scalars['Bytes']>;
  cosigns?: Maybe<Array<Scalars['Bytes']>>;
  id: Scalars['ID'];
  marketplace: Scalars['String'];
  mediaTitle: Scalars['String'];
  mediaType: Scalars['String'];
  mediaURI: Scalars['String'];
  submitterWallet: Scalars['Bytes'];
  tags?: Maybe<Scalars['String']>;
  timestamp: Scalars['BigInt'];
};

export type Submission_Filter = {
  artistName?: InputMaybe<Scalars['String']>;
  artistName_contains?: InputMaybe<Scalars['String']>;
  artistName_contains_nocase?: InputMaybe<Scalars['String']>;
  artistName_ends_with?: InputMaybe<Scalars['String']>;
  artistName_ends_with_nocase?: InputMaybe<Scalars['String']>;
  artistName_gt?: InputMaybe<Scalars['String']>;
  artistName_gte?: InputMaybe<Scalars['String']>;
  artistName_in?: InputMaybe<Array<Scalars['String']>>;
  artistName_lt?: InputMaybe<Scalars['String']>;
  artistName_lte?: InputMaybe<Scalars['String']>;
  artistName_not?: InputMaybe<Scalars['String']>;
  artistName_not_contains?: InputMaybe<Scalars['String']>;
  artistName_not_contains_nocase?: InputMaybe<Scalars['String']>;
  artistName_not_ends_with?: InputMaybe<Scalars['String']>;
  artistName_not_ends_with_nocase?: InputMaybe<Scalars['String']>;
  artistName_not_in?: InputMaybe<Array<Scalars['String']>>;
  artistName_not_starts_with?: InputMaybe<Scalars['String']>;
  artistName_not_starts_with_nocase?: InputMaybe<Scalars['String']>;
  artistName_starts_with?: InputMaybe<Scalars['String']>;
  artistName_starts_with_nocase?: InputMaybe<Scalars['String']>;
  artistWallet?: InputMaybe<Scalars['Bytes']>;
  artistWallet_contains?: InputMaybe<Scalars['Bytes']>;
  artistWallet_in?: InputMaybe<Array<Scalars['Bytes']>>;
  artistWallet_not?: InputMaybe<Scalars['Bytes']>;
  artistWallet_not_contains?: InputMaybe<Scalars['Bytes']>;
  artistWallet_not_in?: InputMaybe<Array<Scalars['Bytes']>>;
  cosigns?: InputMaybe<Array<Scalars['Bytes']>>;
  cosigns_contains?: InputMaybe<Array<Scalars['Bytes']>>;
  cosigns_contains_nocase?: InputMaybe<Array<Scalars['Bytes']>>;
  cosigns_not?: InputMaybe<Array<Scalars['Bytes']>>;
  cosigns_not_contains?: InputMaybe<Array<Scalars['Bytes']>>;
  cosigns_not_contains_nocase?: InputMaybe<Array<Scalars['Bytes']>>;
  id?: InputMaybe<Scalars['ID']>;
  id_gt?: InputMaybe<Scalars['ID']>;
  id_gte?: InputMaybe<Scalars['ID']>;
  id_in?: InputMaybe<Array<Scalars['ID']>>;
  id_lt?: InputMaybe<Scalars['ID']>;
  id_lte?: InputMaybe<Scalars['ID']>;
  id_not?: InputMaybe<Scalars['ID']>;
  id_not_in?: InputMaybe<Array<Scalars['ID']>>;
  marketplace?: InputMaybe<Scalars['String']>;
  marketplace_contains?: InputMaybe<Scalars['String']>;
  marketplace_contains_nocase?: InputMaybe<Scalars['String']>;
  marketplace_ends_with?: InputMaybe<Scalars['String']>;
  marketplace_ends_with_nocase?: InputMaybe<Scalars['String']>;
  marketplace_gt?: InputMaybe<Scalars['String']>;
  marketplace_gte?: InputMaybe<Scalars['String']>;
  marketplace_in?: InputMaybe<Array<Scalars['String']>>;
  marketplace_lt?: InputMaybe<Scalars['String']>;
  marketplace_lte?: InputMaybe<Scalars['String']>;
  marketplace_not?: InputMaybe<Scalars['String']>;
  marketplace_not_contains?: InputMaybe<Scalars['String']>;
  marketplace_not_contains_nocase?: InputMaybe<Scalars['String']>;
  marketplace_not_ends_with?: InputMaybe<Scalars['String']>;
  marketplace_not_ends_with_nocase?: InputMaybe<Scalars['String']>;
  marketplace_not_in?: InputMaybe<Array<Scalars['String']>>;
  marketplace_not_starts_with?: InputMaybe<Scalars['String']>;
  marketplace_not_starts_with_nocase?: InputMaybe<Scalars['String']>;
  marketplace_starts_with?: InputMaybe<Scalars['String']>;
  marketplace_starts_with_nocase?: InputMaybe<Scalars['String']>;
  mediaTitle?: InputMaybe<Scalars['String']>;
  mediaTitle_contains?: InputMaybe<Scalars['String']>;
  mediaTitle_contains_nocase?: InputMaybe<Scalars['String']>;
  mediaTitle_ends_with?: InputMaybe<Scalars['String']>;
  mediaTitle_ends_with_nocase?: InputMaybe<Scalars['String']>;
  mediaTitle_gt?: InputMaybe<Scalars['String']>;
  mediaTitle_gte?: InputMaybe<Scalars['String']>;
  mediaTitle_in?: InputMaybe<Array<Scalars['String']>>;
  mediaTitle_lt?: InputMaybe<Scalars['String']>;
  mediaTitle_lte?: InputMaybe<Scalars['String']>;
  mediaTitle_not?: InputMaybe<Scalars['String']>;
  mediaTitle_not_contains?: InputMaybe<Scalars['String']>;
  mediaTitle_not_contains_nocase?: InputMaybe<Scalars['String']>;
  mediaTitle_not_ends_with?: InputMaybe<Scalars['String']>;
  mediaTitle_not_ends_with_nocase?: InputMaybe<Scalars['String']>;
  mediaTitle_not_in?: InputMaybe<Array<Scalars['String']>>;
  mediaTitle_not_starts_with?: InputMaybe<Scalars['String']>;
  mediaTitle_not_starts_with_nocase?: InputMaybe<Scalars['String']>;
  mediaTitle_starts_with?: InputMaybe<Scalars['String']>;
  mediaTitle_starts_with_nocase?: InputMaybe<Scalars['String']>;
  mediaType?: InputMaybe<Scalars['String']>;
  mediaType_contains?: InputMaybe<Scalars['String']>;
  mediaType_contains_nocase?: InputMaybe<Scalars['String']>;
  mediaType_ends_with?: InputMaybe<Scalars['String']>;
  mediaType_ends_with_nocase?: InputMaybe<Scalars['String']>;
  mediaType_gt?: InputMaybe<Scalars['String']>;
  mediaType_gte?: InputMaybe<Scalars['String']>;
  mediaType_in?: InputMaybe<Array<Scalars['String']>>;
  mediaType_lt?: InputMaybe<Scalars['String']>;
  mediaType_lte?: InputMaybe<Scalars['String']>;
  mediaType_not?: InputMaybe<Scalars['String']>;
  mediaType_not_contains?: InputMaybe<Scalars['String']>;
  mediaType_not_contains_nocase?: InputMaybe<Scalars['String']>;
  mediaType_not_ends_with?: InputMaybe<Scalars['String']>;
  mediaType_not_ends_with_nocase?: InputMaybe<Scalars['String']>;
  mediaType_not_in?: InputMaybe<Array<Scalars['String']>>;
  mediaType_not_starts_with?: InputMaybe<Scalars['String']>;
  mediaType_not_starts_with_nocase?: InputMaybe<Scalars['String']>;
  mediaType_starts_with?: InputMaybe<Scalars['String']>;
  mediaType_starts_with_nocase?: InputMaybe<Scalars['String']>;
  mediaURI?: InputMaybe<Scalars['String']>;
  mediaURI_contains?: InputMaybe<Scalars['String']>;
  mediaURI_contains_nocase?: InputMaybe<Scalars['String']>;
  mediaURI_ends_with?: InputMaybe<Scalars['String']>;
  mediaURI_ends_with_nocase?: InputMaybe<Scalars['String']>;
  mediaURI_gt?: InputMaybe<Scalars['String']>;
  mediaURI_gte?: InputMaybe<Scalars['String']>;
  mediaURI_in?: InputMaybe<Array<Scalars['String']>>;
  mediaURI_lt?: InputMaybe<Scalars['String']>;
  mediaURI_lte?: InputMaybe<Scalars['String']>;
  mediaURI_not?: InputMaybe<Scalars['String']>;
  mediaURI_not_contains?: InputMaybe<Scalars['String']>;
  mediaURI_not_contains_nocase?: InputMaybe<Scalars['String']>;
  mediaURI_not_ends_with?: InputMaybe<Scalars['String']>;
  mediaURI_not_ends_with_nocase?: InputMaybe<Scalars['String']>;
  mediaURI_not_in?: InputMaybe<Array<Scalars['String']>>;
  mediaURI_not_starts_with?: InputMaybe<Scalars['String']>;
  mediaURI_not_starts_with_nocase?: InputMaybe<Scalars['String']>;
  mediaURI_starts_with?: InputMaybe<Scalars['String']>;
  mediaURI_starts_with_nocase?: InputMaybe<Scalars['String']>;
  submitterWallet?: InputMaybe<Scalars['Bytes']>;
  submitterWallet_contains?: InputMaybe<Scalars['Bytes']>;
  submitterWallet_in?: InputMaybe<Array<Scalars['Bytes']>>;
  submitterWallet_not?: InputMaybe<Scalars['Bytes']>;
  submitterWallet_not_contains?: InputMaybe<Scalars['Bytes']>;
  submitterWallet_not_in?: InputMaybe<Array<Scalars['Bytes']>>;
  tags?: InputMaybe<Scalars['String']>;
  tags_contains?: InputMaybe<Scalars['String']>;
  tags_contains_nocase?: InputMaybe<Scalars['String']>;
  tags_ends_with?: InputMaybe<Scalars['String']>;
  tags_ends_with_nocase?: InputMaybe<Scalars['String']>;
  tags_gt?: InputMaybe<Scalars['String']>;
  tags_gte?: InputMaybe<Scalars['String']>;
  tags_in?: InputMaybe<Array<Scalars['String']>>;
  tags_lt?: InputMaybe<Scalars['String']>;
  tags_lte?: InputMaybe<Scalars['String']>;
  tags_not?: InputMaybe<Scalars['String']>;
  tags_not_contains?: InputMaybe<Scalars['String']>;
  tags_not_contains_nocase?: InputMaybe<Scalars['String']>;
  tags_not_ends_with?: InputMaybe<Scalars['String']>;
  tags_not_ends_with_nocase?: InputMaybe<Scalars['String']>;
  tags_not_in?: InputMaybe<Array<Scalars['String']>>;
  tags_not_starts_with?: InputMaybe<Scalars['String']>;
  tags_not_starts_with_nocase?: InputMaybe<Scalars['String']>;
  tags_starts_with?: InputMaybe<Scalars['String']>;
  tags_starts_with_nocase?: InputMaybe<Scalars['String']>;
  timestamp?: InputMaybe<Scalars['BigInt']>;
  timestamp_gt?: InputMaybe<Scalars['BigInt']>;
  timestamp_gte?: InputMaybe<Scalars['BigInt']>;
  timestamp_in?: InputMaybe<Array<Scalars['BigInt']>>;
  timestamp_lt?: InputMaybe<Scalars['BigInt']>;
  timestamp_lte?: InputMaybe<Scalars['BigInt']>;
  timestamp_not?: InputMaybe<Scalars['BigInt']>;
  timestamp_not_in?: InputMaybe<Array<Scalars['BigInt']>>;
};

export enum Submission_OrderBy {
  ArtistName = 'artistName',
  ArtistWallet = 'artistWallet',
  Cosigns = 'cosigns',
  Id = 'id',
  Marketplace = 'marketplace',
  MediaTitle = 'mediaTitle',
  MediaType = 'mediaType',
  MediaUri = 'mediaURI',
  SubmitterWallet = 'submitterWallet',
  Tags = 'tags',
  Timestamp = 'timestamp'
}

export type Subscription = {
  __typename?: 'Subscription';
  /** Access to subgraph metadata */
  _meta?: Maybe<_Meta_>;
  curatorAdminRole?: Maybe<CuratorAdminRole>;
  curatorAdminRoles: Array<CuratorAdminRole>;
  curatorRole?: Maybe<CuratorRole>;
  curatorRoles: Array<CuratorRole>;
  submission?: Maybe<Submission>;
  submissions: Array<Submission>;
};


export type Subscription_MetaArgs = {
  block?: InputMaybe<Block_Height>;
};


export type SubscriptionCuratorAdminRoleArgs = {
  block?: InputMaybe<Block_Height>;
  id: Scalars['ID'];
  subgraphError?: _SubgraphErrorPolicy_;
};


export type SubscriptionCuratorAdminRolesArgs = {
  block?: InputMaybe<Block_Height>;
  first?: InputMaybe<Scalars['Int']>;
  orderBy?: InputMaybe<CuratorAdminRole_OrderBy>;
  orderDirection?: InputMaybe<OrderDirection>;
  skip?: InputMaybe<Scalars['Int']>;
  subgraphError?: _SubgraphErrorPolicy_;
  where?: InputMaybe<CuratorAdminRole_Filter>;
};


export type SubscriptionCuratorRoleArgs = {
  block?: InputMaybe<Block_Height>;
  id: Scalars['ID'];
  subgraphError?: _SubgraphErrorPolicy_;
};


export type SubscriptionCuratorRolesArgs = {
  block?: InputMaybe<Block_Height>;
  first?: InputMaybe<Scalars['Int']>;
  orderBy?: InputMaybe<CuratorRole_OrderBy>;
  orderDirection?: InputMaybe<OrderDirection>;
  skip?: InputMaybe<Scalars['Int']>;
  subgraphError?: _SubgraphErrorPolicy_;
  where?: InputMaybe<CuratorRole_Filter>;
};


export type SubscriptionSubmissionArgs = {
  block?: InputMaybe<Block_Height>;
  id: Scalars['ID'];
  subgraphError?: _SubgraphErrorPolicy_;
};


export type SubscriptionSubmissionsArgs = {
  block?: InputMaybe<Block_Height>;
  first?: InputMaybe<Scalars['Int']>;
  orderBy?: InputMaybe<Submission_OrderBy>;
  orderDirection?: InputMaybe<OrderDirection>;
  skip?: InputMaybe<Scalars['Int']>;
  subgraphError?: _SubgraphErrorPolicy_;
  where?: InputMaybe<Submission_Filter>;
};

export type _Block_ = {
  __typename?: '_Block_';
  /** The hash of the block */
  hash?: Maybe<Scalars['Bytes']>;
  /** The block number */
  number: Scalars['Int'];
};

/** The type for the top-level _meta field */
export type _Meta_ = {
  __typename?: '_Meta_';
  /**
   * Information about a specific subgraph block. The hash of the block
   * will be null if the _meta field has a block constraint that asks for
   * a block number. It will be filled if the _meta field has no block constraint
   * and therefore asks for the latest  block
   *
   */
  block: _Block_;
  /** The deployment ID */
  deployment: Scalars['String'];
  /** If `true`, the subgraph encountered indexing errors at some past block */
  hasIndexingErrors: Scalars['Boolean'];
};

export enum _SubgraphErrorPolicy_ {
  /** Data will be returned even if the subgraph has indexing errors */
  Allow = 'allow',
  /** If the subgraph has indexing errors, data will be omitted. The default. */
  Deny = 'deny'
}

export type GetAllSubmissionIDsQueryVariables = Exact<{ [key: string]: never; }>;


export type GetAllSubmissionIDsQuery = { __typename?: 'Query', submissions: Array<{ __typename?: 'Submission', id: string }> };

export type GetAllWalletsQueryVariables = Exact<{ [key: string]: never; }>;


export type GetAllWalletsQuery = { __typename?: 'Query', submissions: Array<{ __typename?: 'Submission', submitterWallet: Uint8Array }> };

export type GetCuratorAdminRoleForWalletQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetCuratorAdminRoleForWalletQuery = { __typename?: 'Query', curatorAdminRole?: { __typename?: 'CuratorAdminRole', id: string, isCuratorAdmin?: boolean | null } | null };

export type GetCuratorRoleForWalletQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetCuratorRoleForWalletQuery = { __typename?: 'Query', curatorRole?: { __typename?: 'CuratorRole', id: string, isCurator?: boolean | null } | null };

export type GetSubmissionByIdQueryVariables = Exact<{
  id: Scalars['ID'];
}>;


export type GetSubmissionByIdQuery = { __typename?: 'Query', submission?: { __typename?: 'Submission', id: string, timestamp: number, artistName: string, mediaTitle: string, mediaType: string, mediaURI: string, marketplace: string, cosigns?: Array<Uint8Array> | null, submitterWallet: Uint8Array } | null };

export type GetSubmissionsQueryVariables = Exact<{
  filter?: InputMaybe<Submission_Filter>;
}>;


export type GetSubmissionsQuery = { __typename?: 'Query', submissions: Array<{ __typename?: 'Submission', id: string, timestamp: number, artistName: string, mediaTitle: string, mediaType: string, mediaURI: string, marketplace: string, cosigns?: Array<Uint8Array> | null, submitterWallet: Uint8Array }> };

export type SubmissionArchiveFieldsFragment = { __typename?: 'Submission', id: string, timestamp: number, artistName: string, mediaTitle: string, mediaType: string, mediaURI: string, marketplace: string, cosigns?: Array<Uint8Array> | null, submitterWallet: Uint8Array };

export type SubmissionsSearchQueryVariables = Exact<{
  searchTerm: Scalars['String'];
}>;


export type SubmissionsSearchQuery = { __typename?: 'Query', submissionsSearch: Array<{ __typename?: 'Submission', id: string }> };

export const SubmissionArchiveFieldsFragmentDoc = {"kind":"Document","definitions":[{"kind":"FragmentDefinition","name":{"kind":"Name","value":"SubmissionArchiveFields"},"typeCondition":{"kind":"NamedType","name":{"kind":"Name","value":"Submission"}},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"timestamp"}},{"kind":"Field","name":{"kind":"Name","value":"artistName"}},{"kind":"Field","name":{"kind":"Name","value":"mediaTitle"}},{"kind":"Field","name":{"kind":"Name","value":"mediaType"}},{"kind":"Field","name":{"kind":"Name","value":"mediaURI"}},{"kind":"Field","name":{"kind":"Name","value":"marketplace"}},{"kind":"Field","name":{"kind":"Name","value":"cosigns"}},{"kind":"Field","name":{"kind":"Name","value":"submitterWallet"}}]}}]} as unknown as DocumentNode<SubmissionArchiveFieldsFragment, unknown>;
export const GetAllSubmissionIDsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetAllSubmissionIDs"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"submissions"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<GetAllSubmissionIDsQuery, GetAllSubmissionIDsQueryVariables>;
export const GetAllWalletsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetAllWallets"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"submissions"},"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"submitterWallet"}}]}}]}}]} as unknown as DocumentNode<GetAllWalletsQuery, GetAllWalletsQueryVariables>;
export const GetCuratorAdminRoleForWalletDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetCuratorAdminRoleForWallet"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"curatorAdminRole"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"isCuratorAdmin"}}]}}]}}]} as unknown as DocumentNode<GetCuratorAdminRoleForWalletQuery, GetCuratorAdminRoleForWalletQueryVariables>;
export const GetCuratorRoleForWalletDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetCuratorRoleForWallet"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"curatorRole"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}},{"kind":"Field","name":{"kind":"Name","value":"isCurator"}}]}}]}}]} as unknown as DocumentNode<GetCuratorRoleForWalletQuery, GetCuratorRoleForWalletQueryVariables>;
export const GetSubmissionByIdDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetSubmissionById"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"id"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"ID"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"submission"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"id"},"value":{"kind":"Variable","name":{"kind":"Name","value":"id"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"SubmissionArchiveFields"}}]}}]}},...SubmissionArchiveFieldsFragmentDoc.definitions]} as unknown as DocumentNode<GetSubmissionByIdQuery, GetSubmissionByIdQueryVariables>;
export const GetSubmissionsDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"GetSubmissions"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"filter"}},"type":{"kind":"NamedType","name":{"kind":"Name","value":"Submission_filter"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"submissions"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"where"},"value":{"kind":"Variable","name":{"kind":"Name","value":"filter"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"FragmentSpread","name":{"kind":"Name","value":"SubmissionArchiveFields"}}]}}]}},...SubmissionArchiveFieldsFragmentDoc.definitions]} as unknown as DocumentNode<GetSubmissionsQuery, GetSubmissionsQueryVariables>;
export const SubmissionsSearchDocument = {"kind":"Document","definitions":[{"kind":"OperationDefinition","operation":"query","name":{"kind":"Name","value":"SubmissionsSearch"},"variableDefinitions":[{"kind":"VariableDefinition","variable":{"kind":"Variable","name":{"kind":"Name","value":"searchTerm"}},"type":{"kind":"NonNullType","type":{"kind":"NamedType","name":{"kind":"Name","value":"String"}}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"submissionsSearch"},"arguments":[{"kind":"Argument","name":{"kind":"Name","value":"text"},"value":{"kind":"Variable","name":{"kind":"Name","value":"searchTerm"}}}],"selectionSet":{"kind":"SelectionSet","selections":[{"kind":"Field","name":{"kind":"Name","value":"id"}}]}}]}}]} as unknown as DocumentNode<SubmissionsSearchQuery, SubmissionsSearchQueryVariables>;