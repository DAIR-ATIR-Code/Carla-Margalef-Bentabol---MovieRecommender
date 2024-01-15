# MovieRecommender

Automatic Movie Recommendation System using Tensorflow and TensorRT.

---
This project implements a Movie Recommendation System using
[MovieLens data](https://grouplens.org/datasets/movielens/).

The model and training and evaluation methods are based on 
[Neural Collaborative Filtering (He et al. 2017)](https://dl.acm.org/citation.cfm?id=3052569).

The data processing, model and training modules leverage [Tensorflow](https://www.tensorflow.org/)
and [Keras](https://keras.io/). There are scripts to export a trained model into a
[NVIDIA TensorRT](https://developer.nvidia.com/tensorrt)
compatible model, and to run a sample command-line client to request inferences to a model deployed and running in a
[NVIDIA TensorRT Inference Server](https://docs.nvidia.com/deeplearning/sdk/tensorrt-inference-server-guide/docs/).

---
### How to Clone to a Local Repository

Make sure you have git installed on your local machine, you have an ssh key for code.canarie.ca and you have properly setup your ~/.ssh/config.
(See support section below if you need help with that.)

Once you are ready to clone the repository, run the following command on your local machine:
```bash
git clone git@github.com:DAIR-ATIR-Code/Carla-Margalef-Bentabol---MovieRecommender.git       
```

#### How to Get Support

Send email to dair.admin@canarie.ca
