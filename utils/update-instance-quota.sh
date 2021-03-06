#!/bin/bash
#
#
## Danilo Ferri Perogil [20120903]: Alteracao dos valores de limite de instancias do OpenStack
#
#

VALUE="$1"
CONF='/etc/nova/nova-controller.conf'
QUOTA_INSTANCE=$(egrep quota_instances $CONF)
NOVA='/etc/init.d/nova-api.sh'


USAGE() {
	printf "\n\n./$0 valor_max_instances\n\n"
}

MAIN() {
	[ -z "$VALUE" ] && USAGE && exit 0

	[ ! -e "$CONF-bkp" ] && cp -f $CONF $CONF-bkp

	mysql -u root -p -e "use nova; update quotas set hard_limit=$VALUE where resource='instances';"
	sed -i "s/$QUOTA_INSTANCE/\--quota_instances=$VALUE/g" "$CONF"

	$NOVA restart
}

# Begin
MAIN
