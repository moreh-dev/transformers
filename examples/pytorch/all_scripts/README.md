# Using master script
The master script will call the train script in each task with the arguments taking from the file model_batchsize.txt.
The model_batchsize.txt contain: model_name batch_size device_id and other args if needed.
For examble: bert-base-uncased 64 1 mrpc
When run the master script, you can add one of these flag:
-s or --show: To show all task available
-h ir --help: To show what other flags mean
-t or --task <task-name>: To run train script for one specific task
-a or --all: To run the train script for all the tasks

Some task has more than one train script. Therefore, the task shown when using -s and when run in -t must be specific.
For example, inside text-classifcation task has 2 train script for glue and xnli. In the master script will have 2 task for those script *text-classification-glue* and *text-classification-xlni*

**Note 1**: The model names inside the model_batchsize.txt will be use to run by all the script in that task so make sure the model all the script can run this model. Some models require special args or train script should be run manually. 

**Note 2**: Currently this script can only run the train script with 3 args: <model_names> <batch_size>, and <device_id> other args must be set a default value in their train script, otherwise this script will rise an errors.
I will find a way to fix this in the futures.

## Train one task
Run the master script with the option -t and task name.
For example: `bash master.sh -t text-cls-glue`
## Train all the tasks
Run the master script with the option -a.
For example: `bash master.sh -a`