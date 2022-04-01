import json
from web3 import Web3, HTTPProvider

# UNCOMMENt ONLY ONE COLLECTION OF ENDPOINT AND CONTRACT ADDRESSES

# Truffle development
#   Deployed contract address (see `migrate` command output: `contract address`)
#endpoint_address = 'http://127.0.0.1:8545/'
#entity_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'
#product_contract_address = '0x61f31C64EcDA67357ed8ca64EB80780c2033de5a'
#creator_contract_address = '0x02a5d5C9c22eeDfAbE54c42Cd81F907Ffb27567C'
#activate_contract_address = '0x5464dA569E4E93b0bd2BB7d4D46936B1E17E2642'
#productActivate_contract_address = '0x333b8590Ff428D2bE80C27F8dB4973EDA61c7b75'

# Polygon Mumbai
#   Deployed contract addresses (see `deploy_polygon_mumbai.txt')
#endpoint_address = 'https://matic-mumbai.chainstacklabs.com/'
#entity_contract_address = '0x4e3113E6DD6A7646aa8520905eC30A341D907B1d'
#product_contract_address = '0x21027DD05168A559330649721D3600196aB0aeC2'
#creator_contract_address = '0x5D319aC4488db1eD484be461FdD34F9ebfB6C6E9'
#activate_contract_address = '0xe4984149608663b175667aF4A22bdbEEd17f9a26'
#productActivate_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'

# Polygon Mainnet
#   Deployed contract addresses (see `deploy_polygon_mainnet.txt')
endpoint_address = 'https://polygon-rpc.com/'
entity_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'
product_contract_address = '0x61f31C64EcDA67357ed8ca64EB80780c2033de5a'
creator_contract_address = '0x02a5d5C9c22eeDfAbE54c42Cd81F907Ffb27567C'
activate_contract_address = '0x5464dA569E4E93b0bd2BB7d4D46936B1E17E2642'
productActivate_contract_address = '0x333b8590Ff428D2bE80C27F8dB4973EDA61c7b75'

# Client instance to interact with the blockchain
web3 = Web3(HTTPProvider(endpoint_address))

# Set the default account (so we don't need to set the "from" for every transaction call)
# TODO: enable this for write
#web3.eth.defaultAccount = web3.eth.accounts[0]

# Path to the compiled contract JSON file
entity_contract_path = '../src/contracts/ImmutableEntity.json'
product_contract_path = '../src/contracts/ImmutableProduct.json'
creator_contract_path = '../src/contracts/CreatorToken.json'
productActivate_contract_path = '../src/contracts/ProductActivate.json'
activate_contract_path = '../src/contracts/ActivateToken.json'

with open(entity_contract_path) as file:
    contract_json = json.load(file)  # load contract info as JSON
    contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

# Initialize ImmutableEntity deployed contract interface
entityContract = web3.eth.contract(address=entity_contract_address, abi=contract_abi)

with open(product_contract_path) as file:
    contract_json = json.load(file)  # load contract info as JSON
    contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

# Initialize ImmutableProduct deployed contract interface
productContract = web3.eth.contract(address=product_contract_address, abi=contract_abi)

with open(creator_contract_path) as file:
    contract_json = json.load(file)  # load contract info as JSON
    contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

# Initialize CreatorToken deployed contract interface
creatorContract = web3.eth.contract(address=creator_contract_address, abi=contract_abi)

with open(activate_contract_path) as file:
    contract_json = json.load(file)  # load contract info as JSON
    contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

# Initialize ActivateToken deployed contract interface
activateContract = web3.eth.contract(address=activate_contract_address, abi=contract_abi)

with open(productActivate_contract_path) as file:
    contract_json = json.load(file)  # load contract info as JSON
    contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

# Initialize ProductActivate deployed contract interface
productActivateContract = web3.eth.contract(address=productActivate_contract_address, abi=contract_abi)

# Read entity contract and display first (1) entity information
message = entityContract.functions.entityDetailsByIndex(1).call()
print(message)

# Read product contract and display first (1) entity product (0) information
message = productContract.functions.productDetails(1, 0).call()
print(message)

# Read releases for this product from creator contract
message = creatorContract.functions.creatorAllReleaseDetails(1, 0).call()
print(message)

# Read specific release information from release file hash (reverse lookup)
message = creatorContract.functions.creatorReleaseHashDetails(message[2][0]).call()
print(message)
