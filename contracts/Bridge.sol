// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract SepoliaBridge {
    address public owner;
    bool public paused;
    bool private locked;

    // Separate Events for ETH and ERC-20
    event ERC20Deposited(address indexed user, address indexed token, uint256 amount);
    event ETHDeposited(address indexed user, uint256 amount);
    event ERC20Withdrawn(address indexed recipient, address indexed token, uint256 amount);
    event ETHWithdrawn(address indexed recipient, uint256 amount);
    event ERC20Released(address indexed recipient, address indexed token, uint256 amount);
    event ETHReleased(address indexed recipient, uint256 amount);
    event Paused();
    event Unpaused();

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    modifier nonReentrant() {
        require(!locked, "Reentrant call");
        locked = true;
        _;
        locked = false;
    }

    constructor(address _owner) {
        owner = _owner;
        paused = false;
    }

    // Admin functions
    function pause() external onlyOwner {
        paused = true;
        emit Paused();
    }

    function unpause() external onlyOwner {
        paused = false;
        emit Unpaused();
    }

    // Deposit functions
    function depositERC20(address token, uint256 amount) external whenNotPaused nonReentrant {
        require(amount > 0, "Deposit amount must be greater than zero");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        emit ERC20Deposited(msg.sender, token, amount);
    }

    function depositETH() external payable whenNotPaused nonReentrant {
        require(msg.value > 0, "Deposit amount must be greater than zero");
        emit ETHDeposited(msg.sender, msg.value);
    }

    // Withdraw functions
    function withdrawERC20(address token, address _to, uint256 _amount) external onlyOwner whenNotPaused nonReentrant {
        require(IERC20(token).balanceOf(address(this)) >= _amount, "Insufficient token balance");
        IERC20(token).transfer(_to, _amount);
        emit ERC20Withdrawn(_to, token, _amount);
    }

    function withdrawETH(address payable _to, uint256 _amount) external onlyOwner whenNotPaused nonReentrant {
        require(address(this).balance >= _amount, "Insufficient ETH balance");
        _to.transfer(_amount);
        emit ETHWithdrawn(_to, _amount);
    }

    // Release functions (assumed for claim logic)
    function releaseERC20(address token, address _to, uint256 _amount) external onlyOwner whenNotPaused nonReentrant {
        require(IERC20(token).balanceOf(address(this)) >= _amount, "Insufficient token balance");
        IERC20(token).transfer(_to, _amount);
        emit ERC20Released(_to, token, _amount);
    }

    function releaseETH(address payable _to, uint256 _amount) external onlyOwner whenNotPaused nonReentrant {
        require(address(this).balance >= _amount, "Insufficient ETH balance");
        _to.transfer(_amount);
        emit ETHReleased(_to, _amount);
    }

    // Fallback for direct ETH sends
    receive() external payable {
        emit ETHDeposited(msg.sender, msg.value);
    }
}
