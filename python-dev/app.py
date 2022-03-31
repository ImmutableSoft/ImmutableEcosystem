import json
from web3 import Web3, HTTPProvider

# truffle development blockchain address
blockchain_address = 'https://polygon-rpc.com/'
# Client instance to interact with the blockchain
web3 = Web3(HTTPProvider(blockchain_address))
# Set the default account (so we don't need to set the "from" for every transaction call)
web3.eth.defaultAccount = web3.eth.accounts[0]

# Path to the compiled contract JSON file
compiled_contract_path = '../build/contracts/CreatorToken.json'
# Deployed contract address (see `migrate` command output: `contract address`)
#  deploy_polygon_mainnet.txt
deployed_contract_address = '0x02a5d5C9c22eeDfAbE54c42Cd81F907Ffb27567C'

with open(compiled_contract_path) as file:
    contract_json = json.load(file)  # load contract info as JSON
    contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

# Fetch deployed contract reference
contract = web3.eth.contract(address=deployed_contract_address, abi=contract_abi)

# Call contract function (this is not persisted to the blockchain)
message = contract.functions.creatorAllReleaseDetails(1, 0).call()

print(message)
