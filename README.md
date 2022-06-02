# True D6

The following is an api that should (it is not checked) throw something very very close to a d6, in fact, it is as close as you want, but it will never be a d6 (classic cs). The api consist on 3 links: 
  - https://true-d6-999birds.herokuapp.com/main_seq 
  - https://true-d6-999birds.herokuapp.com/resampled/full_seq/seed
  - https://true-d6-999birds.herokuapp.com/resampled/dice/seed&count <br/>
 
The first one gives the main binary sequence which will generate the resampled ones, the second gives the resampled sequences (with the seed as an input), and the third one gives a sampled d6 dice with the seed and count of sequence as inputs, example: https://true-d6-999birds.herokuapp.com/resampled/dice/1523&3.
<br><br>


# Main Sequence Creation
Lately i have been playing with pseudorandom generators, the "pseudo" aspect is very intriguing to me, the reason is that in order to find a truly random sequence, all i could find is some usage of radioactive material; but why not use data from the world? surely there must be some kind of true randomness in (for example) the costumer default on credit card data; and thats exactly what i'm going to use as input: https://www.kaggle.com/competitions/amex-default-prediction/data?select=train_labels.csv .
The main objective is to create a random binary sequence: {1,1,1,0,0,1...}.

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

<br><br>

# Entropy Problem

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

But now we have an entropy problem, lets suppose that even though the 'Info' sequence is truly random, it has 0.9 prob of getting a 1:

$$prob_{info}(x=1)=0.9$$

And the 'Not Random' sequence is 0,1,0,1,0,1,0,1,0..., then the 'Resample' sequence will not be truly random: 

### First:

Without knowing anything about the previous sequence, the probability of 'Resample' of being 1 is:

$$prob_{res}(1|seq={...}) = prob_{info}(1|seq={...}) * prob_{notrand}(0|seq={...}) + prob_{info}(0|seq={...}) * prob_{notrand}(1|seq={...})$$

$$prob_{res}(x=1|seq={...}) = 0.9 * 0.5 + 0.1* 0.5 = 0.5$$


Good, it is perfectly random.

<hr/>

### Second:

Lets see what happens after seeing the previous value of the sequence (equal to 1):

$$prob_{res}(1|seq={1,..}) = prob_{info}(1|seq={1,..}) * prob_{notrand}(0|seq={1,..}) + prob_{info}(0|seq={1,..}) * prob_{notrand}(1|seq={1,..})$$

Because the info is truly random and it doesnt depend on the previous sequence:

$$prob_{res}(x=1|seq={1,...}) = 0.9 * prob_{notrand}(x=0|seq={1,...}) + 0.1 * prob_{notrand}(x=1|seq={1,...})$$ 

But we can infer the probability of the previous 'Not Random' value using the bayesian formula:

$$prob_{notrand,t-1}(x=0|seq={1,...}) = (0.5 * 0.9) / (0.5 * 0.9 + 0.5 * 0.1) = 0.9$$

But, if the previous value is 0, then (given the pattern of not random) the next value is one, so:

$$prob_{notrand}(x=1|seq={1,...}) = 0.9$$

So we have:

$$prob_{res}(x=1|seq={1,...}) = 0.9 * 0.1 + 0.1 * 0.9 = 0.18$$ 

We have that the probability depends on the previous sequence, so there is a pattern.
<hr/>
<br>

## How to preserve the randomness?
After the XOR combo, the 'Resample' will only be truly random if the probability of 'Info' of getting a 1 is 0.5:
### Proof: 

We know the probability of 'Resample' of the next variable given the previous sequence is:
  
$$prob_{resample}(x=1|seq) = prob_{info}(x=1|seq) * prob_{notrandom}(x=0|seq) + prob_{info}(x=0|seq) * prob_{notrandom}(x=1|seq)$$

But because the 'Info' is truly random, the probability doesn't depend on the previous sequence of values:
$$prob_{info}(x=1|seq) = prob_{info}(x=1)$$
And we also know that 'Info' has max entropy:
$$prob_{info}(x=1|seq) = prob_{info}(x=1) = 0.5$$
Then the 'Resample' prob is:
$$prob_{resample}(x=1|seq) = 0.5 * prob_{notrandom}(x=0|seq) + 0.5 * prob_{notrandom}(x=1|seq)$$
$$prob_{resample}(x=1|seq) = 0.5 * (prob_{notrandom}(x=0|seq) + prob_{notrandom}(x=1|seq))$$
But, thanks to the rules of probability:
$$prob_{notrandom}(x=0|seq) + prob_{notrandom}(x=1|seq) = 1$$
So:
$$prob_{resample}(x=1|seq) = 0.5 * 1 = 0.5$$

We have proved that if 'Info' has max entropy, then there will not be any pattern in the XOR combo. This result holds independent of the 'Not Random' sequence patterns.

<br><br>

# Maximizing Entropy
 
We want to force the formula:
$$prob_{info}(x=1) = 0.5$$ 

To do so, we are going to cut de 'Info' column in 2 halfs ('Info1' 'Info2') and do the XOR operation:
| Info1          | Info2| NewInfo|
| ------------- | ------------- | ------------- | 
|1|1|0|
|1|0|1|
|0|1|1|
|1|1|0|
|0|1|1|
|1|0|1|
|0|0|0|
|.|.|.|
|.|.|.|
|.|.|.|

The probability of 'New Info' will be:

$$prob_{newinfo}(x=1|seq) = prob_{info1}(x=1|seq) * prob_{info2}(x=0|seq) + prob_{info1}(x=0|seq) * prob_{info2}(x=1|seq)$$

The probs of 'Info1' and 'Info1' don't depend on the sequence:

$$prob_{newinfo}(x=1) = prob_{info1}(x=1) * prob_{info2}(x=0) + prob_{info1}(x=0) * prob_{info2}(x=1)$$

And are symmetrical:

$$prob_{newinfo}(x=1) = 2 * prob_{info1}(x=1) * prob_{info1}(x=0)$$

Also are the same as the 'Info' column:
$$prob_{newinfo}(x=1) = 2 * prob_{info}(x=1) * prob_{info}(x=0)$$
$$prob_{newinfo}(x=1) = 2 * prob_{info}(x=1) * (1 - prob_{info}(x=1))$$

So we get a logistic map with r=2, in the sense that we will repeat this process lots of times, and so the probability will converge to 0.5; there are two problems:
1) It will never be 0.5 exactly but we can make it as close as we want to.
2) Every time we repeat the process of cutting and XORing, we reduce the row count by a factor of 2.

We have created a truly random sequence 'Rand' with $$prob_{rand}(x=1) \approx 0.5$$

<br><br>

# Resampling

To make a resampling of the sequence, we can create a new column, either not random or pseudo random and do the XOR operation:
| Rand          | PseudoRand| Resample|
| ------------- | ------------- | ------------- | 
|0|1|1|
|0|0|0|
|0|1|1|
|1|0|1|
|0|0|0|
|1|0|1|
|0|0|0|
|.|.|.|
|.|.|.|
|.|.|.|


<br><br>

# Testing

I know there are randomness tests, in the future i want to test the sequence against the NIST randomness test suite, but i need to concat more data, currently i have only 25000 rows only.

