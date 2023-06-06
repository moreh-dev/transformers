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

LOG_DIR="logs"
mkdir -p $task/$LOG_DIR

OUTPUT_DIR="outputs"
mkdir -p $task/$OUTPUT_DIR

# Train each model in task
# ==================================

cd $task

while read model batch_size ; do
    echo Running: $model
    echo Batchsize: $batch_size

    model_name=${model#*/}

    log_file="${LOG_DIR}/${model_name}.log"
    output_dir="${OUTPUT_DIR}/${model_name}"

    bash $train_script $model $batch_size $output_dir 2>&1 | tee $log_file

    echo Done training $model
    echo Terminal log: $log_file
    echo Results file: $output_dir/all_results.json
    echo Other results: $output_dir

done < $model_batchsize_file

echo Done