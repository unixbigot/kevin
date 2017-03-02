#!/bin/bash
if [ "$1" = "" ]
then
  echo "usage: $0 role"
  exit 1
fi

[ -n "$LOG" ] || LOG=warning

banner "Looking for salt minion on target"
salt-run -l $LOG manage.up | tee .out
MINIONS_FOUND="`grep -e '^- ' .out | wc -l`"

if [ "$MINIONS_FOUND" -ge 1 ]
then
    echo "Already have $MINIONS_FOUND connected salt minion(s)"
else
    rm -f $HOME/.ssh/known_hosts
    echo "Installing salt-minion on target"
    salt-ssh -l $LOG -i target state.apply salt.new_minion pillar="{\"salt_minion\": {\"master_host\": \"192.168.0.1\"}, \"roles\": $ROLE}" | tee .out
    if grep 'Failed: *0' .out >/dev/null
    then
      echo "INFO: target was updated with salt-minion"
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

salt -l $LOG -G 'new_minion:1' state.apply | tee .out
if grep '# of minions with errors:.* 0' .out >/dev/null && grep '# of minions that did not return:.* 0' .out >/dev/null
then
  echo "INFO: target was updated with desired states"
else
  echo "ERROR: could not apply desired states"
  exit 1
fi

echo "Erasing provisioning diversions on minion"
salt -G 'new_minion:1' state.apply salt.new_minion_reset

