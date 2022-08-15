import { ethers } from "hardhat";

const main = async () => {
    const hre = await ethers.getContractFactory("Votes")
    const deploy = await hre.deploy()
    console.log(deploy)
}

main().then(()=>{
    process.exit(0)
}).catch(e => {
    console.log(e)
    process.exit(1)
})
