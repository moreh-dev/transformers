task_list=(
    "text-gen"
    "text-cls-glue"
    "text-cls-xnli"
    "mul-choice"
    "qa"
    "qa-beam"
    "qa-seq2seq"
    "translation"
)

task_task_folder_lst=(
    "text-cls-glue#text-classification#train_glue.sh"
    "text-cls-xnli#text-classification#train_xnli.sh"
    "qa#question-answering#train_qa.sh"
    "qa-beam#question-answering#train_qa_beam.sh"
    "qa-seq2seq#question-answering#train_seq2seq.sh"
)
# Global vars
model_batchsize_file="model_batchsize.txt"
memory_record_script="memory_record_moreh.sh"

get_available_tasks() {
    echo "Available Tasks"
    echo "===================================="
    for i in ${task_list[@]}
    do 
        echo $i
    done 
    echo "===================================="
}

usage(){
  cat <<EOF
Usage: master [-h|--help] [-a|--all] [-t|--task] [-s|--show]
Example: master -t qa

Avaiable options:
-a, --all            Run all task
-t, --target         Run the task you want
-h, --help           Print this help and exit
-s, --show           Print availavle task list
EOF
  exit
}

if [[ $# -eq 0 ]]
then
    usage
fi

while test $# -gt 0
do
    case "$1" in
        -s | --show)
            get_available_tasks
            exit 0;;
        -h | --help)
            usage
            exit 0;;
        -t | --task)
            task_name=$2
            case $task_name in
                "text-cls-glue" | "text-classification-glue")
                    echo -ne "your task is text-classification glue dataset\n"
                    task=text-classification
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1

                    while read -r model batch_size device_id glue_task_name; do
                        echo "=============================================================="
                        echo Model: $model Batch_size: $batch_size Device_id: $device_id Task_name: $glue_task_name
                        echo "=============================================================="
                        
                        # record memory in background
                        memory_log_file=$log_folder/${model#*/}-$batch_size.memory
                        touch $memory_log_file
                        bash $memory_record_script $device_id 2>&1 >> $memory_log_file &daemon_pid=$!

                        # train in model
                        /bin/chmod a+x ../text-classification/train_glue.sh
                        cd ../text-classification/
                        bash  train_glue.sh -m $model -b $batch_size -g $device_id -t $glue_task_name

                        kill -9 $daemon_pid
                        echo "++++++++++++++++++++ Done ++++++++++++++++++++"
                    done < "../$task/$model_batchsize_file"
                    
                    ;;

                "text-cls-xnli" | "text-classification-xnli")
                    echo -ne "your task is text-classification glue dataset\n"
                    task=text-classification
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    while read -r model batch_size device_id ; do
                        echo "=============================================================="
                        echo Model: $model Batch_size: $batch_size Device_id: $device_id
                        echo "=============================================================="
                        
                        # record memory in background
                        memory_log_file=$log_folder/${model#*/}-$batch_size.memory
                        touch $memory_log_file
                        bash $memory_record_script $device_id 2>&1 >> $memory_log_file &daemon_pid=$!

                        # train in model
                        /bin/chmod a+x ../text-classification/train_xnli.sh
                        cd ../text-classification/
                        bash  train_xnli.sh -m $model -b $batch_size -g $device_id

                        kill -9 $daemon_pid
                        echo "++++++++++++++++++++ Done ++++++++++++++++++++"
                    done < "../$task/$model_batchsize_file"

                    ;;

                "qa" | "question answering")
                    echo -ne "your task is question answering\n"
                    task=question-answering
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1

                    while read -r model batch_size device_id ; do
                        echo "=============================================================="
                        echo Model: $model Batch_size: $batch_size Device_id: $device_id
                        echo "=============================================================="
                        
                        # record memory in background
                        memory_log_file=$log_folder/${model#*/}-$batch_size.memory
                        touch $memory_log_file
                        bash $memory_record_script $device_id 2>&1 >> $memory_log_file &daemon_pid=$!

                        # train in model
                        /bin/chmod a+x ../question-answering/train_qa.sh
                        cd ../question-answering/
                        bash  train_qa.sh -m $model -b $batch_size -g $device_id

                        kill -9 $daemon_pid
                        echo "++++++++++++++++++++ Done ++++++++++++++++++++"
                    done < "../$task/$model_batchsize_file"

                    ;;

                "qa-beam" | "question answering beam")
                    echo -ne "your task is question answering\n"
                    task=question-answering
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1

                    while read -r model batch_size device_id ; do
                        echo "=============================================================="
                        echo Model: $model Batch_size: $batch_size Device_id: $device_id
                        echo "=============================================================="
                        
                        # record memory in background
                        memory_log_file=$log_folder/${model#*/}-$batch_size.memory
                        touch $memory_log_file
                        bash $memory_record_script $device_id 2>&1 >> $memory_log_file &daemon_pid=$!

                        # train in model
                        /bin/chmod a+x ../question-answering/train_qa_beam.sh
                        cd ../question-answering/
                        bash  train_qa_beam.sh -m $model -b $batch_size -g $device_id

                        kill -9 $daemon_pid
                        echo "++++++++++++++++++++ Done ++++++++++++++++++++"
                    done < "../$task/$model_batchsize_file"

                    ;;   

                "qa-seq2seq" | "question answering seq2seq")
                    echo -ne "your task is question answering\n"
                    task=question-answering
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    while read -r model batch_size device_id ; do
                        echo "=============================================================="
                        echo Model: $model Batch_size: $batch_size Device_id: $device_id
                        echo "=============================================================="
                        
                        # record memory in background
                        memory_log_file=$log_folder/${model#*/}-$batch_size.memory
                        touch $memory_log_file
                        bash $memory_record_script $device_id 2>&1 >> $memory_log_file &daemon_pid=$!

                        # train in model
                        /bin/chmod a+x ../question-answering/train_seq2seq.sh
                        cd ../question-answering/
                        bash  train_seq2seq.sh -m $model -b $batch_size -g $device_id

                        kill -9 $daemon_pid
                        echo "++++++++++++++++++++ Done ++++++++++++++++++++"
                    done < "../$task/$model_batchsize_file"

                    ;;  

                *)
                    echo -ne "Invalid task\n"
                    exit 0;;
            esac ;;
        -a | --all  | *)
            for item in "${task_task_folder_lst[@]}"; do
                IFS='#' read -ra split_item <<< "$item"
                task=${split_item[0]} # First part before #
                folder_name=${split_item[1]} # Second part after #
                train_file=${split_item[2]} # Third part after #
                echo "$task "
                echo "$folder_name "
                echo "$train_file "
                echo -ne "your task is ${task}\n"
                export PATH=$PATH:../${folder_name}
                log_folder=../$folder_name/logs

                [[ ! -f "../$folder_name/$model_batchsize_file" ]] && echo "$folder_name/$model_batchsize_file not exist" && continue 

                [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && continue 

                while read -r model batch_size device_id task_type; do
                    echo "=============================================================="
                    echo Model: $model Batch_size: $batch_size Device_id: $device_id Other args: $task_type
                    echo "=============================================================="
                    
                    # record memory in background
                    memory_log_file=$log_folder/${model#*/}-$batch_size.memory
                    touch $memory_log_file
                    bash $memory_record_script $device_id 2>&1 >> $memory_log_file &daemon_pid=$!

                    # train in model
                    /bin/chmod a+x ../${folder_name}/${train_file}
                    cd ../${folder_name}/
                    bash  $train_file -m $model -b $batch_size -g $device_id

                    kill -9 $daemon_pid
                    echo "++++++++++++++++++++ Done ++++++++++++++++++++"
                done < "../$folder_name/$model_batchsize_file"
                cd ../all_scripts/
            done
            ;;
    esac
    shift
done