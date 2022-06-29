import Image from "next/image";
import styled from "styled-components";
import tw from "twin.macro";
import { UserProfile } from "./Forms/ProfileSettingsForm";

export const UserStatsBar: React.FC<{ profile: UserProfile }> = (props) => {
  const { profilePic, username, city, cosignsReceived, cosignsGiven } = props.profile;

  return (
    <UserStatsBarContainer>
      {profilePic && (
        <div className="w-20 h-20 rounded-full flex justify-center items-center relative">
          <Image
            className={`rounded-full`}
            src={profilePic}
            objectFit={"cover"}
            layout="fill"
            alt="profile picture"
            priority
          />
        </div>
      )}
      <div className="w-4" />
      <p className="text-l italic">{`${username}`}</p>
      <div className="w-4" />
      {city && <p className="text-l italic">City: {`${city}`}</p>}
      <div className="w-4" />
      <div className="flex">
        <div className="relative h-6 w-6">
          <Image src="/blue_diamond.png" alt="Cosigns received" layout="fill" />
        </div>

        <p className="text-l italic">: {`${cosignsReceived}`}</p>
      </div>
      <div className="w-4" />
      <div className="flex">
        <div className="relative h-6 w-6">
          <Image className="rotate-180" src="/blue_diamond.png" alt="Cosigns given" layout="fill" />
        </div>

        <p className="text-l italic">: {`${cosignsGiven}`}</p>
      </div>
    </UserStatsBarContainer>
  );
};

const UserStatsBarContainer = styled.div`
  ${tw`rounded-full text-white rounded-full flex p-4 flex-row items-center justify-center pr-8`}
  background: linear-gradient(
      85.96deg,
      rgba(255, 255, 255, 0) -20.51%,
      rgba(255, 255, 255, 0.05) 26.82%,
      rgba(255, 255, 255, 0) 65.65%
    ),
    rgba(255, 255, 255, 0.05);
  box-shadow: inset 0px -2.50245px 1.25122px rgba(255, 255, 255, 0.1);

  @supports (backdrop-filter: none) {
    backdrop-filter: blur(37.5367px);
  }
`;
