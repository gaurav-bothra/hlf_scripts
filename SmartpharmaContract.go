

 package main
 import (	
	 "encoding/json"
	 "bytes"
	 "fmt"
	 "github.com/hyperledger/fabric/core/chaincode/shim"
	 sc "github.com/hyperledger/fabric/protos/peer"
	 "github.com/hyperledger/fabric/core/chaincode/lib/cid"
 )
 var logger = shim.NewLogger("smart")
 type SmartContract struct {
 }
 
 
 type Vendor struct {
	 Name string `json:"name"`
	 Address string `json:"address"`
	 Phn string `json:"phn"`
	 Vtype string `json:"vtype"`
	 Regulator string `json:"regulator"`
	 Txndoneby string	 `json:"txndoneby"`
	 //adding is done through rls private channel
 }

 type RLS_PO struct {
	 Po_no string `json:"po_no"`
	 Material []string `json:"material"`
	 VendorID string `json:"vendorID"`
	 PoDate string `json:"poDate"`
	 ExpectedDate string `json:"expectedDate"`
	//  Totalamt string  `json:"totalamt"`//sum of material 
	 Txndoneby  string `json:"txndoneby"`
 }

type mv_supply_invoice struct {
	Invoice_no string `json:"invoice_no"`
	Po_no string `json:"po_no"`
	Vm_lot_no string `json:"vm_lot_no"`
	Amt string `json:"amt"`
	CoA bool `json:"coa"`
	Status string `json:"status"`
	Dispatchdate string `json:"dispatchdata"`
	Txndoneby  string `json:"txndoneby"`
}

type rls_grn struct {
	Po_no string `json:"po_no"`
	Gr_NO string `json:"gr_no"`
	Receiveddate string `json:"receiveddate"`
	Txndoneby  string `json:"txndoneby"`
}

type Acceptance struct {
	Invoice_no string `json:"invoice_no"`
	Material []string  `json:"material"`// new object checked : true/false
	ChkDate string `json:"chkdate"`
	Txndoneby  string `json:"txndoneby"`
}

type rls_transfer struct {
	Material_code string `json:"material_code"`
	From_location string `json:"from_location"`
	To_location string `json:"to_location"`
	Quantity string `json:"quantity"`
	UnitsOfMeasure string `json:"unitsOfMeasure"`
	StoreLotNo string `json:"storeLotNo"`
	Date string `json:"date"`
	Txndoneby  string `json:"txndoneby"`
}

type rls_consume struct {
	Material_code string `json:"material_code"`
	From_location string `json:"from_location"`
	Production_location string `json:"production_location"`
	Quantity string `json:"quantity"`
	UnitsOfMeasure string `json:"unitsOfMeasure"`
	Store_Lot_NO string `json:"store_Lot_NO"`
	Consuption_LOT_NO string `json:"consuption_LOT_NO"`
	Date string `json:"date"`
	Txndoneby  string `json:"txndoneby"`
}

type Medician struct {
	Name string `json:"name"`
	Desc string `json:"desc"`
	Production_location string `json:"production_location"`
	Batch_no string `json:"batch_no"`
	Material_used [] string  `json:"material_used"`//add consuption property 
	Owner string `json:"owner"`
	DateOfManu string `json:"dateOfManu"`
	DateOfExpiry string `json:"dateOfExpiry"`
	Medinfo []string `json:"medinfo"`
	ProductID string `json:"productID"`
	Ptype string `json:"ptype"`
	Qc bool `json:"qc"`
} 

type unit struct {
	ProductID string `json:"productID"`
	Serial_no string `json:"serial_no"`
	Token string `json:"token"`
}

type box struct {
	BoxId string `json:"boxId"`
	Serial_no []string `json:"serial_no"`
	Production_lot_no string `json:"production_lot_no"`
	Pkg_date string `json:"pkg_date"`
	Batch_no string `json:"batch_no"`
}

type packaging struct {
	PackageID string `json:"packageID"`
	BoxId string `json:"boxId"`
	Pkg_location string `json:"pkg_location"`
	Owner string `json:"owner"`
}

// type unpackage struct {
	
// }

type Distributor_po struct {
	VendorID string `json:"vendorID"`
	Po_no string `json:"po_no"`
	Product [] string `json:"product"`
	PoDate string `json:"poDate"`
	ExpectedDate string `json:"expectedDate"`
	Totalamt string `json:"totalamt"`
}

