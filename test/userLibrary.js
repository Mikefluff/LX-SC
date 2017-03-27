const Reverter = require('./helpers/reverter');
const Asserts = require('./helpers/asserts');
const Storage = artifacts.require('./Storage.sol');
const ManagerMock = artifacts.require('./ManagerMock.sol');
const UserLibrary = artifacts.require('./UserLibrary.sol');
const EventsHistory = artifacts.require('./EventsHistory.sol');

contract('UserLibrary', function(accounts) {
  const reverter = new Reverter(web3);
  afterEach('revert', reverter.revert);

  const asserts = Asserts(assert);
  let storage;
  let eventsHistory;
  let userLibrary;

  before('setup', () => {
    return Storage.deployed()
    .then(instance => storage = instance)
    .then(() => ManagerMock.deployed())
    .then(instance => storage.setManager(instance.address))
    .then(() => UserLibrary.deployed())
    .then(instance => userLibrary = instance)
    .then(() => EventsHistory.deployed())
    .then(instance => eventsHistory = instance)
    .then(() => userLibrary.setupEventsHistory(eventsHistory.address))
    .then(() => eventsHistory.addVersion(userLibrary.address, '_', '_'))
    .then(reverter.snapshot);
  });

  it('should add user role', () => {
    const user = accounts[1];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role))
    .then(() => userLibrary.hasRole(user, role))
    .then(asserts.isTrue);
  });

  it('should emit AddRole event in EventsHistory', () => {
    const user = accounts[1];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role))
    .then(result => {
      assert.equal(result.logs.length, 1);
      assert.equal(result.logs[0].address, eventsHistory.address);
      assert.equal(result.logs[0].event, 'AddRole');
      assert.equal(result.logs[0].args.user, user);
      assert.equal(result.logs[0].args.role, role);
    });
  });

  it('should not have user role by default', () => {
    const user = accounts[1];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    return Promise.resolve()
    .then(() => userLibrary.hasRole(user, role))
    .then(asserts.isFalse);
  });

  it('should remove user role', () => {
    const user = accounts[1];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role))
    .then(() => userLibrary.removeRole(user, role))
    .then(() => userLibrary.hasRole(user, role))
    .then(asserts.isFalse);
  });

  it('should emit RemoveRole event in EventsHistory', () => {
    const user = accounts[1];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role))
    .then(() => userLibrary.removeRole(user, role))
    .then(result => {
      assert.equal(result.logs.length, 1);
      assert.equal(result.logs[0].address, eventsHistory.address);
      assert.equal(result.logs[0].event, 'RemoveRole');
      assert.equal(result.logs[0].args.user, user);
      assert.equal(result.logs[0].args.role, role);
    });
  });

  it('should not add user role if not allowed', () => {
    const user = accounts[1];
    const nonOwner = accounts[2];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role, {from: nonOwner}))
    .then(() => userLibrary.hasRole(user, role))
    .then(asserts.isFalse);
  });

  it('should not remove user role if not allowed', () => {
    const user = accounts[1];
    const nonOwner = accounts[2];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role))
    .then(() => userLibrary.removeRole(user, role, {from: nonOwner}))
    .then(() => userLibrary.hasRole(user, role))
    .then(asserts.isTrue);
  });

  it('should add several user roles', () => {
    const user = accounts[1];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    const role2 = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role))
    .then(() => userLibrary.addRole(user, role2))
    .then(() => userLibrary.hasRole(user, role))
    .then(asserts.isTrue)
    .then(() => userLibrary.hasRole(user, role2))
    .then(asserts.isTrue);
  });

  it('should differentiate users', () => {
    const user = accounts[1];
    const user2 = accounts[2];
    const role = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
    const role2 = '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00';
    return Promise.resolve()
    .then(() => userLibrary.addRole(user, role))
    .then(() => userLibrary.addRole(user2, role2))
    .then(() => userLibrary.hasRole(user2, role))
    .then(asserts.isFalse)
    .then(() => userLibrary.hasRole(user, role2))
    .then(asserts.isFalse)
    .then(() => userLibrary.hasRole(user, role))
    .then(asserts.isTrue)
    .then(() => userLibrary.hasRole(user2, role2))
    .then(asserts.isTrue);
  });
});
