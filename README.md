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

This idea comes from the econometrics concept called "instrumental variable", so lets say we import the world information with a column 'Info' containing a dummy variable:
| Info          | 
| ------------- | 
|1| 
|1| 
|1|
|0|
|0|
|0|
|1|
|.|
|.|
|.|

We dont know if there is some kind of pattern hidden by itself, or it is the same as saying that maybe the 'Info' column has some kind of relationship with de 'Index' column:

| Info          | Index|
| ------------- | ------------- | 
|1|0| 
|1|1|
|1|2|
|0|3|
|0|4|
|0|5|
|1|6|
|.|.|
|.|.|
|.|.|

The trick is to search for a new column in the original dataset that we know is not correlated with the 'Info' column, this is the 'Instrument' colummn; and this is the make it or break it point, because if there is any correlation, then it's not going to work (it doesn't matter if the instrument is related to the Index column):

| Info          | Index| Instrument|
| ------------- | ------------- | ------------- | 
|1|2|29|
|0|3|7|
|1|0|4|
|1|1|6|
|0|4|23|
|0|5|57|
|1|6|15|
|.|.|.|
|.|.|.|
|.|.|.| 


Now we just order the 'Instrument' column, and because of the independence of the 'Instrument' with the 'Info', every pattern in the 'Info' should dissapear, with the ordering of 'Instrument' we create disorder in 'Info':

| Info          | Index| Instrument|
| ------------- | ------------- | ------------- | 
|1|0|4|
|1|1|6|
|0|3|7|
|1|6|15|
|0|4|23|
|1|2|29|
|0|5|57|
|.|.|.|
|.|.|.|
|.|.|.| 


## Entropy Problem

We've got a truly random sequence ('Info'), but we want to be able to resample the sequence, so lets do it, we can create a new sequence called 'Not Random' and do a 'XOR' operation between 'Info' and 'Not Random' to get the new resample:

| Info          | Not Random| Resample|
| ------------- | ------------- | ------------- | 
|1|0|1|
|1|1|0|
|0|0|0|
|1|1|0|
|0|0|0|
|1|1|0|
|0|0|0|
|.|.|.|
|.|.|.|
|.|.|.|

But now we have an entropy problem, the 'Resample' will only be truly random if the probability of 'Info' of getting a 1 is: info_prob(x=1)=0.5 


<h3> Proof: <h3/>
  

We know the probability of 'Resample' of the next variable given the previous sequence is:
  
<img src="https://latex.codecogs.com/gif.latex?resample_prob(x=1|{...0,1,1,0,1})=info_prob(x=1|{...0,1,1,0,1})*notrandom_prob(x=0|{...0,1,1,0,1})+info_prob(x=0|{...0,1,1,0,1})*notrandom_prob(x=1|{...0,1,1,0,1})" /> 
  
 - <img src="https://latex.codecogs.com/gif.latex?O_t=\text { Onset event at time bin } t " /> 
  
<img src="[https://latex.codecogs.com/svg.image?prob(x=1)=5](https://latex.codecogs.com/svg.image?\bg{white}prob(x=1)=5)"/>
  
![equation](http://latex.codecogs.com/gif.latex?O_t%3D%5Ctext%20%7B%20Onset%20event%20at%20time%20bin%20%7D%20t)
  
$$info_prob(x=1)=0.5 $$
 
