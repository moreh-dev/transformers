task_list=(
    "text-classification-glue"
    "text-classification-xnli"
    "token-classification"
    "question-answering"
    "question-answering-beam"
    "question-answering-seq2seq"
    "semantic-segmentation"
    "multiple-choice"
    "language-modeling-clm"
    "language-modeling-mlm"
    "language-modeling-plm"
    "image-classification"
    "image-pretraining-mae"
    "image-pretraining-mim"
    "audio-classification"
    "speech-recognition-ctc"
    "speech-recognition-seq2seq"
    "summarization"
    "translation"
)

task_task_folder_lst=(
    "text-cls-glue#text-classification#train_glue.sh"
    "text-cls-xnli#text-classification#train_xnli.sh"
    "qa#question-answering#train_qa.sh"
    "qa-beam#question-answering#train_qa_beam.sh"
    "qa-seq2seq#question-answering#train_seq2seq.sh"
    "semantic-segmentation#semantic-segmentation#train.sh"
    "multiple-choice#multiple-choice#train.sh"
    "token-classification#token-classification#train.sh"
    "image-classification#image-classification#train.sh"
    "language-modeling-clm#language-modeling#train_clm.sh"
    "language-modeling-mlm#language-modeling#train_mlm.sh"
    "language-modeling-plm#language-modeling#train_plm.sh"
    "image-pretraining-mae#image-pretraining#train_mae.sh"
    "image-pretraining-mim#image-pretraining#train_min.sh"
    "audio-classification#audio-classification#train.sh"
    "speech-recognition-ctc#speech-recognition#train_ctc.sh"
    "speech-recognition-seq2seq#speech-recognition#train_seq2seq.sh"
    "summarization#summarization#train.sh"
    "translation#translation#train.sh"
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
-a, --all         Run all task
-t, --task        Run the task you want
-h, --help        Print this help and exit
-s, --show        Print availavle task list
EOF
  exit
}

run_task() {
    task=$1
    model_batchsize_file=$2
    memory_record_script=$3
    train_script=$4

    log_folder=../$task/logs
    echo "Running task: $task"
    echo "Log folder: $log_folder"
    echo "Model batch size file: $model_batchsize_file"
    echo "Memory record script: $memory_record_script"
    echo "Train file: $train_script"
    while read -r model batch_size device_id ; do
        echo "=============================================================="
        echo "Model: $model Batch_size: $batch_size Device_id: $device_id"
        echo "=============================================================="

        # Record memory in background
        memory_log_file="$log_folder/${model#*/}-$batch_size.memory"
        if [ ! -d "$log_folder" ]; then
            # If the folder does not exist, create it
            mkdir -p "$log_folder"
            echo "Created 'logs' folder inside $task directory."
        fi
        model_log_folder=$log_folder/${model#*/}/
        # Train model
        chmod a+x "../$task/$train_script"
        cd "../$task/"
        bash $train_script -m "$model" -b "$batch_size" -g "$device_id" &
        pid=$!
        cd ../all_scripts/
        bash "$memory_record_script" $pid $task $model $batch_size $model_log_folder
        
        echo "++++++++++++++++++++ Done ++++++++++++++++++++"
    done < "../$task/$model_batchsize_file"
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
                    task=text-classification
                    echo -ne "your task is $task glue dataset\n"
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs                 

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1

                    train_script=train_glue.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "text-cls-xnli" | "text-classification-xnli")
                    task=text-classification
                    echo -ne "your task is $task glue dataset\n"      
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_xnli.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "qa" | "question answering")
                    task=question-answering
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n" 

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1

                    train_script=train_qa.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "qa-beam" | "question answering beam")
                    task=question-answering
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n" 

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1

                    train_script=train_qa_beam.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;   

                "qa-seq2seq" | "question answering seq2seq")
                    task=question-answering
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"                  

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_seq2seq.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;  

                "mul-choice" | "multiple-choice")
                    task=multiple-choice
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "segmentation" | "semantic-segmentation")
                    task=semantic-segmentation
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                
                    train_script=train.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "lang-modeling-clm" | "language-modeling-clm" )
                    task=language-modeling
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_clm.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "lang-modeling-mlm" | "language-modeling-mlm" )
                    task=language-modeling
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_mlm.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "lang-modeling-plm" | "language-modeling-plm" )
                    task=language-modeling
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1

                    train_script=train_plm.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "img-cls" | "image-classification" )
                    task=image-classification
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "token-cls" | "token-classification" )
                    task=token-classification
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "audio-cls" | "audio-classification" )
                    task=audio-classification
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "img-pretrain-mae"|"image-pretraining-mae" )
                    task=image-pretraining
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    model_batchsize_file_mae=model_batchsize_mae.txt
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file_mae" ]] && echo "$task/$model_batchsize_file_mae not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_mae.sh
                    run_task $task $model_batchsize_file_mae $memory_record_script $train_script
                    ;;

                "img-pretrain-mim"|"image-pretraining-mim" )
                    task=image-pretraining
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    model_batchsize_file_mim=model_batchsize_mim.txt
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file_mim" ]] && echo "$task/$model_batchsize_file_mim not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_mim.sh
                    run_task $task $model_batchsize_file_mim $memory_record_script $train_script
                    ;;

                "speech-rec-ctc"| "speech-recognition-ctc" )
                    task=speech-recognition
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    model_batchsize_file_ctc=model_batchsize_ctc.txt
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file_ctc" ]] && echo "$task/$model_batchsize_file_ctc not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_seq2seq.sh
                    run_task $task $model_batchsize_file_ctc $memory_record_script $train_script
                    ;;

                "speech-rec-seq2seq"| "speech-recognition-seq2seq" )
                    task=speech-recognition
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    model_batchsize_file_seq2seq=model_batchsize_seq2seq.txt
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file_seq2seq" ]] && echo "$task/$model_batchsize_file_seq2seq not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train_seq2seq.sh
                    run_task $task $model_batchsize_file_seq2seq $memory_record_script $train_script
                    ;;

                "summarization" )
                    task=summarization
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                "translation" )
                    task=translation
                    export PATH=$PATH:../${task}
                    log_folder=../$task/logs
                    echo -ne "your task is ${task}\n"

                    [[ ! -f "../$task/$model_batchsize_file" ]] && echo "$task/$model_batchsize_file not exist" && exit 1

                    [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && exit 1
                    
                    train_script=train.sh
                    run_task $task $model_batchsize_file $memory_record_script $train_script
                    ;;

                *)
                    echo -ne "Invalid task\n"
                    exit 0;;
            esac 
            exit 0;;
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

                [[ ! -f "../$folder_name/$model_batchsize_file" ]] && echo "$folder_name/$model_batchsize_file not exist" && break

                [[ ! -f "./$memory_record_script" ]] && echo "$memory_record_script not exist" && break

                while read -r model batch_size device_id task_type; do
                    echo "=============================================================="
                    echo Model: $model Batch_size: $batch_size Device_id: $device_id Other args: $task_type
                    echo "=============================================================="
                    

                    model_log_folder=$log_folder/${model#*/}/

                    # train in model
                    /bin/chmod a+x ../${folder_name}/${train_file}
                    cd ../${folder_name}/
                    bash  $train_file -m $model -b $batch_size -g $device_id &
                    pid=$!
                    # record memory in background
                    cd ../all_scripts/
                    bash "$memory_record_script" $pid $task $model $batch_size $model_log_folder
                    echo "++++++++++++++++++++ Done ++++++++++++++++++++"
                done < "../$folder_name/$model_batchsize_file"
                
            done
            exit 0
            ;;
    esac
    shift
done