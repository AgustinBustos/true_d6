# True D6

The following is an api that should (it is not checked) throw something very very close to a d6, in fact, it is as close as you want, but it will never be a d6 (classic cs). The api consist on 3 links: 
  - https://true-d6-999birds.herokuapp.com/main_seq 
  - https://true-d6-999birds.herokuapp.com/resampled/full_seq/seed
  - https://true-d6-999birds.herokuapp.com/resampled/dice/seed&count <br/>
 
The first one gives the main binary sequence which will generate the resampled ones, the second gives the resampled sequences (with the seed as an input), and the third one gives a sampled d6 dice with the seed and count of sequence as inputs, example: https://true-d6-999birds.herokuapp.com/resampled/dice/1523&3.
<br><br>


# Main Sequence Creation
Lately i have been playing with pseudorandom generators, the "pseudo" aspect is very intriguing to me, the reason is that in order to find a truly random sequence, all i could find is some usage of radioactive material; but why not use data from the world? surely there must be some kind of true randomness in (for example) the costumer default on credit card data; and thats exactly what i'm going to use as input: https://www.kaggle.com/competitions/amex-default-prediction/data?select=train_labels.csv .
The main objective is to create a random binary sequence: {1,1,1,0,0,1...}

## Instrumental Variable

This idea comes from the econometrics concept called "instrumental variable", so lets say we import the world information with a column 'info' containing a dummy variable:
| Info          | 
| ------------- | 
| 1  | 
|0 | 

