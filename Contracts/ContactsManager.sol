// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract MyContacts {

    enum Relation {None, Friend, Family, Colleague}
    // Mapping to convert enum to string
    mapping(Relation => string) public RelationToString;

    struct Contact {
        string name;
        address wallet;
        Relation relation;
        uint256 counterUpdates;
    }

    mapping (address => Contact[]) private _ListContacts;

    modifier onlyValidIndex(uint256 _index) {
        require( _index < _ListContacts[msg.sender].length, "invalid index" );
        _;
    }

    event AddContact(
        address indexed user, 
        string name,
        address wallet, 
        Relation relation,
        uint256 index
    );

    event UpdateContact(
        address indexed user,
        string oldValue, 
        string newValue,
        uint256 index
    );
     

    function createContact(
        string memory _name, 
        address _wallet, 
        Relation _relation
    )
        external 
        returns (uint256 index)
    {
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

    function updateName(
        uint256 _index, 
        string memory _newDescription
    )
        external 
        // use modifier to verify _index
        onlyValidIndex(_index) 
    {
    
        // save old value
        string memory oldValue = _ListContacts[msg.sender][_index].name;
        // update value
        _ListContacts[msg.sender][_index].name = _newDescription;
        // increment counter updates
        _ListContacts[msg.sender][_index].counterUpdates++;
        // emit event
        emit UpdateContact(msg.sender, oldValue, _ListContacts[msg.sender][_index].name, _index);

    }
    

    function updateRelation(
        uint256 _index,
        Relation _newRelation
    )
        external 
        // use modifier to verify index
        onlyValidIndex(_index) 
    {
         // save old value
        Relation oldValue = _ListContacts[msg.sender][_index].relation;
        string memory oldValueToString = RelationToString[oldValue];
        // update value
        _ListContacts[msg.sender][_index].relation =  _newRelation;
        string memory newRelationToString = RelationToString[_newRelation];
        // increment counter updates
        _ListContacts[msg.sender][_index].counterUpdates++;
        emit UpdateContact(msg.sender, oldValueToString, newRelationToString, _index);
    }

        
    

    function deletContact(
        uint256 _index
        )public{

    }

    function viewContact(address _user, uint256 _index) public view {

    }

    function viewMyContacts()public view{

    }
}