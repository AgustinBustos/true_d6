# true_d6

The following is an api that should (it is not checked) throw something very very close to a d6, in fact, it is as close as you want, but it will never be a d6 (classic cs). The api consist on 3 links: 
  - https://true-d6-999birds.herokuapp.com/main_seq 
  - https://true-d6-999birds.herokuapp.com/resampled/full_seq/seed
  - https://true-d6-999birds.herokuapp.com/resampled/dice/seed&count <br/>
The first one gives the main binary sequence which will generate the resampled ones, the second gives the resampled sequences (with the seed as an input), and the third one gives a sampled dice with the seed and count of sequence as inputs
