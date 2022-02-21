import React from "react";

import { HomeLayout } from "../components/Layouts";
import styled from "styled-components";
import { usePhlote } from "../hooks/usePhlote";
import { Curation } from "../components/Forms/CurationSubmissionForm";
import { useWeb3React } from "@web3-react/core";
import { atom, useAtom } from "jotai";
import { HollowButtonContainer, HollowButton } from "../components/Hollow";
import { useSubmitSidenavOpen } from "../components/SideNav";
import Account from "../components/Account";

type ArchiveCuration = Curation & { transactionPending?: boolean };

const userCurationsAtom = atom<ArchiveCuration[]>([]);
export const useUserCurations = () => useAtom(userCurationsAtom);

function Archive() {
  const { account, library, activate, active } = useWeb3React();

  const phlote = usePhlote();

  const [curations, setCurations] = useUserCurations();

  const [, setOpen] = useSubmitSidenavOpen();

  const getCurations = async () => {
    const submissions = await phlote.getCuratorSubmissions(account);
    setCurations(submissions as unknown as ArchiveCuration[]);
  };

  React.useEffect(() => {
    if (phlote && account) {
      getCurations();
      phlote.on("*", (res) => {
        console.log(res);
        if (res.event === "EditionCreated") {
          getCurations();
        }
      });
    }

    return () => {
      phlote?.removeAllListeners();
    };
  }, [phlote, account]);

  return (
    <HomeLayout>
      <div className="flex flex-col mt-8">
        {curations.length === 0 && (
          <div className="flex flex-col justify-center align-items">
            <div
              className="text-lgfont-extrabold	"
              style={{ color: "rgba(105, 105, 105, 1)" }}
            >
              {active ? "No Curated Works" : "No Wallet Connected"}
            </div>
            <div className="h-16"></div>
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
          <>
            <div className="h-16" />
            <table
              style={{ borderSpacing: "0 1rem", borderCollapse: "separate" }}
              className="table-fixed w-full text-center flex-grow"
            >
              <thead>
                <tr>
                  <th>Artist</th>
                  <th>Media Type</th>
                  <th>Marketplace</th>
                </tr>
              </thead>

              <tbody>
                {curations?.map((curation) => {
                  const {
                    artistName,
                    mediaType,
                    marketplace,
                    transactionPending,
                  } = curation;
                  return (
                    <ArchiveTableRow
                      style={transactionPending ? { opacity: 0.5 } : undefined}
                      key={`${artistName}${mediaType}${marketplace}`}
                    >
                      <ArchiveTableDataCell>{artistName}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>{mediaType}</ArchiveTableDataCell>
                      <ArchiveTableDataCell>{marketplace}</ArchiveTableDataCell>
                    </ArchiveTableRow>
                  );
                })}
              </tbody>
            </table>
          </>
        )}
      </div>
    </HomeLayout>
  );
}

const ArchiveTableRow = styled.tr`
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
