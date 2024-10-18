The goal of this project was to use Natural Language Processing (NLP) models to predict whether a property listed on Airbnb would be unlisted in the next quarter.
The project was developed using Python and libraries such as NLTK, Scikit Learn, Keras and PyTorch. 

For **Data Preprocessing**, we created a clean pipeline that dealed with text standardization, outliers and missing values treatment, sentiment analysis and created a summary.

For **Word Embedding**, we used:
  - GloVe
  - FastText
  - Wiki2Vec
  - Transformer-based Embeddings, such as mBert and XLM-RoBERTa.

The **classification models** used were:
  - Logistic Regression
  - Naive Bayes
  - K-Nearest Neighbours
  - Multi-Layered Perceptron
  - Random Forest
  - XGBoost

We were able to achieve a **F1 macro score of 0.87**. 

