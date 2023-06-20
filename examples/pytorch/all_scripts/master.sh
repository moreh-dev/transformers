#!/bin/bash
echo -e "text-cls \
        \n text-gen \
        \n text-gen \
        \n token-cls-glue \
        \n token-cls-xnli \
        \n mul-choice \
        \n qa \
        \n qa-beam \
        \n qa-seq2seq \
        \n translation \
    "
read -p "Choose task: " task

case $task in
    "text-cls-glue" | "text-classification-glue")
        echo -ne "your task is text-classification glue dataset\n"
        export PATH=$PATH:/nas/thang/ml-workbench/transformer/transformers/examples/pytorch/text-classification
        # read -p "model name: " model
        # read -p "batch size: " batch_size
        # read -p "device id: " device_id
        # read -p "task name: " task_name

        model=bert-base-uncased
        batch_size=32
        device_id=1
        task_name=mrpc

        # # record memory in background
        # memory_log_file=$log_folder/${model#*/}-$batch_size.memory
        # bash $memory_record_script $gpu 2>&1 >> $memory_log_file &
        # daemon_pid=$!

        /bin/chmod a+x ../text-classification/train_glue.sh
        cd ../text-classification/
        bash  train_glue.sh -m $model -b $batch_size -g $device_id -t $task_name
        
        ;;

    "text-cls-xnli" | "text-classification-xnli")
        echo -ne "your task is text-classification xnli\n"
        export PATH=$PATH:/nas/thang/ml-workbench/transformer/transformers/examples/pytorch/text-classification
        # read -p "model name: " model
        # read -p "batch size: " batch_size
        model=bert-base-multilingual-cased
        batch_size=32
        device_id=1
        /bin/chmod a+x ../text-classification/train_xnli.sh
        cd ../text-classification/
        bash  train_xnli.sh -m $model -b $batch_size -g $device_id
        ;;

    "qa" | "question answering")
        echo -ne "your task is question answering\n"
        export PATH=$PATH:/nas/thang/ml-workbench/transformer/transformers/examples/pytorch/question-answering
        # read -p "model name: " model
        # read -p "batch size: " batch_size
        # read -p "device id: " device_id
        model=t5-small
        batch_size=64
        device_id=1
        /bin/chmod a+x ../question-answering/train_qa.sh
        cd ../question-answering/
        bash  train_qa.sh -m $model -b $batch_size -g $device_id
        ;;

    "qa-beam" | "question answering beam")
        echo -ne "your task is question answering\n"
        export PATH=$PATH:/nas/thang/ml-workbench/transformer/transformers/examples/pytorch/question-answering
        # read -p "model name: " model
        # read -p "batch size: " batch_size
        # read -p "device id: " device_id
        model=xlnet-large-cased
        batch_size=64
        device_id=1
        /bin/chmod a+x ../question-answering/train_qa_beam.sh
        cd ../question-answering/
        bash  train_qa_beam.sh -m $model -b $batch_size -g $device_id
        ;;   

    "qa-seq2seq" | "question answering seq2seq")
        echo -ne "your task is question answering\n"
        export PATH=$PATH:/nas/thang/ml-workbench/transformer/transformers/examples/pytorch/question-answering
        # read -p "model name: " model
        # read -p "batch size: " batch_size
        # read -p "device id: " device_id
        model=t5-small
        batch_size=64
        device_id=1
        /bin/chmod a+x ../question-answering/train_seq2seq.sh
        cd ../question-answering/
        bash  train_seq2seq.sh -m $model -b $batch_size -g $device_id
        ;;  

    *)
        echo -ne "Invalid task\n"
        ;;
esac