
contract('UserProxy', function(accounts) {
  const reverter = new Reverter(web3);
  afterEach('revert', reverter.revert);

  let userProxy;
  let tester;

  before('setup', () => {
    return UserProxy.deployed()
    .then(instance => userProxy = instance)
    .then(() => UserProxyTester.deployed())
    .then(instance => tester = instance)
    .then(reverter.snapshot);
  });

  it('should create users', () => {

  });

  it('should create proxys', () => {

  });

  it('should create users and set theirs proxys', () => {

  });
}