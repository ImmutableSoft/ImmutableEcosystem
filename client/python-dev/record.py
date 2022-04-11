import json
from web3 import Web3, HTTPProvider

#####################################################################
# CONFIGURATION
#####################################################################
# UNCOMMENt ONLY ONE COLLECTION OF ENDPOINT AND CONTRACT ADDRESSES

#####################################################################
# Truffle development (Account 0 of ganache-cli --deterministic)
#####################################################################
#private_key  =  '0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d'
#from_address  =  '0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1'
#endpoint_address = 'http://127.0.0.1:8545/'

# Deployed contract addresses (see `migrate` command output: `contract address`)
#entity_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'
#product_contract_address = '0x61f31C64EcDA67357ed8ca64EB80780c2033de5a'
#creator_contract_address = '0x02a5d5C9c22eeDfAbE54c42Cd81F907Ffb27567C'
#activate_contract_address = '0x5464dA569E4E93b0bd2BB7d4D46936B1E17E2642'
#productActivate_contract_address = '0x333b8590Ff428D2bE80C27F8dB4973EDA61c7b75'

#####################################################################
# Polygon Mumbai
#####################################################################
#   Deployed contract addresses (see `deploy_polygon_mumbai.txt')
private_key  =  '0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d'
from_address  =  '0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1'
endpoint_address = 'https://matic-mumbai.chainstacklabs.com/'
chain_id = 80001
entity_contract_address = '0x4e3113E6DD6A7646aa8520905eC30A341D907B1d'
product_contract_address = '0x21027DD05168A559330649721D3600196aB0aeC2'
creator_contract_address = '0x5D319aC4488db1eD484be461FdD34F9ebfB6C6E9'
activate_contract_address = '0xe4984149608663b175667aF4A22bdbEEd17f9a26'
productActivate_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'

#####################################################################
# Polygon Mainnet
#   Deployed contract addresses (see `deploy_polygon_mainnet.txt')
#####################################################################
#private_key  =  '0x4f3edf983ac636a65a842ce7c78d9aa706d3b113bce9c46f30d7d21715b23b1d'
#from_address  =  '0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1'
#endpoint_address = 'https://polygon-rpc.com/'
#chain_id = 137
#entity_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'
#product_contract_address = '0x61f31C64EcDA67357ed8ca64EB80780c2033de5a'
#creator_contract_address = '0x02a5d5C9c22eeDfAbE54c42Cd81F907Ffb27567C'
#activate_contract_address = '0x5464dA569E4E93b0bd2BB7d4D46936B1E17E2642'
#productActivate_contract_address = '0x333b8590Ff428D2bE80C27F8dB4973EDA61c7b75'

#####################################################################
#  File release parameters (replace below with Python command args?)
#####################################################################
fileProductId = 0x0
fileSha256 = 0x0ABA0D8FB16D662BB67A75EAEA2DFDE44525CC28EA46A243EB63C44D902BA1D3 #ImmutableSoft
fileUri = 'https://licenseware.io/audit_reports/clientA/Report_01.pdf'
fileVersion = 0x0001000200030004 # 1.2.3.4

#####################################################################
# SETUP WEB3 ENDPOINT AND CONTRACTS
#####################################################################

# Client instance to interact with the blockchain
web3 = Web3(HTTPProvider(endpoint_address))

# Path to the compiled contract JSON file
creator_contract_path = '../src/contracts/CreatorToken.json'

with open(creator_contract_path) as file:
    contract_json = json.load(file)  # load contract info as JSON
    contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

# Initialize CreatorToken deployed contract interface
creatorContract = web3.eth.contract(address=creator_contract_address, abi=contract_abi)

#####################################################################
# ENCODE CONTRACT TRANSACTION, SIGN AND SUBMIT TO ENDPOINT
#####################################################################

# Build new release transaction for this product from creator contract
newRelease = creatorContract.functions.creatorReleases([fileProductId], [fileVersion], [fileSha256], [fileUri], [0]).buildTransaction({
    'chainId': chain_id,
    'gas': 200000,
#    'maxFeePerGas': web3.toWei('100', 'gwei'),
#    'maxPriorityFeePerGas': web3.toWei('50', 'gwei'),
    'nonce': web3.eth.getTransactionCount(from_address),
    'from': from_address,
})

signed_txn = web3.eth.account.sign_transaction(newRelease, private_key)

#web3.eth.send_raw_transaction(signed_txn.rawTransaction)

print(signed_txn.rawTransaction)
