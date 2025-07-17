// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.30;

/**
 * @title Gath3rGroup
 * @dev Contract for handle individual group-level logic.
 */
contract Gath3rGroup {
    // Metadata for group members.
    struct Member {
        // (+) = owed, (-) = owes.
        int256 balance;
        bool exists;
    }

    // Metadata for group expenses.
    struct Expense {
        uint256 amount;
        string description;
        address payer;
        uint256 timestamp;
        address[] debtors;
        uint256[] amounts;
    }

    address public admin;
    string public groupName;
    mapping(address => Member) public members;
    Expense[] public expenses;

    event MemberAdded(address member);
    event ExpenseAdded(
        address indexed payer,
        uint256 amount,
        string description
    );
    event PaymentSettled(
        address indexed from,
        address indexed to,
        uint256 amount
    );

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not an admin");
        _;
    }

    modifier onlyMember() {
        require(members[msg.sender].exists, "Not a group member");
        _;
    }

    constructor(address creator, string memory _groupName) {
        admin = creator;
        groupName = _groupName;
        members[creator] = Member(0, true);
    }

    /**
     * @dev addMember(address) function.
     * Use case: Add members into a group.
     */
    function addMember(address _member) external onlyAdmin {
        require(members[_member].exists, "Already a group member");
        members[_member] = Member(0, true);
        emit MemberAdded(_member);
    }

    /**
     * @dev addExpense(uint256, string, address[], uint256[]) function.
     * Use case: Add expenses into a group for gather the payment.
     */
    function addExpense(
        uint256 _amount,
        string memory _description,
        address[] memory _debtors,
        uint256[] memory _amounts
    ) external onlyMember {
        require(
            _debtors.length == _amounts.length,
            "Length mismatch: debtors != amounts"
        );

        members[msg.sender].balance += int256(_amount);

        for (uint256 i = 0; i < _debtors.length; i++) {
            require(members[_debtors[i]].exists, "Debtor not a group member");
            members[_debtors[i]].balance -= int256(_amounts[i]);
        }

        expenses.push(
            Expense({
                amount: _amount,
                description: _description,
                payer: msg.sender,
                timestamp: block.timestamp,
                debtors: _debtors,
                amounts: _amounts
            })
        );

        emit ExpenseAdded(msg.sender, _amount, _description);
    }

    /**
     * @dev getAllExpenses() function.
     * Use case: Get all expenses within a group.
     */
    function getAllExpenses() external view returns (Expense[] memory) {
        return expenses;
    }

    /**
     * @dev settle(address) function.
     * Use case: Send some funds to another group member
     * to settle part or all of a debt.
     */
    function settle(address _to) external payable onlyMember {
        require(members[_to].exists, "Recipient not a group member");
        require(msg.value > 0, "No value sent");

        members[msg.sender].balance += int256(msg.value);
        members[_to].balance -= int256(msg.value);

        emit PaymentSettled(msg.sender, _to, msg.value);
    }

    /**
     * @dev depositToYield() function.
     * Use case: Add some funds to a pool to earn yield before settlement.
     * Useful when a group member wants to pay their debt partially.
     *
     * Integrated with Aave protocol.
     */
    function depositToYield() external onlyMember {}

    /**
     * @dev claimYield() function.
     * Use case: Claim earned yield after settlement.
     */
    function claimYield() external onlyMember {}

    /**
     * @dev autoSettle() function.
     * Use case: Auto settle payment when some thresholds are met.
     */
    function autoSettle() external onlyMember {}
}
