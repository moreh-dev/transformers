import time

import mlflow
from transformers import (Seq2SeqTrainingArguments, TrainerCallback,
                          TrainerControl, TrainerState, TrainingArguments)


# Log number of parameters function
def get_num_parameters(model):
    num_params = 0
    for param in model.parameters():
        num_params += param.numel()
    # in million
    num_params /= 10**6
    return num_params


class TBTrainerCallbackForSeq2Seq(TrainerCallback):
    "A callback log loss, learning rate, and throughput each logging step"
    start_time = time.time()

    def on_step_begin(self, args: Seq2SeqTrainingArguments,
                      state: TrainerState, control: TrainerControl, **kwargs):
        if args.logging_strategy == 'steps':
            if state.global_step == 0 or state.global_step % args.logging_steps == 1:
                self.start_time = time.time()

    def on_epoch_begin(self, args: Seq2SeqTrainingArguments,
                       state: TrainerState, control: TrainerControl, **kwargs):
        if args.logging_strategy == 'epoch':
            self.start_time = time.time()

    def on_log(self, args: Seq2SeqTrainingArguments, state: TrainerState,
               control: TrainerControl, **kwargs):
        logging_runtime = time.time() - self.start_time
        num_samples = args.per_device_train_batch_size * args.logging_steps
        throughput = num_samples / logging_runtime
        if 'loss' in state.log_history[-1]:
            state.log_history[-1]["throughput"] = throughput
            if args.logging_strategy == 'steps':
                state.log_history[-1]["step"] = state.global_step

                mlflow.log_metric("lr",
                                  state.log_history[-1]["learning_rate"],
                                  step=state.global_step)
                mlflow.log_metric("throughput",
                                  throughput,
                                  step=state.global_step)
                print(
                    f'loss: {state.log_history[-1]["loss"]}, lr: {state.log_history[-1]["learning_rate"]},\
                       throughput: {throughput}, step: {state.global_step}')
            if args.logging_strategy == 'epoch':
                state.log_history[-1]["epoch"] = state.epoch

                mlflow.log_metric("lr",
                                  state.log_history[-1]["learning_rate"],
                                  step=state.epoch)
                mlflow.log_metric("throughput", throughput, step=state.epoch)
                print(
                    f'loss: {state.log_history[-1]["loss"]}, lr: {state.log_history[-1]["learning_rate"]},\
                      throughput: {throughput}, epoch: {state.epoch}')


class TBTrainerCallback(TrainerCallback):
    "A callback log loss, learning rate, and throughput each logging step"
    start_time = time.time()

    def on_step_begin(self, args: TrainingArguments, state: TrainerState,
                      control: TrainerControl, **kwargs):
        if args.logging_strategy == 'steps':
            if state.global_step == 0 or state.global_step % args.logging_steps == 1:
                self.start_time = time.time()

    def on_epoch_begin(self, args: TrainingArguments, state: TrainerState,
                       control: TrainerControl, **kwargs):
        if args.logging_strategy == 'epoch':
            self.start_time = time.time()

    def on_log(self, args: TrainingArguments, state: TrainerState,
               control: TrainerControl, **kwargs):
        logging_runtime = time.time() - self.start_time
        num_samples = args.per_device_train_batch_size * args.logging_steps
        throughput = num_samples / logging_runtime
        if 'loss' in state.log_history[-1]:
            state.log_history[-1]["throughput"] = throughput
            if args.logging_strategy == 'steps':
                state.log_history[-1]["step"] = state.global_step

                mlflow.log_metric("lr",
                                  state.log_history[-1]["learning_rate"],
                                  step=state.global_step)
                mlflow.log_metric("throughput",
                                  throughput,
                                  step=state.global_step)
                print(
                    f'loss: {state.log_history[-1]["loss"]}, lr: {state.log_history[-1]["learning_rate"]},\
                       throughput: {throughput}, step: {state.global_step}')
            if args.logging_strategy == 'epoch':
                state.log_history[-1]["epoch"] = state.epoch

                mlflow.log_metric("lr",
                                  state.log_history[-1]["learning_rate"],
                                  step=state.epoch)
                mlflow.log_metric("throughput", throughput, step=state.epoch)
                print(
                    f'loss: {state.log_history[-1]["loss"]}, lr: {state.log_history[-1]["learning_rate"]},\
                      throughput: {throughput}, epoch: {state.epoch}')