type rls_supply_invoice struct {
	Invoice_no string `json:"invoice_no"`
	Po_no string `json:"po_no"`
	Production_lot_no string `json:"production_lot_no"`
	Amt string `json:"amt"`
	Status string `json:"status"`
	VendorID string `json:"vendorID"`
	Txndoneby string `json:"txndoneby"`
	Date string `json:"date"`
}

type distributorGRN struct {
	Invoice_no string  `json:"invoice_no"`
	Gr_no string `json:"gr_no"`
	VendorID string `json:"vendorID"`
    Txndoneby string `json:"txndoneby"`
	Date string `json:"date"`
	// status of medician change to distributor name
}


type retailer_po struct {
	VendorID string `json:"vendorID"`
	Po_no string `json:"po_no"`
	Product [] string `json:"product"`
	PoDate string `json:"poDate"`
	ExpectedDate string `json:"expectedDate"`
	Txndoneby string `json:"txndoneby"`
	Totalamt string `json:"totalamt"`
}

type distributor_supply_invoice struct {
	Invoice_no string `json:"invoice_no"`
	VendorID string `json:"vendorID"`
	Po_no string `json:"po_no"`
	Production_lot_no string `json:"production_lot_no"`
	PackageID string `json:"packageID"`
	Amt string `json:"amt"` 
	Status string `json:"status"`
}

type RetailerGRN struct {
	Invoice_no string `json:"invoice_no"`
	VendorID string `json:"vendorID"`
	Gr_no string `json:"gr_no"`
    Txndoneby string `json:"txndoneby"`
	// status of medician change to retailer name
}


type sale_medician struct {
	Name string `json:"name"`
	Product [] string `json:"product"`
	DateOfPurchase string `json:"dateOfPurchase"`
}


 /*
  * The Init method is called when the Smart Contract "fabcar" is instantiated by the blockchain network
  * Best practice is to have any Ledger initialization in separate function -- see initLedger()
  */
 func (s *SmartContract) Init(APIstub shim.ChaincodeStubInterface) sc.Response {
	 return shim.Success(nil)
 }
 
 /*
  * The Invoke method is called as a result of an application request to run the Smart Contract "fabcar"
  * The calling application program has also specified the particular smart contract function to be called with arguments
  */
 func (s *SmartContract) Invoke(APIstub shim.ChaincodeStubInterface) sc.Response {
 
	 // Retrieve the requested Smart Contract function and arguments
	 function, args := APIstub.GetFunctionAndParameters()
	 // Route to the appropriate handler function to interact with the ledger appropriately
	 if function == "createVendor" {
		 return s.createVendor(APIstub, args)
	 } 
 
	 return shim.Error("Invalid Smart Contract function name.")
 }
 
 


 func (s *SmartContract) createVendor(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	fmt.Println(len(args))
	id , err := cid.GetID(APIstub)
	chnid := APIstub.GetChannelID()
	if len(args) != 7 {
		return shim.Error("args error")
	}
	if chnid == "org2only" {
		if err != nil {
			return shim.Error("")
		}
		var vendor = Vendor{Name: args[1], Address: args[2], Phn: args[3], Vtype: args[4], Regulator: args[5], Txndoneby : id}
		vendorAsBytes, _ := json.Marshal(vendor)
		APIstub.PutState(args[0], vendorAsBytes)
		return shim.Success(nil)
	} else {
		return shim.Error("Please add vendor through RLS private Channel")
	}
}

func (s *SmartContract) getAllVendor(APIstub shim.ChaincodeStubInterface, args []string) sc.Response {
	startKey := "VENDOR0"
	endKey := "VENDOR999"

	resultsIterator, err := APIstub.GetStateByRange(startKey, endKey)
	if err != nil {
		return shim.Error(err.Error())
	}
	defer resultsIterator.Close()

	// buffer is a JSON array containing QueryResults
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	fmt.Printf("- queryAllCars:\n%s\n", buffer.String())

return shim.Success(buffer.Bytes())
}
 
 // The main function is only relevant in unit test mode. Only included here for completeness.
 func main() {
 
	 // Create a new Smart Contract
	 err := shim.Start(new(SmartContract))
	 if err != nil {
		 fmt.Printf("Error creating new Smart Contract: %s", err)
	 }
 }
 