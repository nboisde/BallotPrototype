import { ethers } from "hardhat";

const signers = async () => {
    return await ethers.getSigners()
}

const createVote = async (VotesAddress: string, name: string, candidates: string[]) => {
    const votersAddr = await signers()
    const voters: string[] = []

    for (let i = 0; i < votersAddr.length; i++) {
        voters.push(votersAddr[i].address)
    }
    const Votes = await ethers.getContractFactory("Votes")
    const contract = Votes.attach(VotesAddress)

    const voteCreation = await contract.createVote(name, candidates, voters)
    console.log("vote created")
}

const simulateVote = async(vote_id: number,VotesAddress: string, name: string, candidates: string[]) => {
    const Votes = await ethers.getContractFactory("Votes")
    const contract = Votes.attach(VotesAddress)

    const vtrs = await signers()

    for (let i = 0; i < vtrs.length - 1; i++) {
        if (i % 2 == 0){
            console.log("voter:", vtrs[i].address)
            console.log("candidate:", candidates[0])
            await contract.connect(vtrs[i]).submitVoteBulletin(vote_id, candidates[0])
        } else {
            console.log("voter:", vtrs[i].address)
            console.log("candidate:", candidates[1])
            await contract.connect(vtrs[i]).submitVoteBulletin(vote_id, candidates[1])
        }
    }
    console.log("Vote simulated.")
}

const getResults = async (vote_id: number) => {
    const Votes = await ethers.getContractFactory("Votes")
    const contract = Votes.attach(VotesAddress)

    await contract.calculateVoteWinner(vote_id)
    const result = await contract.getWinner(vote_id)
    // const res = await contract.getStructResults(vote_id)

    // console.log("winner addr:", result)
    //console.log("Winner is:", result)
    return result;
}

const vote_id: number = 0
const VotesAddress: string = "0x5FbDB2315678afecb367f032d93F642f64180aa3";
const name: string = "Vote 0"
const candidates: string[] = [
    "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266",
    "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"
]

const main = async () => {
    await createVote(VotesAddress, name, candidates)
    // await simulateVote(vote_id, VotesAddress, name, candidates)
    // const res = await getResults(vote_id)
    // console.log("winner:", res)
}

main().then().catch()