echo "1"
export PATH=${PWD}/bin:${PWD}:$PATH
echo "2"
export FABRIC_CFG_PATH=${PWD}/fabric-config
echo "3"
export GOPATH=$HOME/gopath
echo "4"
export GOROOT=$HOME/go
echo "5"
export PATH=$PATH:$GOROOT/bin
echo "6"
go version
echo "7"
docker-compose -f deployment/docker-compose-kafka.yml up -d
echo "8"
docker-compose -f deployment/docker-compose-cli.yml up -d
echo "9"


# echo "--------------------------------------------------------------------"
# configtxgen -profile myNetwork -outputBlock ./network-config/orderer.block
# configtxgen -profile org12 -outputCreateChannelTx ./network-config/org12.tx -channelID org12
# configtxgen -profile org23 -outputCreateChannelTx ./network-config/org23.tx -channelID org23
# configtxgen -profile org34 -outputCreateChannelTx ./network-config/org34.tx -channelID org34
# configtxgen -profile commonchannel -outputCreateChannelTx ./network-config/commonchannel.tx -channelID commonchannel
# configtxgen -profile org1only -outputCreateChannelTx ./network-config/org1only.tx -channelID org1only
# configtxgen -profile org2only -outputCreateChannelTx ./network-config/org2only.tx -channelID org2only
# configtxgen -profile org3only -outputCreateChannelTx ./network-config/org3only.tx -channelID org3only
# configtxgen -profile org4only -outputCreateChannelTx ./network-config/org4only.tx -channelID org4only

# echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
# configtxgen -profile commonchannel -outputAnchorPeersUpdate ./network-config/VendorMSPanchorscommonchannel.tx -channelID commonchannel -asOrg VendorMSP
# configtxgen -profile commonchannel -outputAnchorPeersUpdate ./network-config/RLSMSPanchorscommonchannel.tx -channelID commonchannel -asOrg RLSMSP
# configtxgen -profile commonchannel -outputAnchorPeersUpdate ./network-config/DistributorMSPanchorscommonchannel.tx -channelID commonchannel -asOrg DistributorMSP
# configtxgen -profile commonchannel -outputAnchorPeersUpdate ./network-config/RetailerMSPanchorscommonchannel.tx -channelID commonchannel -asOrg RetailerMSP
# configtxgen -profile commonchannel -outputAnchorPeersUpdate ./network-config/RegulatorMSPanchorscommonchannel.tx -channelID commonchannel -asOrg RegulatorMSP

# configtxgen -profile org12 -outputAnchorPeersUpdate ./network-config/VendorMSPanchorsorg12.tx -channelID org12 -asOrg VendorMSP
# configtxgen -profile org12 -outputAnchorPeersUpdate ./network-config/RLSMSPanchorsorg12.tx -channelID org12 -asOrg RLSMSP
# configtxgen -profile org23 -outputAnchorPeersUpdate ./network-config/RLSMSPanchorsorg23.tx -channelID org23 -asOrg RLSMSP
# configtxgen -profile org23 -outputAnchorPeersUpdate ./network-config/DistributorMSPanchorsorg23.tx -channelID org23 -asOrg DistributorMSP
# configtxgen -profile org34 -outputAnchorPeersUpdate ./network-config/DistributorMSPanchorsorg34.tx -channelID org34 -asOrg DistributorMSP
# configtxgen -profile org34 -outputAnchorPeersUpdate ./network-config/RetailerMSPanchorsorg34.tx -channelID org34 -asOrg RetailerMSP

# echo "only-----------------------------------------------------"
# configtxgen -profile org1only -outputAnchorPeersUpdate ./network-config/VendorMSPanchorsorg1only.tx -channelID org1only -asOrg VendorMSP
# configtxgen -profile org2only -outputAnchorPeersUpdate ./network-config/RLSMSPanchorsorg2only.tx -channelID org2only -asOrg RLSMSP
# configtxgen -profile org3only -outputAnchorPeersUpdate ./network-config/DistributorMSPanchorsorg3only.tx -channelID org3only -asOrg DistributorMSP
# configtxgen -profile org4only -outputAnchorPeersUpdate ./network-config/RetailerMSPanchorsorg4only.tx -channelID org4only -asOrg RetailerMSP
# echo "--------------------------------------------------------------------"

