import { HardhatUserConfig } from "hardhat/types"

type HardhatPluginConfig <T> = Partial<T>
  & {
    gasReporter?: {
      currency?: string,
      gasPrice?: number,
      enabled?: boolean,
    }
  }

export type HardhatPhloteConfig = HardhatPluginConfig<HardhatUserConfig>
