const EventsHistory = artifacts.require('./EventsHistory.sol');
const UserFactory = artifacts.require('./UserFactory.sol');
const Storage = artifacts.require('./Storage.sol');
const Reverter = require('./helpers/reverter');

contract('UserFactory', function(accounts) {
  const reverter = new Reverter(web3);
  afterEach('revert', reverter.revert);

  let userFactory;
  let eventsHistory;
  let storage;

  before('setup', () => {
    return UserFactory.deployed()
    .then(instance => userFactory = instance)
    .then(() => Storage.deployed())
    .then(instance => storage = instance)
    .then(() => EventsHistory.deployed())
    .then(instance => eventsHistory = instance)
    .then(() => userFactory.setupEventsHistory(eventsHistory.address))
    .then(reverter.snapshot);
  });

  it('should create users', () => {
    return userFactory.createUserWithProxyAndRecovery(storage.address, 'newlyCreatedUser')
    .then(result => {
      assert.equal(result.logs.length, 1);
      assert.equal(result.logs[0].event, 'UserCreated');
    });
  });

  it('should create proxys', () => {

  });

  it('should create users and set theirs proxys', () => {

  });
})
