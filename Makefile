BRANCH?=$(shell git rev-parse --abbrev-ref HEAD)

.DEFAULT_GOAL := help
.PHONY: help

## Run tests on any file change
watch: test_deps
	while sleep 1; do \
		find defaults/ meta/ tasks/ tests/test.yml tests/vagrant/Vagrantfile \
		| entr -d make vagrant_up; \
	done

## Run test
test: test_deps vagrant_up

integration_test: clean integration_test_deps vagrant_up clean

test_deps:
	rm -f tests/ansible-city.ssh_auth_sock
	ln -s .. tests/ansible-city.ssh_auth_sock
	ansible-galaxy install -p tests -r tests/local_requirements.yml

## Start and (re)provisiom Vagrant test box
vagrant_up:
	cd tests/vagrant && vagrant up --no-provision
	cd tests/vagrant && vagrant provision

## Execute simple Vagrant command
# Example: make vagrant_ssh
#          make vagrant_halt
vagrant_%:
	cd tests/vagrant && vagrant $(subst vagrant_,,$@)

## Clean up
clean:
	rm -rf tests/ansible-city.*
	cd tests/vagrant && vagrant destroy

## Prints this help
help:
	@awk 'BEGIN{ doc_mode=0; doc=""; doc_h="" } { \
		if ("##"==$$1 && doc_mode==0) { doc_mode=2 } \
		if (match($$1, /^[%.a-zA-Z_-]+:/) && doc_mode==1) { printf "\033[34m%-30s\033[0m\033[1m%s\033[0m %s\n\n", $$1, doc_h, doc; doc_mode=0; doc="" } \
		if (doc_mode==1) { $$1=" "; doc=doc "\n" $$0 } \
		if (doc_mode==2) { doc_mode=1; $$1=""; doc_h=$$0 } }' $(MAKEFILE_LIST)
