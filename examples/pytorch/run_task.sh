# This script is only for tasks with only 1 type of training
# =======================

# audio-classification
# contrastive-image-text
# image-classification
# multiple-choice
# semantic-segmentation
# speech-pretraining
# summarization
# token-classification
# translation


while getopts t:g flag
do
    case "${flag}" in
        t) task=${OPTARG};;
        g) gpu=${OPTARG};;
    esac
done

echo Task: $task
echo GPU: $gpu


# prepare necessary files
# =======================
train_script="train.sh"
[[ ! -f "$task/$train_script" ]] && echo "${file} not exist" && exit 1

model_batchsize_file="model_batchsize.txt"
[[ ! -f "$task/$model_batchsize_file" ]] && echo "${file} not exist" && exit 1

memory_record_script=$(pwd)/all_scripts/memory_record_moreh.sh
log_folder=$(pwd)/$task/logs


# loop through all available models
# train and record memory usage of each
# ========================
cd $task

while read model batch_size ; do
    echo Model: $model
    echo Batch_size: $batch_size

    # record memory in background
    memory_log_file=$log_folder/${model#*/}-$batch_size.memory
    bash $memory_record_script $gpu 2>&1 >> $memory_log_file &
    daemon_pid=$!

    # train in parallel
    bash $train_script -m $model -b $batch_size -g $gpu

    kill -9 $daemon_pid

done < $model_batchsize_file

echo Done