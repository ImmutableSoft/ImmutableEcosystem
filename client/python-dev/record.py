import json
from web3 import Web3, HTTPProvider
from web3.gas_strategies.time_based import medium_gas_price_strategy

#####################################################################
# WALLET CONFIGURATION (global)
#  Change below to load from a keystore or env variable
#  Ganache testing only. (Account 0 of ganache-cli --deterministic)
#  This address MUST first be regsitered with Immutable Ecosystem
#####################################################################
private_key  =  '0x6cbed15c793ce57650b9877cf6fa156fbef513c4e6134f022a85b1ffdd59b2a1'
from_address  =  '0xFFcf8FDEE72ac11b5c542428B35EEF5769C409f0'

#####################################################################
# BLOCKCHAIN CONFIGURATION (global)
#####################################################################
# UNCOMMENt ONLY ONE COLLECTION OF ENDPOINT AND CONTRACT ADDRESSES

#####################################################################
# Truffle development
#####################################################################
endpoint_address = 'http://127.0.0.1:8545/'
chain_id = 1337
# Deployed contract addresses (see `migrate` command output: `contract address`)
entity_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'
product_contract_address = '0x61f31C64EcDA67357ed8ca64EB80780c2033de5a'
creator_contract_address = '0xA57B8a5584442B467b4689F1144D269d096A3daF'
activate_contract_address = '0x5464dA569E4E93b0bd2BB7d4D46936B1E17E2642'
productActivate_contract_address = '0x333b8590Ff428D2bE80C27F8dB4973EDA61c7b75'

#####################################################################
# Polygon Mumbai
#####################################################################
#   Deployed contract addresses (see `deploy_polygon_mumbai.txt')
#endpoint_address = 'https://matic-mumbai.chainstacklabs.com/'
#chain_id = 80001
#entity_contract_address = '0x4e3113E6DD6A7646aa8520905eC30A341D907B1d'
#product_contract_address = '0x21027DD05168A559330649721D3600196aB0aeC2'
#creator_contract_address = '0x5D319aC4488db1eD484be461FdD34F9ebfB6C6E9'
#activate_contract_address = '0xe4984149608663b175667aF4A22bdbEEd17f9a26'
#productActivate_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'

#####################################################################
# Polygon Mainnet
#   Deployed contract addresses (see `deploy_polygon_mainnet.txt')
#####################################################################
#endpoint_address = 'https://polygon-rpc.com/'
#chain_id = 137
#entity_contract_address = '0xdd88f7448305079728c32ecaAFCA6a87166d52B6'
#product_contract_address = '0x61f31C64EcDA67357ed8ca64EB80780c2033de5a'
#creator_contract_address = '0x02a5d5C9c22eeDfAbE54c42Cd81F907Ffb27567C'
#activate_contract_address = '0x5464dA569E4E93b0bd2BB7d4D46936B1E17E2642'
#productActivate_contract_address = '0x333b8590Ff428D2bE80C27F8dB4973EDA61c7b75'

#####################################################################
#  RecordProductReleases: parameters must be arrays of equal length
#    index   - the product index (as defined in Immutable Ecosystem)
#    sha     - the file PoE: the unique one-way SHA256 checksum
#    uri     - the file URI: public or private URI
#    version - the file version (0x0001000200030004 = v1.2.3.4)
#    root    - the Ricardian root of file, or zero
#####################################################################
def RecordProductReleases(index, sha, uri, version, root):

  # Client instance to interact with the blockchain
  web3 = Web3(HTTPProvider(endpoint_address))

  #####################################################################
  # SETUP WEB3 ENDPOINT AND CONTRACTS
  #####################################################################

  # Path to the compiled contract JSON file
  creator_contract_path = '../src/contracts/CreatorToken.json'

  with open(creator_contract_path) as file:
      contract_json = json.load(file)  # load contract info as JSON
      contract_abi = contract_json['abi']  # fetch contract's abi - necessary to call its functions

  # Initialize CreatorToken deployed contract interface
  creatorContract = web3.eth.contract(address=creator_contract_address, abi=contract_abi)

  # Initialize the gas price strategy
  web3.eth.setGasPriceStrategy(medium_gas_price_strategy)

  #####################################################################
  # ENCODE CONTRACT TRANSACTION, SIGN AND SUBMIT TO ENDPOINT
  #####################################################################

  # Build new release transaction for this product from creator contract
  newRelease = creatorContract.functions.creatorReleases(index, version, sha, uri, root).buildTransaction({
      'chainId': chain_id,
      'nonce': web3.eth.getTransactionCount(from_address),
      'from': from_address,
  })

  # Sign the transaction with private key configured above
  signed_txn = web3.eth.account.sign_transaction(newRelease, private_key)
  print(signed_txn.rawTransaction)

  # Send the transaction and wait for receipt of it being mined
  #   Note: This can take awhile, and may fail due to low gas on
  #         Mainnet (Polygon/Ethereum).
  tx_hash = web3.eth.sendRawTransaction(signed_txn.rawTransaction)
  receipt = web3.eth.waitForTransactionReceipt(tx_hash)
  return receipt

#####################################################################
# Record a single file PoE for product 0 to the IE smart contracts
#####################################################################
#  RecordProductReleases(index, sha, uri, version, root)
tx = RecordProductReleases([0], [0x0ABA0D8FB16D662BB67A75EAEA2DFDE44525CC28EA46A243EB63C44D902BA1D3],
                           ['https://licenseware.io/audit_reports/clientA/Report_02.pdf'],
                           [0x0001000200030004], [0])
# Check if successful
#   See output on https://web3py.readthedocs.io/en/stable/examples.html#looking-up-transactions
if tx["status"] == 1:
  print("success")
else:
  print("failed")

print(dict(tx)) # record this receipt in web2?

# From receipt hash, look up the full transaction data (ie. Etherscan)
#web3 = Web3(HTTPProvider(endpoint_address))
#print(web3.eth.get_transaction(tx["transactionHash"]))
