device=${1:-0}


if [[ $HOSTNAME =~ "haca100" ]]; then
    export CUDA_VISIBLE_DEVICES=$device
    bash memory_record_moreh.sh $device 2>&1 >> ./logs/gpu-mem.log &
else
    export MOREH_VISIBLE_DEVICES=$device
    bash all_scripts/memory_record_moreh.sh $device 2>&1 >> gpu-mem.log &
fi

daemon_pid=$!


cd multiple-choice
bash train.sh google/mobilebert-uncased 64 outputs


kill -9 $daemon_pid