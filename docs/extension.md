# Extension proposal

## Pipeline Management

A shortcoming we encountered during development of this project, is the current model pipeline management. Although we make use of [DVC](https://dvc.org/) with a custom OAuth client configured, we are not able to publicly share the model pipeline history through DVC.

This shortcoming is a direct result of using Google Drive, which provides limited shared folder access for the Google Drive API used by DVC. The folder which is used to store intermediate results is publicly viewable, but the API limits access to the given folder. 

The current state of our DVC implementation enables us to access and add versioned data by sharing secrets locally, while the pipeline makes use of a Service Account to do so.

The pipeline management in its current state is compliant with the assignments, yet it does not fully serve its purpose.  
All code and pipeline outputs are publicly available, with the data version control as an exception.

An external reviewer, user or developer would not be able to access the current state of the input, intermediate, or resulting data output. To do so, one needs to contact the developers involved, and developers need to share sensitive secrets.

## Improving Pipeline Management

To improve upon the existing pipeline management, we propose to replace the Google Drive implementation with a publicly accessible storage backend.

A solution would be to use an S3 remote with public read access, and accessing it through HTTP ([as described here](https://discuss.dvc.org/t/public-read-only-s3-remote/355)). 

A secondary solution would be to use a HTTP remote all together (again with public read access), enabling an external user to pull data without authentication.

Both solutions would enable a user to directly view and run the project locally, without needing to obtain project specific secrets. 

## Validating Improvement

Finally, to validate the improvement, we can reproduce the cloning and running of the [model-training](https://github.com/remla25-team22/model-training) pipeline in a clean environment:

- Clone `model-training`
- Pull using DVC
- Repro using DVC