pragma solidity ^0.4.8;

import './Storage.sol';

library StorageInterface {
    struct Config {
        Storage store;
        bytes32 crate;
    }

    struct UInt {
        bytes32 id;
    }

    struct Int {
        bytes32 id;
    }

    struct Address {
        bytes32 id;
    }

    struct Bool {
        bytes32 id;
    }

    struct Bytes32 {
        bytes32 id;
    }

    struct Mapping {
        bytes32 id;
    }

    function init(Config storage self, Storage _store, bytes32 _crate) internal {
        self.store = _store;
        self.crate = _crate;
    }

    function init(UInt storage self, bytes32 _id) internal {
        self.id = _id;
    }

    function init(Int storage self, bytes32 _id) internal {
        self.id = _id;
    }

    function init(Address storage self, bytes32 _id) internal {
        self.id = _id;
    }

    function init(Bool storage self, bytes32 _id) internal {
        self.id = _id;
    }

    function init(Bytes32 storage self, bytes32 _id) internal {
        self.id = _id;
    }

    function init(Mapping storage self, bytes32 _id) internal {
        self.id = _id;
    }

    function set(Config storage self, UInt storage item, uint _value) internal returns(bool) {
        return self.store.setUInt(self.crate, item.id, _value);
    }

    function set(Config storage self, Int storage item, int _value) internal returns(bool) {
        return self.store.setInt(self.crate, item.id, _value);
    }

    function set(Config storage self, Address storage item, address _value) internal returns(bool) {
        return self.store.setAddress(self.crate, item.id, _value);
    }

    function set(Config storage self, Bool storage item, bool _value) internal returns(bool) {
        return self.store.setBool(self.crate, item.id, _value);
    }

    function set(Config storage self, Bytes32 storage item, bytes32 _value) internal returns(bool) {
        return self.store.setBytes32(self.crate, item.id, _value);
    }

    function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _value) internal returns(bool) {
        return self.store.setBytes32(self.crate, sha3(item.id, _key), _value);
    }

    function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _value) internal returns(bool) {
        return self.store.setBytes32(self.crate, sha3(item.id, _key, _key2), _value);
    }

    function set(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3, bytes32 _value) internal returns(bool) {
        return self.store.setBytes32(self.crate, sha3(item.id, _key, _key2, _key3), _value);
    }

    function get(Config storage self, UInt storage item) internal constant returns(uint) {
        return self.store.getUInt(self.crate, item.id);
    }

    function get(Config storage self, Int storage item) internal constant returns(int) {
        return self.store.getInt(self.crate, item.id);
    }

    function get(Config storage self, Address storage item) internal constant returns(address) {
        return self.store.getAddress(self.crate, item.id);
    }

    function get(Config storage self, Bool storage item) internal constant returns(bool) {
        return self.store.getBool(self.crate, item.id);
    }

    function get(Config storage self, Bytes32 storage item) internal constant returns(bytes32) {
        return self.store.getBytes32(self.crate, item.id);
    }

    function get(Config storage self, Mapping storage item, bytes32 _key) internal constant returns(bytes32) {
        return self.store.getBytes32(self.crate, sha3(item.id, _key));
    }

    function get(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2) internal constant returns(bytes32) {
        return self.store.getBytes32(self.crate, sha3(item.id, _key, _key2));
    }

    function get(Config storage self, Mapping storage item, bytes32 _key, bytes32 _key2, bytes32 _key3) internal constant returns(bytes32) {
        return self.store.getBytes32(self.crate, sha3(item.id, _key, _key2, _key3));
    }

    function toBool(bytes32 _value) constant returns(bool) {
        return _value != bytes32(0);
    }

    function toBytes32(bool _value) constant returns(bytes32) {
        return bytes32(_value ? 1 : 0);
    }
}
