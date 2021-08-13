pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale, MintedCrowdsale {

    constructor (
        uint rate,                  // Crowdsale : rate is the conversion between wei and the smallest and indivisible token unit
        address payable wallet,     // Crowdsale : sale beneficiary
        PupperCoin token,           // Crowdsale : The PupperCoin token that PupperCoinSale will work with
        uint cap,                   // CappedCrowdsale : maximum amount of wei accepted in the crowdsale
        uint goal,                  // RefundablePostDeliveryCrowdsale : delivers the tokens once the crowdsale has closed and the goal met
        uint openTime,              // TimedCrowdsale : when the contract is open to fund
        uint closeTime             // TimedCrowdsale : when the contract is closed to new funding
    )
    MintedCrowdsale()
    Crowdsale(rate, wallet, token) 
    CappedCrowdsale(cap) 
    TimedCrowdsale(openTime, closeTime) 
    RefundableCrowdsale(goal)
    public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor (
        string memory name,
        string memory symbol,
        address payable wallet // this address will receive all Ether raised by the sale
    )
    public
    {
        PupperCoin token = new PupperCoin(name, symbol, 0);  // initial supply is zero becuase this token will be Minted
        token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale pupperSale = new PupperCoinSale(1, wallet, token, 300, 100, now, now + 5 minutes);
        token_sale_address = address(pupperSale);
            

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
