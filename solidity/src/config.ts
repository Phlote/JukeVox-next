import type { HardhatUserConfig } from "hardhat/types"

type HardhatPluginConfig <T> = Partial<T>
  & {
    gasReporter?: {
      currency?: string,
      gasPrice?: number,
      enabled?: boolean,
    }

    contractSizer?: {
      alphaSort?: boolean,
      runOnCompile?: boolean,
      disambiguatePaths?: boolean,
      strict?: boolean,
    }

    etherscan?: {
      apiKey?: string
    }

    typechain?: {
      outDir?: string,
      target?: string,
      alwaysGenerateOverloads?: boolean,
      externalArtifacts?: string[],
    }
  }

export type HardhatPhloteConfig = HardhatPluginConfig<HardhatUserConfig>
