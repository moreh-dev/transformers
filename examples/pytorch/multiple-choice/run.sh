model=$1
bs=$2

model_name=${model#*/}

# terminal log
LOG_DIR="./logs"
mkdir -p $LOG_DIR
log_file="${LOG_DIR}/${model_name}.log"

# trainer API output
OUTPUT_DIR="./outputs"
mkdir -p $OUTPUT_DIR
output_dir="${OUTPUT_DIR}/${model_name}"

# read args and start training
ARGS="$(<args.txt)"

python3 ./run_swag.py \
    --model_name_or_path $model \
    --output_dir $output_dir \
    --per_device_eval_batch_size $bs \
    --per_device_train_batch_size $bs \
    --do_train \
    --do_eval \
    ${ARGS} \
    2>&1 | tee $log_file