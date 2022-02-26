import React, { useState } from "react";
import styled from "styled-components";
import { usePhlote } from "../hooks/usePhlote";
import { Curation } from "../components/Forms/CurationSubmissionForm";
import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import { HollowButtonContainer, HollowButton } from "../components/Hollow";
import { useSubmitSidenavOpen } from "../components/SideNav";
import { useShortenedWallet } from "../components/Account";
import { ArchiveLayout } from "../components/Layouts";
import { BigNumber } from "ethers";
import { useIsCurator } from "../hooks/useIsCurator";
import { useRouter } from "next/router";
import { ArchiveCuration } from "../types/curations";
import { useSearchTerm } from "../components/SearchBar";
import { useNFTSearch } from "../hooks/useNFTSearch";

// const userCurationsAtom = atom<ArchiveCuration[]>([]);
// export const useUserCurations = () => useAtom(userCurationsAtom);

function Archive() {
  const { active } = useWeb3React();
  const isCurator = useIsCurator();
  const router = useRouter();

  React.useEffect(() => {
    if (isCurator.data && !isCurator.data.isCurator) router.replace("/");
  }, [isCurator.data]);

  const [, setOpen] = useSubmitSidenavOpen();

  const [searchTerm] = useSearchTerm();
  const curations = useNFTSearch(searchTerm);

  //   const getCurations = React.useCallback(async () => {
  //     const submissions = await phlote.getCuratorSubmissions(account);
  //     const reversed = (
  //       [...submissions] as unknown as ArchiveCuration[]
  //     ).reverse();
  //     setCurations(reversed);
  //   }, [phlote, account, setCurations]);

  //   React.useEffect(() => {
  //     if (phlote && account) {
  //       getCurations();
  //       phlote.on("*", (res) => {
  //         console.log(res);
  //         if (res.event === "EditionCreated") {
  //           getCurations();
  //         }
  //       });
  //     }

  //     return () => {
  //       phlote?.removeAllListeners();
  //     };
  //   }, [phlote, account, getCurations]);

  return (
    <ArchiveLayout center={curations.length === 0}>
      <div className="flex flex-col mt-24 min-h-full">
        {curations.length === 0 && (
          <div className="flex flex-col justify-center align-items">
            <div
              className="text-lg italic"
              style={{ color: "rgba(105, 105, 105, 1)" }}
            >
              {active ? "No Curated Works" : "No Wallet Connected"}
            </div>
            <div className="h-8"></div>
            {active && (
              <HollowButtonContainer
                className="w-32 cursor-pointer mx-auto"
                onClick={() => {
                  setOpen(true);
                }}
              >
                <HollowButton>{"Submit"}</HollowButton>
              </HollowButtonContainer>
            )}
          </div>
        )}
        {curations.length > 0 && (
          <div className="flex min-h-full">
            <div className="h-16" />
            <table className="table-fixed w-full text-center flex-grow">
              <thead>
                <tr
                  style={{
                    borderBottom: "1px solid white",
                    paddingBottom: "1rem",
                  }}
                >
                  <th className="pb-4">Date</th>
                  <th className="pb-4">Artist</th>
                  <th className="pb-4">Title</th>
                  <th className="pb-4">Media Type</th>
                  <th className="pb-4">Marketplace</th>
                  <th className="pb-4">Curator Wallet</th>
                </tr>
              </thead>

              <tbody>
                <tr className="h-4" />
                {curations?.map((curation) => {
                  const {
                    curatorWallet,
                    artistName,
                    mediaTitle,
                    mediaType,
                    mediaURI,
                    marketplace,
                    transactionPending,
                    submissionTime,
                  } = curation;

                  return (
                    <>
                      <ArchiveTableRow
                        style={
                          transactionPending ? { opacity: 0.5 } : undefined
                        }
                        key={`${submissionTime}`}
                      >
                        <ArchiveTableDataCell>
                          {submissionTimeToDate(submissionTime)}
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          {artistName}
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          <a
                            rel="noreferrer"
                            target="_blank"
                            href={mediaURI}
                            className="underline"
                          >
                            {mediaTitle}
                          </a>
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          {marketplace}
                        </ArchiveTableDataCell>
                        <ArchiveTableDataCell>
                          <CuratorWallet wallet={curatorWallet} />
                        </ArchiveTableDataCell>
                      </ArchiveTableRow>
                      <tr className="h-4" />
                    </>
                  );
                })}
              </tbody>
            </table>
            <div className="flex-grow" />
          </div>
        )}
      </div>
    </ArchiveLayout>
  );
}

const submissionTimeToDate = (submissionTime: BigNumber | number) => {
  let time = submissionTime;
  if (submissionTime instanceof BigNumber) {
    time = submissionTime.toNumber();
    // do something
  }

  return new Date((time as number) * 1000).toLocaleDateString();
};

const CuratorWallet: React.FC<{ wallet: string }> = ({ wallet }) => {
  const short = useShortenedWallet(wallet);
  return <span>{short}</span>;
};

const ArchiveTableRow = styled.tr`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  height: 3.5rem;
  align-items: center;
  padding-top: 1rem;
  padding-bottom: 1rem;

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;

const ArchiveTableDataCell = styled.td`
  background: ${(props) =>
    props.backgroundColor ?? "rgba(242, 244, 248, 0.17)"};

  color: white;
  height: 3.5rem;
  align-items: center;

  &:first-child {
    border-radius: 999px 0 0 999px;
  }

  &:last-child {
    border-radius: 0 999px 999px 0;
  }
`;

export default Archive;
