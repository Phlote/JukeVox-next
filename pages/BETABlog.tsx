import React from "react";
import { Footer } from "../components/Footer";
import Layout from "../components/Layouts";

let TempAboutUs = ()=>
  <section className="mt-14 sm:py-20 sm:mt-20 lg:mt-38">
    <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
      <h1 className="text-2xl sm:text-7xl font-extrabold">What is currently happening to Phlote?</h1>
      <br/>
      <p className="text-2xl font-extrabold">Phlote is currently undergoing a major update and revamp on its back-end as we move towards the official BETA phase. We have finally switched to a completely on-chain system, as planned in our internal roadmap. We are using this BETA phase to identify bugs and improvements to our platform, so please bear with us as we complete this final stage before going live on mainnet! </p>
      <br/>
      <p className="text-2xl font-extrabold">We have migrated our submission and co-signing process to be on-chain, with the automated sale of our top 5 co-signed songs coming soon. However, you may be experiencing some issues with our platform and this article will address these issues and explain why they are occurring.</p>
      <br/>
      <p className="text-2xl font-extrabold">The issues you are experiencing are a result of us being in BETA and being exclusively on the Polygon Testnet (Mumbai Network). This leads to three key issues that we will cover:</p>
      <br/>
      <ol className="text-2xl font-extrabold">
        <li>1. Wallet connection issues</li>
        <li>2. The need for &quot;fake&quot; Matic to run transactions on the testnet</li>
        <li>3. The requirement for Phlote tokens to participate on the platform (e.g. co-signing)</li>
      </ol>
      <br/>
      <p className="text-md font-extrabold"><i><u>We apologize for any inconvenience these issues may cause and appreciate your understanding as we work to improve our platform.</u></i></p>
      <br/>
    </div>
    <hr/>

    <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col pt-10 gap-4">
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
        <h2 className="text-2xl sm:text-4xl font-extrabold">1. Wallet Connection Issues:</h2>
        </div>
        <br/>
        <p className="text-2xl font-extrabold">The first issue we would like to discuss is the fact that we are currently live on &quot;Mumbai Polygon&quot; chain. Which is essentially the &quot;testing grounds&quot; for the Polygon mainnet. <u>One of the problems this presents is that certain wallets, such as Rainbow wallet and Trust wallet, do not support custom chains.</u> This means that these wallets do not allow you to connect to chains that they do not support, such as the Mumbai Polygon. Therefore, some of our users may be unable to connect their wallets to our site.</p>
        <br/>

        <h4 className="text-2xl sm:text-3xl "><u>So what is the solution to this?</u></h4>
        <br/>
        <p className="text-2xl font-extrabold ">Metamask. Metamask is a decentralized wallet which allows you to add custom chains, therefore it is able to connect to Polygon Mumbai chain without issues. If you’d like to use our platform in this BETA phase, you will need to connect using MetaMask. You can use MetaMask as a web extension on your computer or the mobile app on your mobile device.</p>
        <br/>

        <h4 className="text-2xl sm:text-3xl "><u>How do I use MetaMask?</u></h4>
        <br/>
        <ol className="text-2xl font-extrabold pl-22 pr-22">
            <li>1. Install the Metamask extension on your web browser. You can find it on the Chrome web store or the Firefox add-on store.</li>
            <br/>
            <li>2. After installing the extension, click on the Metamask icon in your browser&apos;s toolbar to open the wallet.</li>
            <br/>
            <li>3. Click on the &quot;Create Wallet&quot; button to create a new wallet. You&apos;ll be prompted to create a password for your wallet. Make sure to choose a strong password and remember it, as you&apos;ll need it to access your wallet in the future.</li>
            <br/>
            <li>4. After creating your wallet, you&apos;ll be given a 12-word recovery phrase. This is a critical piece of information that you&apos;ll need to keep safe in case you ever need to recover your wallet. Write down the recovery phrase and store it in a safe place.</li>
            <br/>
            <li>5. Once your wallet is created, you&apos;ll be taken to the main wallet interface. Here, you can see your wallet address, which is a long string of letters and numbers that represents your wallet on the network. You can use this address to receive coins/tokens.</li>
            <br/>
            <li>6. To send coins/tokens from your wallet, click on the &quot;Send&quot; button. You&apos;ll be prompted to enter the recipient&apos;s wallet address, the number of tokens you want to send, and any additional data that may be required (such as the contract address for a specific token). Once you&apos;ve entered this information, click on the &quot;Send&quot; button to initiate the transaction.</li>
            <br/>
            <li>7. To view your transaction history or check your balance, click on the &quot;Transactions&quot; or &quot;Assets&quot; tabs in the wallet interface.</li>
        </ol>
        <br/>
        <p className="text-2xl font-extrabold ">
        And that&apos;s it! With Metamask, you can easily manage your tokens, and securely store them in your web browser. Just make sure to keep your password and recovery phrase safe, as they are the only way to access your wallet if you forget your password.
        <br/>
        </p>
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
            <p className=" text-2xl font-extrabold"><i>You may also refer to this article on how to use MetaMask:  <a className="text-blue-600" href="https://decrypt.co/resources/metamask"><u>https://decrypt.co/resources/metamask</u></a></i></p>
        </div>
        <br/>
    </div>
    <hr/>

    <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col pt-10 gap-4">
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
            <h2 className="text-2xl sm:text-4xl font-extrabold">2. Requiring “fake” Matic to be able to run transactions on testnet:</h2>
        </div>
        <br/>
        <p className="text-2xl font-extrabold">First of all, what do we mean by fake matic? Well, as we mentioned earlier, Polygon Mumbai is the chain we’re currently live on. This is a testnet chain where transactions aren’t real. They don’t cost real money. But just like any of the other chains you’ve used, like Ethereum or Polygon, you need to pay for the transaction fees. <u>In order to run a transaction on Polygon Mumbai, we have to get Matic that can be used on Polygon Mumbai (Do not try to send yourself real Matic, as that won&apos;t work).</u></p>
        <br/>
        <h4 className="text-2xl sm:text-3xl "><u>So…How do I get fake Matic ?</u></h4>
        <br/>
        <p className="text-2xl font-extrabold ">It’s actually very simple. Once you have your MetaMask set up, you can use these 2 websites to get yourself free Mumbai testnet Matic by simply copy-pasting your wallet address and hitting “submit”!</p>
        
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
            <ul className="text-2xl font-extrabold justify-center items-center text-blue-600">
                <li>a. <a href="https://faucet.polygon.technology/">https://faucet.polygon.technology/</a></li>
                <br/>
                <li>b. <a href="https://mumbaifaucet.com/">https://mumbaifaucet.com/</a></li>
            </ul>
        </div>
    </div>
    <br/>
    <hr/>

    <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col pt-10 gap-4">
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
            <h2 className="text-2xl sm:text-4xl font-extrabold">3. Requiring Phlote tokens to be able to participate on the platform (ex. co-signing):</h2>
        </div>
        <br/>
        
        <p className="text-2xl font-extrabold">This brings us to the last point in this upgrade, which is needing Phlote tokens in order to jump-start the Phlote Dao ecosystem. </p>

        <p className="text-2xl font-extrabold">During our current BETA phase, we will be airdropping certain addresses with some testnet Phlote tokens which they can utilize on our platform to co-sign records. With MetaMask, if you’re using a custom token (Phlote token is a custom token), you will have to manually add it to your wallet. It wont show your Phlote token balance, even if you have tokens, unless you’ve added the token to your wallet.</p>
        <br/>
        <h4 className="text-2xl sm:text-3xl "><u>So how do I add tokens (Phlote Token) to my metamask?</u></h4>
        
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
            <ol className="text-2xl font-extrabold justify-center items-center">
            <li>1. Open the Metamask extension in your web browser.</li>
            <br/>
            <li>2. Click on the &quot;Add Token&quot; button, which is located in the Asset section of the wallet.</li>
            <br/>
            <li>3. In the &quot;Add Token&quot; dialog box, enter the contract address, and the rest should auto-populate. The Phlote Token testnet contract address is:
                <ul>
                    <br/>
                    <li className="indent-20">a. <i>0xc973F97a608b4E282EB97C7E86901ab5EBf3A014</i></li>
                </ul>
            </li>
            <br/>
            <li>4. Once everything has populated, click on the &quot;Next&quot; button to add the token to your Metamask wallet.</li>
            <br/>
            <li>5. The token should now appear in your Asset section, and you can use it just like any other token in your wallet.</li>
            </ol>

            <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
                <p className=" text-2xl font-extrabold"><i>You may also refer to this article on how to add tokens to MetaMask:  <a className="text-blue-600" href="https://support.ledger.com/hc/en-us/articles/6375103346077-Add-custom-tokens-to-MetaMask?docs=true"><u>Add Custom Token To MetaMask Guide</u></a></i></p>
            </div>
        </div>
        <br/>
        <hr/>
        <div className="w-9/12 sm:w-10/12 2xl:w-full flex flex-col justify-center items-center pt-10 gap-4">
            <p className="text-2xl font-extrabold"><i><u>We apologize for any inconvenience these issues may cause and appreciate your understanding as we work to improve our platform.</u></i></p>
        </div>
    </div>
  </section>

function BETABlog() { // LANDING PAGE
  return (
    <div className="font-roboto">
      {/*<AboutUsContent />*/}
      <TempAboutUs/>
    </div>
  );
}

BETABlog.getLayout = function getLayout(page) {
  return (
    <Layout>
      <div className="container flex justify-center mx-auto items-center">
        {page}
      </div>
    </Layout>
  );
};

export default BETABlog;
