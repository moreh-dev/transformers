model=$1
batch_size=$2
output_dir=${3:-"./outputs/$model"}

args="
--do_train
--do_eval
--learning_rate 5e-5
--num_train_epochs 3 
--overwrite_output
--use_auth_token True
--save_total_limit 2
"

python3 run_swag.py \
    --model_name_or_path $model \
    --per_device_eval_batch_size $batch_size \
    --per_device_train_batch_size $batch_size \
    --output_dir $output_dir \
    $args \