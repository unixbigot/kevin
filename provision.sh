#!/bin/bash
#set -x
ROLE="$@"
[ -n "$ROLE" ] || ROLE=base
[ -n "$LOG" ] || LOG=warning
[ -n "$TARGET" ] || TARGET=target
[ -n "$MASTER" ] || MASTER=192.168.99.1

ARGS="--config-dir etc --force-color -l $LOG"

echo "Looking for connected salt minion on $TARGET"
# Note this will spew an error if the master has zero known minions
salt-run manage.up | tee .out
MINIONS_FOUND="`grep -e '^- ' .out | wc -l`"

if [ "$MINIONS_FOUND" -ge 1 ]
then
    echo "Found $MINIONS_FOUND active salt minion(s)"
else
    rm -f $HOME/.ssh/known_hosts
    echo "Installing salt-minion on $TARGET"
    ./salt-ssh $ARGS -i $TARGET state.apply salt.provision_minion pillar="{\"salt_minion\": {\"master_host\": \"$MASTER\"}, \"roles\": [\"$ROLE\"]}" | tee .out
    if grep 'Failed: *0' .out >/dev/null
    then
      echo "INFO: $TARGET was updated with salt-minion"
    else
      echo "ERROR: could not install salt-minion"
      exit 1
    fi

    while :
    do
      echo "Waiting for new minion to connect"
      salt-run manage.up | tee .out
      MINIONS_FOUND="`grep -e '^- ' .out | wc -l`"
      if [ "$MINIONS_FOUND" -ge 1 ]
      then
	break
      fi
      sleep 5
    done
fi

echo "Applying states to new minion"

salt $ARGS -G 'roles:provision_minion' state.apply | tee .out
if grep '# of minions with errors:.* 0' .out >/dev/null && grep '# of minions that did not return:.* 0' .out >/dev/null
then
  echo "INFO: $TARGET was updated with desired states"
else
  echo "ERROR: could not apply desired states"
  exit 1
fi

echo "ERASE step skipped"
exit 0
echo "Erasing provisioning diversions on minion"
salt $ARGS -G 'rols:provision_minion' state.apply salt.provision_reset
