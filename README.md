First release of ete-lib.

This lib is the basis of MDE tools (Model Driven Engineering tools).
It defines pipelines made of transformations.
A transformation takes a model on entry and return a model.
The pipeline provides a model to its first action and takes the result of an action as the parameter of the next one.

The lib contains some basic actions.
The most important one is a text generation action which returns the model it receives without transformation.
The text generation actions uses a template language derived from XSLT