echo "Creating Channel of Vendor peer0"
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer0.vendor.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c commonchannel -f /var/hyperledger/configs/commonchannel.tx
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer0.vendor.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c org12 -f /var/hyperledger/configs/org12.tx
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer0.vendor.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c org1only -f /var/hyperledger/configs/org1only.tx

echo "Joining Channel of Vendor peer0"
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer0.vendor.in.ril.com  peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer0.vendor.in.ril.com  peer channel join -b org12.block
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer0.vendor.in.ril.com  peer channel join -b org1only.block

echo "Copy channel block file of peer0 to local volume"
docker cp peer0.vendor.in.ril.com:/commonchannel.block .
docker cp peer0.vendor.in.ril.com:/org12.block .
docker cp peer0.vendor.in.ril.com:/org1only.block .

echo "------------------------Copy----Peer 1 Vendor---------------------"
docker cp commonchannel.block peer1.vendor.in.ril.com:/commonchannel.block
docker cp org12.block peer1.vendor.in.ril.com:/org12.block
docker cp org1only.block peer1.vendor.in.ril.com:/org1only.block

echo "------------------------joining----Peer 1 Vendor---------------------"
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer1.vendor.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer1.vendor.in.ril.com peer channel join -b org12.block
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer1.vendor.in.ril.com peer channel join -b org1only.block
echo "------------------------Copy----Peer 2 Vendor---------------------"
docker cp commonchannel.block peer2.vendor.in.ril.com:/commonchannel.block
docker cp org12.block peer2.vendor.in.ril.com:/org12.block
docker cp org1only.block peer2.vendor.in.ril.com:/org1only.block

echo "------------------------joining----Peer 2 Vendor---------------------"
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer2.vendor.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer2.vendor.in.ril.com peer channel join -b org12.block
docker exec -e "CORE_PEER_LOCALMSPID=VendorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@vendor.in.ril.com/msp" peer2.vendor.in.ril.com peer channel join -b org1only.block


echo "----------------------------Removing Private Channel Files---------------------"
rm org1only.block

echo "----------------------------------------------org2-----------------------------"

echo "Creating Channel of RLS peer0"
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c org23 -f /var/hyperledger/configs/org23.tx
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c org2only -f /var/hyperledger/configs/org2only.tx

echo "Joining Channel of RLS peer0"
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel join -b org23.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel join -b org2only.block

echo "Copy channel block file of peer0 rls to local volume"
docker cp peer0.rls.in.ril.com:/org23.block .
docker cp peer0.rls.in.ril.com:/org2only.block .


echo "-----------------------Copy-----Peer 0 rls---------------------"
docker cp commonchannel.block peer0.rls.in.ril.com:/commonchannel.block
docker cp org12.block peer0.rls.in.ril.com:/org12.block

echo "Joining Channel of RLS peer0"
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel join -b org12.block

echo "Joining Channel of RLS Anchor Peer"
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel update -o orderer0.in.ril.com:7050 -c commonchannel -f /var/hyperledger/configs/RLSMSPanchorscommonchannel.tx
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer0.rls.in.ril.com peer channel update -o orderer0.in.ril.com:7050 -c org12 -f /var/hyperledger/configs/RLSMSPanchorsorg12.tx

echo "-----------------------Copy-----Peer 1 rls---------------------"
docker cp commonchannel.block peer1.rls.in.ril.com:/commonchannel.block
docker cp org12.block peer1.rls.in.ril.com:/org12.block
docker cp org23.block peer1.rls.in.ril.com:/org23.block
docker cp org2only.block peer1.rls.in.ril.com:/org2only.block


echo "Joining Channel of RLS peer1"
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer1.rls.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer1.rls.in.ril.com peer channel join -b org12.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer1.rls.in.ril.com peer channel join -b org23.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer1.rls.in.ril.com peer channel join -b org2only.block


