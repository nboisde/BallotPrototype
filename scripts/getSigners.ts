import {ethers} from "hardhat"

const signers = async () => {
    const [signers] = await ethers.getSigners()
    console.log(signers)
}