// SPDX-License-Identifier: MIT

pragma solidity ^0.8.16;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MegaNFT is ERC721, ERC721Enumerable, Ownable {

    using Strings for uint256;
   
    bool public contractPaused;
    string baseTokenURI;
    uint256 maxSupply;
    uint256 public price;

    event Withdraw(uint256 amount, address addr); 
            
    constructor(
        string memory _name,
        string memory _symbol , address controller_) ERC721(_name, _symbol) {
        maxSupply = 5000;
        price = 0.00005 ether;
        contractPaused = false;
        baseTokenURI = "https://megafans.mypinata.cloud/ipfs/QmVLpWewfDPywWx6Mopb9Y2owVABdCTK7pPHNtHxzpqLPE/";
        transferOwnership(controller_);
    }

    function mint(uint256 num) public payable {
        require(!contractPaused, "Sale Paused!");
        require(totalSupply() + num <= maxSupply, "Max supply reached!");
        require( msg.value >= price * num, "Not enough ETH sent, check price" );

        uint256 supply = totalSupply();
        for(uint256 i = 1; i < num + 1; i++){
            _safeMint( msg.sender, supply + i ); 
        }      
    }    

    function mint(address _to, uint256 num) public payable {
        require(!contractPaused, "Sale Paused!");
        require(totalSupply() + num <= maxSupply, "Max supply reached!");
        require( msg.value >= price * num, "Not enough ETH sent, check price" );

        uint256 supply = totalSupply();
        for(uint256 i = 1; i < num + 1; i++){
             _safeMint(_to, supply + i);
        }      
    }   

    function internalMint(address _to, uint256 num) public  {
        require(!contractPaused, "Sale Paused!");
        require(totalSupply() + num <= maxSupply, "Max supply reached!");
        uint256 supply = totalSupply();
        for(uint256 i = 1; i < num + 1; i++){
             _safeMint(_to, supply + i);
        }
    }   

    function changePrice(uint256 _price)  public onlyOwner {
        price = _price;
    }      

    function listAllNFTAndOwner() public view returns (address[] memory, uint256[] memory) {
        uint256 totalSupply = totalSupply();
        address[] memory addresses = new address[](totalSupply);
        uint256[] memory ids = new uint256[](totalSupply);
        for (uint256 i = 0; i < totalSupply; i++) {
            addresses[i] = ownerOf(i+1);
            ids[i] = tokenByIndex(i);
        }
        return (addresses, ids);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
        _exists(tokenId),
        "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        ".json"
                    )
                )
                : "";
    }    

    function pauseContract() public onlyOwner {
        contractPaused = true;
    }
    function unpauseContract() public onlyOwner {
        contractPaused = false;
    }

    // list own NFT
    function listMyNFTs(address _owner) public view returns(uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        if (tokenCount == 0) {
            return new uint256[](0);
    	}
    	else {
    		uint256[] memory tokensId = new uint256[](tokenCount);
            for(uint256 i = 0; i < tokenCount; i++){
                tokensId[i] = tokenOfOwnerByIndex(_owner, i);
            }
            return tokensId;
    	}        
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function withdraw() public payable onlyOwner {        
        uint256 amount = address(this).balance;
        require(payable(msg.sender).send(amount));        
        emit Withdraw(amount, msg.sender);
    }


    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }


    function supportsInterface (bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721, ERC721Enumerable)
    returns(bool) {
    	return super.supportsInterface(interfaceId);
    }
}