echo "-----------------------Copy-----Peer 2 rls---------------------"
docker cp commonchannel.block peer2.rls.in.ril.com:/commonchannel.block
docker cp org12.block peer2.rls.in.ril.com:/org12.block
docker cp org23.block peer2.rls.in.ril.com:/org23.block
docker cp org2only.block peer2.rls.in.ril.com:/org2only.block


echo "Joining Channel of RLS peer2"
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer2.rls.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer2.rls.in.ril.com peer channel join -b org12.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer2.rls.in.ril.com peer channel join -b org23.block
docker exec -e "CORE_PEER_LOCALMSPID=RLSMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@rls.in.ril.com/msp" peer2.rls.in.ril.com peer channel join -b org2only.block


echo "----------------------------Removing Private Channel Files---------------------"
rm org2only.block
rm org12.block


echo "----------------------------------------------org3-----------------------------"

echo "Creating Channel of Distributor peer0"
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c org34 -f /var/hyperledger/configs/org34.tx
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c org3only -f /var/hyperledger/configs/org3only.tx

echo "Joining Channel of Distributor peer0"
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel join -b org34.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel join -b org3only.block

echo "Copy channel block file of peer0 rls to local volume"
docker cp peer0.distributor.in.ril.com:/org34.block .
docker cp peer0.distributor.in.ril.com:/org3only.block .


echo "----------------------Copy------Peer 0 distributor---------------------"
docker cp commonchannel.block peer0.distributor.in.ril.com:/commonchannel.block
docker cp org23.block peer0.distributor.in.ril.com:/org23.block

echo "Joining Channel of Distributor peer0"
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel join -b org23.block

echo "Joining Channel of Distributor Anchor Peer"
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel update -o orderer0.in.ril.com:7050 -c commonchannel -f /var/hyperledger/configs/DistributorMSPanchorscommonchannel.tx
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer0.distributor.in.ril.com peer channel update -o orderer0.in.ril.com:7050 -c org23 -f /var/hyperledger/configs/DistributorMSPanchorsorg23.tx


echo "----------------------Copy------Peer 1 distributor---------------------"
docker cp commonchannel.block peer1.distributor.in.ril.com:/commonchannel.block
docker cp org23.block peer1.distributor.in.ril.com:/org23.block
docker cp org34.block peer1.distributor.in.ril.com:/org34.block
docker cp org3only.block peer1.distributor.in.ril.com:/org3only.block

echo "Joining Channel of Distributor peer1"
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer1.distributor.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer1.distributor.in.ril.com peer channel join -b org23.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer1.distributor.in.ril.com peer channel join -b org34.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer1.distributor.in.ril.com peer channel join -b org3only.block


echo "-----------------------Copy----Peer 2 distributor---------------------"
docker cp commonchannel.block peer2.distributor.in.ril.com:/commonchannel.block
docker cp org23.block peer2.distributor.in.ril.com:/org23.block
docker cp org34.block peer2.distributor.in.ril.com:/org34.block
docker cp org3only.block peer2.distributor.in.ril.com:/org3only.block

echo "Joining Channel of Distributor peer2"
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer2.distributor.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer2.distributor.in.ril.com peer channel join -b org23.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer2.distributor.in.ril.com peer channel join -b org34.block
docker exec -e "CORE_PEER_LOCALMSPID=DistributorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@distributor.in.ril.com/msp" peer2.distributor.in.ril.com peer channel join -b org3only.block


echo "----------------------------Removing Private Channel Files---------------------"
rm org3only.block
rm org23.block


echo "----------------------------------------------org4-----------------------------"

echo "Creating Channel of Retailer peer0"
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer0.retailer.in.ril.com peer channel create -o orderer0.in.ril.com:7050 -c org4only -f /var/hyperledger/configs/org4only.tx

echo "Joining Channel of Retailer peer0"
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer0.retailer.in.ril.com peer channel join -b org4only.block

