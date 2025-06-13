// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract MyContacts {

    enum Relation {None, Friend, Family, Colleague}

    struct Contact {
        string name;
        address wallet;
        Relation relation;
        uint256 counterUpdates;
    }

    mapping (address => Contact[]) private _ListContacts;

    // Modifiers    
    modifier onlyValidIndex(address _user, uint256 _index) {
        require(
            _index < _ListContacts[_user].length, 
            "invalid index. out of range" 
        );
        _;
    }

    // Events
    event AddContact(
        address indexed user, 
        string name,
        address wallet, 
        Relation relation,
        uint256 index
    );

    event UpdateContact(
        address indexed user,
        string oldName, 
        string newName,
        Relation newRelation,
        uint256 index
    );

    event DeletedContact(
        address indexed user, 
        uint256 index
    );

     
    // @notice New contact for (msg.sender).
    // @param _name
    // @param _wallet
    // @param _relation
    // @return index position where contact was add in the array _ListContacts
    function createContact(
        string memory _name, 
        address _wallet, 
        Relation _relation
    )
        external 
        returns (uint256 index)
    {
        // Create contact in mem
        Contact memory newContact = Contact({
            name: _name,
            wallet: _wallet,
            relation: _relation,
            counterUpdates: 0
        });
        _ListContacts[msg.sender].push(newContact);

        index = _ListContacts[msg.sender].length - 1;

        emit AddContact(
            msg.sender,
            _name,
            _wallet, 
            _relation, 
            index
        );
    }

    // @notice Udpate contact name
    // @param _index
    // @param _newDescription
    function updateName(
        uint256 _index, 
        string memory _newDescription
    )
        external 
        // use modifier to verify _index
        onlyValidIndex(msg.sender, _index) 
    {
        // save old value
        string memory oldValue = _ListContacts[msg.sender][_index].name;
        // update value
        _ListContacts[msg.sender][_index].name = _newDescription;
        // increment counter updates
        _ListContacts[msg.sender][_index].counterUpdates++;
        // emit event
        emit UpdateContact(
            msg.sender, 
            oldValue, 
            _ListContacts[msg.sender][_index].name,
            _ListContacts[msg.sender][_index].relation, 
            _index
        );

    }
    
    // @notice Udpate contact relation
    // @param _index
    // @param _newrealtion
    function updateRelation(
        uint256 _index,
        Relation _newRelation
    )
        external 
        // use modifier to verify index
        onlyValidIndex(msg.sender, _index) 
    {
        // update value
        _ListContacts[msg.sender][_index].relation =  _newRelation;
    
        // increment counter updates
        _ListContacts[msg.sender][_index].counterUpdates++;

        emit UpdateContact(
            msg.sender, 
             _ListContacts[msg.sender][_index].name,
            _ListContacts[msg.sender][_index].name,
            _newRelation,    
            _index
        );
    }

    // @notice Delet a contact using the index by pop method
    // @param _index
    // @return ok = true if contact is deleted
    function deletContact(
        uint256 _index
        )
        external 
        onlyValidIndex(msg.sender, _index)
        returns (bool ok)  
    
        {
            uint256 len = _ListContacts[msg.sender].length;
            //Verify its the last element to apply pop method
            require(
                _index == len - 1,
                "Only last element can be delet with pop"
            );
    
            _ListContacts[msg.sender].pop;
            emit DeletedContact(msg.sender, _index);
            ok = true;
        }
    
    // @notice View specific contact from any user
    // @param _user address
    // @param _index 
    // @return Contact info in mem 
    function viewContact(
        address _user, 
        uint256 _index
    ) 
    external view
    onlyValidIndex(_user, _index)
    returns (Contact memory) 
    {
        return _ListContacts[_user][_index];
    }

    // @notice List my contacts
    // @return len = number of contacts
    function viewMyContacts()
    external view
    returns (Contact[] memory)
    {
        return _ListContacts[msg.sender];
    }
    
}