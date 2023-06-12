// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract CappedSet {
    uint256 numElements;

    constructor(uint256 _numElements) {
        numElements = _numElements;
    }

    struct SetElement {
        address adr;
        uint256 value;
    }

    SetElement[] public Set;

    event insertElement(address newLowestAddress, uint256 newLowestValue);

    function insert(address _adr, uint256 _value) public returns (address newLowestAddress, uint256 newLowestValue)
    {
        require(_adr != address(0), "address can't be zero");

        SetElement memory objSet;
        objSet.adr = _adr;
        objSet.value = _value;

        if (Set.length < numElements) 
        {
            uint256 lowestValueIndex = getLowestValue();
            Set.push(objSet);

            if (objSet.value < Set[lowestValueIndex].value) 
            {
                return (objSet.adr, objSet.value);
            }

            emit insertElement(Set[lowestValueIndex].adr, Set[lowestValueIndex].value);
            return (Set[lowestValueIndex].adr, Set[lowestValueIndex].value);
        }
        else
        {
            uint256 highestValueIndex = getHighestValue();
            if (objSet.value < Set[highestValueIndex].value) 
            {
                Set[highestValueIndex] = objSet;
                emit insertElement(objSet.adr, objSet.value);
            }
            return (Set[highestValueIndex].adr, Set[highestValueIndex].value);
        }
    }

    function getLowestValue() public view returns (uint256) 
    {
        uint256 lowestIndex = 0;

        for (uint256 i = 1; i < Set.length; i++)
        {
            if (Set[i].value < Set[lowestIndex].value) 
            {
                lowestIndex = i;
            }
        }
        return lowestIndex;
    }

    function getHighestValue() public view returns (uint256) 
    {
        uint256 highestIndex = 0;

        for (uint256 i = 1; i < Set.length; i++)
        {
            if (Set[i].value > Set[highestIndex].value) 
            {
                highestIndex = i;
            }
        }
        return highestIndex;
    }

    function update(address _adr, uint256 _newValue) public returns (address newLowestAddress, uint256 newLowestValue)
    {
        require(Set.length > 0, "Set is empty");

        for (uint256 i = 0; i < Set.length; i++) 
        {
            if (Set[i].adr == _adr) 
            {
                uint256 lowestValueIndex = getLowestValue();
                Set[i].value = _newValue;

                if (_newValue < Set[lowestValueIndex].value) 
                {
                    return (_adr, _newValue);
                }

                return (Set[lowestValueIndex].adr, Set[lowestValueIndex].value);
            }
        }
        revert("Set not found");
    }

    function remove(address _adr) public returns (address newLowestAddress, uint256 newLowestValue)
    {
        require(Set.length > 0, "Set is empty");

        uint256 lowestValueIndex = getLowestValue();
        uint256 removedIndex;

        for (uint256 i = 0; i < Set.length; i++) 
        {
            if (Set[i].adr == _adr) 
            {
                removedIndex = i;
                break;
            }
        }

        require(removedIndex < Set.length, "Set element not found");

        if (removedIndex == lowestValueIndex) 
        {
            Set[removedIndex] = Set[Set.length - 1];
            Set.pop();
            lowestValueIndex = getLowestValue();
        }
        else
        {
            Set[removedIndex] = Set[Set.length - 1];
            Set.pop();
        }

        if (Set.length == 0)
        {
            return (address(0), 0);
        }

        return (Set[lowestValueIndex].adr, Set[lowestValueIndex].value);
    }

    function getValue(address _adr) public view returns (uint256) 
    {
        for (uint256 i = 0; i < Set.length; i++) 
        {
            if (Set[i].adr == _adr) 
            {
                return Set[i].value;
            }
        }
        revert("Not found");
    }
}