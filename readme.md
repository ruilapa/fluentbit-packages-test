# fluent-bit-package-tests

Repository used to test td-agent-bit install and service enable/start using Kitchen and InSpec

## Install

#### Requirements

- [Chef Workstation](https://downloads.chef.io/tools/workstation)
- AWS account

#### Tools used

- [Kitchen](https://kitchen.ci/)

- [Chef InSpec](https://docs.chef.io/inspec)

## Documentation 

#### install-td-agent-bit.sh

Used to install td-agent-bit on multiple distros

#### test/integration/default/default_test.rb

Tests to apply

## Procedure

#### Creating instances

```
export version=1.8.1
# export keypair=default-keypair
export AWS_SUBNET="subnet-NNNNN"
export AWS_PROFILE="default"
export AWS_REGION="eu-central-1"
export AWS_SPOT_PRICE="on-demand"

kitchen create --concurrency 10 --parallel
```

#### Tests

```
kitchen converge
kitchen verify
```

#### Destroying instances

```
kitchen destroy --concurrency 10 --parallel
```

## TODO

#### Tests
- Config changes
- Upgrades

#### Install

- More distros
- Improve support
