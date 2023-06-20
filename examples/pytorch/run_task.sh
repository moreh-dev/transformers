# This script is only for tasks with only 1 type of training

# audio-classification
# contrastive-image-text
# image-classification
# multiple-choice
# semantic-segmentation
# speech-pretraining
# summarization
# token-classification
# translation


task=$1
gpu=$2

echo Task: $task

train_script="train.sh"
[[ ! -f "$task/$train_script" ]] && echo "${file} not exist" && exit 1

model_batchsize_file="model_batchsize.txt"
[[ ! -f "$task/$model_batchsize_file" ]] && echo "${file} not exist" && exit 1

cd $task

while read model batch_size ; do
    echo Model: $model
    echo Batch_size: $batch_size

    model_name=${model#*/}

    bash $train_script -m $model -b $batch_size -g $gpu
    
    # echo Done training $model
    # echo Terminal log: $terminal_log_file
    # echo Results file: $output_dir/all_results.json
    # echo Other results: $output_dir

done < $model_batchsize_file

echo Done