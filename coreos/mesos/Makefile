target deploy : HOST := $(shell aws ec2 describe-instances --region=ap-southeast-2 --filters="Name=tag-value,Values=kevinl-coreos" | grep PublicDnsName | cut -d\" -f4 | grep -v '^$$' | head -1)
target fleetctl : FLEET_URL := $(shell curl -s https://api.github.com/repos/coreos/fleet/releases | grep browser_download_url | grep `uname -s | awk '{ print tolower($$0) }'`-amd64 | head -1 | awk -F': ' '{ print $$2 }' | sed 's/^"\(.*\)"$$/\1/')
target fleetctl : FLEET_FILENAME := $(shell echo ${FLEET_URL} | rev | cut -d/ -f1 | rev)
target fleetctl : FLEET_DIR := $(shell basename `basename ${FLEET_FILENAME} .zip` .tar.gz)

fleetctl:
	rm -rf $(FLEET_DIR)
	curl -#LO $(FLEET_URL)
	tar zxf $(FLEET_FILENAME)
	rm $(FLEET_FILENAME)
	mv `find ${FLEET_DIR}/ -iname fleetctl` ./fleetctl
	rm -rf $(FLEET_DIR)

deploy: fleetctl
	./fleetctl --tunnel $(HOST) destroy mesos-*.service
	./fleetctl --tunnel $(HOST) submit mesos-*.service
	./fleetctl --tunnel $(HOST) load mesos-*.service
	./fleetctl --tunnel $(HOST) list-units

ssh:
	ssh core@$(HOST)
