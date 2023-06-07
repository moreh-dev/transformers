# Check input files
# ==================================

task=$1
echo Task: $task

train_script=${2:-"train.sh"}
bash all_scripts/check_file_exist.sh $train_script $task


model_batchsize_file=${3:-model_batchsize.txt}
bash all_scripts/check_file_exist.sh $model_batchsize_file $task


# Create log and output dir inside task folder
# ==================================

LOG_DIR=$(pwd)/logs/$task
mkdir -p $LOG_DIR

OUTPUT_DIR=$(pwd)/outputs/$task
mkdir -p $OUTPUT_DIR

# Go into task folder and run train script
# ==================================

# cd $task

while read model batch_size ; do
    echo Model: $model
    echo Batch_size: $batch_size

    model_name=${model#*/}

    terminal_log_file="${LOG_DIR}/${model_name}_terminal.log"
    memory_log_file="${LOG_DIR}/${model_name}_memory.log"

    output_dir="${OUTPUT_DIR}/${model_name}"

    commands_to_run="
        cd $task
        bash $train_script $model $batch_size $output_dir
    "

    bash record.sh 0 $memory_log_file $terminal_log_file "$commands_to_run"

    # echo Done training $model
    # echo Terminal log: $terminal_log_file
    # echo Results file: $output_dir/all_results.json
    # echo Other results: $output_dir

done < $task/$model_batchsize_file

echo Done