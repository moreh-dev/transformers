# Using the Master Script
The Master Script will call the train script for each task, with the arguments taken from the file `model_batchsize.txt`. This file contains the model name, batch size, device ID, and any other required arguments. For example: `bert-base-uncased 64 1 mrpc`

When running the Master Script, you can add one of the following flags:
- `-s` or `--show`: to show all available tasks.
- `-h` or `--help`: to show the meaning of other flags.
- `-t` or `--task <task-name>`: to run the train script for one specific task.
- `-a` or `--all`: to run the train script for all tasks.

Note that some tasks have more than one train script. Therefore, the task shown when using the `-s` flag and when running with the `-t` flag must be specific. For example, the `text-classification` task has two train scripts for `glue` and `xlni`. In the Master Script, these will be represented as `text-classification-glue` and `text-classification-xlni`.

**Note 1**: The model names inside the `model_batchsize.txt` file will be used to run all the scripts in that task, so it's important to ensure that the model can be run by all the scripts for that task. Some models require special arguments or the train script may need to be run manually.

**Note 2**: Currently, this script can only run train scripts with three arguments: `model_name`, `batch_size`, and `device_id`. Any additional arguments must have a default value set in the train script, otherwise, the script will raise an error.

## Train One Task
To run the Master Script for one task, use the `-t` option followed by the task name. For example: `bash master.sh -t text-classification-glue`

## Train All Tasks
To run the Master Script for all tasks, use the `-a` option. For example: `bash master.sh -a`