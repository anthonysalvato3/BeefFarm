App = {
    web3Provider: null,
    contracts: {},
    emptyAddress: "0x0000000000000000000000000000000000000000",
    cowID: 0,
    metamaskAccountID: "0x0000000000000000000000000000000000000000",
    ownerID: "0x0000000000000000000000000000000000000000",
    originFarmerID: "0x0000000000000000000000000000000000000000",
    originFarmName: null,
    wholesalePrice: 0,
    retailPrice: 0,
    processorID: "0x0000000000000000000000000000000000000000",
    graderID: "0x0000000000000000000000000000000000000000",
    distributorID: "0x0000000000000000000000000000000000000000",
    retailerID: "0x0000000000000000000000000000000000000000",
    consumerID: "0x0000000000000000000000000000000000000000",

    init: async function () {
        App.readForm();
        /// Setup access to blockchain
        return await App.initWeb3();
    },

    readForm: function () {
        App.cowID = $("#cowID").val();
        App.ownerID = $("#ownerID").val();
        App.originFarmerID = $("#originFarmerID").val();
        App.originFarmName = $("#originFarmName").val();
        App.wholesalePrice = $("#wholesalePrice").val();
        App.retailPrice = $("#retailPrice").val();
        App.processorID = $("#processorID").val();
        App.distributorID = $("#distributorID").val();
        App.retailerID = $("#retailerID").val();
        App.consumerID = $("#consumerID").val();

        console.log(
            App.sku,
            App.cowID,
            App.ownerID, 
            App.originFarmerID, 
            App.originFarmName,
            App.wholesalePrice,
            App.retailPrice,
            App.processorID,
            App.distributorID, 
            App.retailerID, 
            App.consumerID
        );
    },

    initWeb3: async function () {
        /// Find or Inject Web3 Provider
        /// Modern dapp browsers...
        if (window.ethereum) {
            App.web3Provider = window.ethereum;
            try {
                // Request account access
                await window.ethereum.enable();
            } catch (error) {
                // User denied account access...
                console.error("User denied account access")
            }
        }
        // Legacy dapp browsers...
        else if (window.web3) {
            App.web3Provider = window.web3.currentProvider;
        }
        // If no injected web3 instance is detected, fall back to Ganache
        else {
            App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        }

        App.getMetaskAccountID();

        return App.initSupplyChain();
    },

    getMetaskAccountID: function () {
        web3 = new Web3(App.web3Provider);

        // Retrieving accounts
        web3.eth.getAccounts(function(err, res) {
            if (err) {
                console.log('Error:',err);
                return;
            }
            console.log('getMetaskID:',res);
            App.metamaskAccountID = res[0];

        })
    },

    initSupplyChain: function () {
        /// Source the truffle compiled smart contracts
        var jsonSupplyChain='../../build/contracts/SupplyChain.json';
        
        /// JSONfy the smart contracts
        $.getJSON(jsonSupplyChain, function(data) {
            console.log('data',data);
            var SupplyChainArtifact = data;
            App.contracts.SupplyChain = TruffleContract(SupplyChainArtifact);
            App.contracts.SupplyChain.setProvider(App.web3Provider);
            
            App.fetchItemBufferOne();
            App.fetchItemBufferTwo();
            App.fetchEvents();

            // Use the code below to test assigned roles
            // App.addRoles();

        });

        return App.bindEvents();
    },

    // addRoles: function() {
    //     App.contracts.SupplyChain.deployed().then(function(instance) {
    //         instance.addFarmer("0x018c2dabef4904ecbd7118350a0c54dbeae3549a");
    //         instance.addProcessor("0xce5144391b4ab80668965f2cc4f2cc102380ef0a");
    //         instance.addDistributor("0x460c31107dd048e34971e57da2f99f659add4f02");
    //         instance.addGrader("0xd37b7b8c62be2fdde8daa9816483aebdbd356088");
    //         instance.addRetailer("0x27f184bdc0e7a931b507ddd689d76dba10514bcb");
    //         instance.addConsumer("0xfe0df793060c49edca5ac9c104dd8e3375349978");
    //     });
    // },

    bindEvents: function() {
        $(document).on('click', App.handleButtonClick);
    },

    handleButtonClick: async function(event) {
        event.preventDefault();

        App.getMetaskAccountID();

        var processId = parseInt($(event.target).data('id'));
        console.log('processId',processId);

        switch(processId) {
            case 1:
                return await App.raiseCow(event);
                break;
            case 2:
                return await App.slaughterCow(event);
                break;
            case 3:
                return await App.splitCow(event);
                break;
            case 4:
                return await App.cleanCow(event);
                break;
            case 5:
                return await App.gradeCow(event);
                break;
            case 6:
                return await App.sellWholesale(event);
                break;
            case 7:
                return await App.buyWholesale(event);
                break;
            case 8:
                return await App.shipBeef(event);
                break;
            case 9:
                return await App.sellRetail(event);
                break;
            case 10:
                return await App.buyRetail(event);
                break;
            case 11:
                return await App.fetchItemBufferOne(event);
                break;
            case 12:
                return await App.fetchItemBufferTwo(event);
                break;
            }
    },

    raiseCow: function(event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.raiseCow(
                App.cowID, 
                App.originFarmName, 
                {from: App.metamaskAccountID}
            );
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('raiseCow',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    slaughterCow: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.slaughterCow(App.cowID, {from: App.metamaskAccountID});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('slaughterCow',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },
    
    splitCow: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.splitCow(App.cowID, {from: App.metamaskAccountID});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('splitCow',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    cleanCow: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.cleanCow(App.cowID, {from: App.metamaskAccountID});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('cleanCow',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    gradeCow: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.gradeCow(App.cowID, {from: App.metamaskAccountID});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('gradeCow',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    sellWholesale: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const wholesalePrice = web3.toWei(App.wholesalePrice, "ether");
            console.log('wholesalePrice', wholesalePrice);
            return instance.sellWholesale(App.cowID, wholesalePrice, {from: App.metamaskAccountID});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('sellWholesale',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    buyWholesale: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const walletValue = web3.toWei(2, "ether");
            return instance.buyWholesale(App.cowID, {from: App.metamaskAccountID, value: walletValue});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('buyWholesale',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    shipBeef: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            return instance.shipBeef(App.cowID, {from: App.metamaskAccountID});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('shipBeef',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    sellRetail: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const retailPrice = web3.toWei(App.retailPrice, "ether");
            console.log('retailPrice', retailPrice);
            return instance.sellRetail(App.cowID, retailPrice, {from: App.metamaskAccountID});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('sellRetail',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    buyRetail: function (event) {
        event.preventDefault();
        var processId = parseInt($(event.target).data('id'));
        App.readForm();

        App.contracts.SupplyChain.deployed().then(function(instance) {
            const walletValue = web3.toWei(3, "ether");
            return instance.buyRetail(App.cowID, {from: App.metamaskAccountID, value: walletValue});
        }).then(function(result) {
            //$("#ftc-item").text(result);
            console.log('buyRetail',result);
        }).catch(function(err) {
            console.log(err.message);
        });
    },

    fetchItemBufferOne: function () {
    ///   event.preventDefault();
    ///    var processId = parseInt($(event.target).data('id'));
        App.readForm();
        App.cowID = $('#cowID').val();
        console.log('cowID',App.cowID);

        App.contracts.SupplyChain.deployed().then(function(instance) {
          return instance.fetchItemBufferOne(App.cowID);
        }).then(function(result) {
          $("#ftc-item").text(result);
          $("#ownerID").val(result[1]);
          $("#originFarmerID").val(result[2]);
          console.log('fetchItemBufferOne', result);
        }).catch(function(err) {
          console.log(err.message);
        });
    },

    fetchItemBufferTwo: function () {
    ///    event.preventDefault();
    ///    var processId = parseInt($(event.target).data('id'));
        App.readForm();
        App.contracts.SupplyChain.deployed().then(function(instance) {
          return instance.fetchItemBufferTwo.call(App.cowID);
        }).then(function(result) {
          $("#ftc-item").text(result);
          $("#processorID").val(result[4]);
          $("#graderID").val(result[5]);
          $("#distributorID").val(result[6]);
          $("#retailerID").val(result[7]);
          $("#consumerID").val(result[8]);
          console.log('fetchItemBufferTwo', result);
        }).catch(function(err) {
          console.log(err.message);
        });
    },

    fetchEvents: function () {
        if (typeof App.contracts.SupplyChain.currentProvider.sendAsync !== "function") {
            App.contracts.SupplyChain.currentProvider.sendAsync = function () {
                return App.contracts.SupplyChain.currentProvider.send.apply(
                App.contracts.SupplyChain.currentProvider,
                    arguments
              );
            };
        }

        App.contracts.SupplyChain.deployed().then(function(instance) {
        var events = instance.allEvents(function(err, log){
          if (!err)
            $("#ftc-events").append('<li>' + log.event + ' - ' + log.transactionHash + '</li>');
        });
        }).catch(function(err) {
          console.log(err.message);
        });
        
    }
};

$(function () {
    $(window).load(function () {
        App.init();
    });
});
