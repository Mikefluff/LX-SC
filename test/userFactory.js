const EventsHistory = artifacts.require('./EventsHistory.sol');
const UserFactory = artifacts.require('./UserFactory.sol');
const UserLibrary = artifacts.require('./UserLibrary.sol');
const ManagerMock = artifacts.require('./ManagerMock.sol');
const Storage = artifacts.require('./Storage.sol');
const Reverter = require('./helpers/reverter');

contract('UserFactory', function(accounts) {
  const reverter = new Reverter(web3);
  afterEach('revert', reverter.revert);

  let userFactory;
  let storage;

  before('setup', () => {
    return UserFactory.deployed()
    .then(instance => userFactory = instance)
    .then(() => Storage.deployed())
    .then(instance => storage = instance)
    .then(() => ManagerMock.deployed())
    .then(instance => storage.setManager(instance.address))
    .then(() => EventsHistory.deployed())
    .then(instance => eventsHistory = instance)
    .then(() => userFactory.setupEventsHistory(eventsHistory.address))
    .then(() => UserLibrary.deployed())
    .then(instance => userFactory.setupUserLibrary(instance.address))
    .then(reverter.snapshot);
  });

  it('should create users', () => {
    let roles = ['role1', 'role2'];
    let skills = ['skill1', 'skill2'];
    return userFactory.createUserWithProxyAndRecovery(storage.address, roles, skills)
    .then(result => {
      assert.equal(result.logs.length, 1);
      assert.equal(result.logs[0].event, 'UserCreated');
      assert.equal(result.logs[0].roles, roles);
      assert.equal(result.logs[0].skills, skills);
      assert.notNull(result.logs[0].proxy);
      assert.notNull(result.logs[0].user);
    });
  });

  it('should create proxys', () => {

  });

  it('should create users and set theirs proxys', () => {

  });
})