echo "Copy channel block file of peer0 retailer to local volume"
docker cp peer0.retailer.in.ril.com:/org4only.block .
echo "-----------------------Copy----Peer 0 Retailer---------------------"
docker cp commonchannel.block peer0.retailer.in.ril.com:/commonchannel.block
docker cp org34.block peer0.retailer.in.ril.com:/org34.block

echo "Joining Channel of Retailer peer0"
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer0.retailer.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer0.retailer.in.ril.com peer channel join -b org34.block

echo "Joining Channel of Retailer Anchor Peer"
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer0.retailer.in.ril.com peer channel update -o orderer0.in.ril.com:7050 -c commonchannel -f /var/hyperledger/configs/RetailerMSPanchorscommonchannel.tx
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer0.retailer.in.ril.com peer channel update -o orderer0.in.ril.com:7050 -c org34 -f /var/hyperledger/configs/RetailerMSPanchorsorg34.tx


echo "-----------------------Copy----Peer 1 Retailer---------------------"
docker cp commonchannel.block peer1.retailer.in.ril.com:/commonchannel.block
docker cp org34.block peer1.retailer.in.ril.com:/org34.block
docker cp org4only.block peer1.retailer.in.ril.com:/org4only.block

echo "Joining Channel of Retailer peer1"
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer1.retailer.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer1.retailer.in.ril.com peer channel join -b org34.block
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer1.retailer.in.ril.com peer channel join -b org4only.block

echo "-------------------------Copy--Peer 2 retailer---------------------"
docker cp commonchannel.block peer2.retailer.in.ril.com:/commonchannel.block
docker cp org34.block peer2.retailer.in.ril.com:/org34.block
docker cp org4only.block peer2.retailer.in.ril.com:/org4only.block

echo "Joining Channel of Retailer peer2"
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer2.retailer.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer2.retailer.in.ril.com peer channel join -b org34.block
docker exec -e "CORE_PEER_LOCALMSPID=RetailerMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@retailer.in.ril.com/msp" peer2.retailer.in.ril.com peer channel join -b org4only.block

echo "----------------------------Removing Private Channel Files---------------------"
rm org4only.block
rm org34.block


echo "----------------------------------------------org5-----------------------------"


echo "-----------------------Copy Peer 0 Regulator---------------------"
docker cp commonchannel.block peer0.regulator.in.ril.com:/commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RegulatorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@regulator.in.ril.com/msp" peer0.regulator.in.ril.com peer channel join -b commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RegulatorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@regulator.in.ril.com/msp" peer0.regulator.in.ril.com peer channel update -o orderer0.in.ril.com:7050 -c commonchannel -f /var/hyperledger/configs/RegulatorMSPanchorscommonchannel.tx

echo "---------------------------Copy Peer 1 regulator---------------------"

docker cp commonchannel.block peer1.regulator.in.ril.com:/commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RegulatorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@regulator.in.ril.com/msp" peer1.regulator.in.ril.com peer channel join -b commonchannel.block


echo "----------------------------Copy Peer 2 regulator---------------------"
docker cp commonchannel.block peer2.regulator.in.ril.com:/commonchannel.block
docker exec -e "CORE_PEER_LOCALMSPID=RegulatorMSP" -e "CORE_PEER_MSPCONFIGPATH=/var/hyperledger/users/Admin@regulator.in.ril.com/msp" peer2.regulator.in.ril.com peer channel join -b commonchannel.block


echo "----------------------------Removing Private Channel Files---------------------"
rm commonchannel.block

# echo "copying artifacts for client"
# cp -R crypto-config ./client/rls/

# docker exec -it cli.rls.in.ril.com peer chaincode install -n SmartPharmaContract -v 1.0 -l node -p /opt/gopath/src/github.com/chaincode
# docker exec -it cli.rls.in.ril.com peer chaincode instantiate -o orderer0.in.ril.com:7050 -C org12 -n SmartPharmaContract -v 1.0 -c '{"Args":["initLedger"]}'
# docker exec -it cli.rls.in.ril.com peer chaincode invoke -o orderer0.in.ril.com:7050 -n SmartPharmaContract -c '{"Args":["rls_generate_po", "dcs", "s", "sdc","sdc","sdcs","sd","df"]}' -C org12